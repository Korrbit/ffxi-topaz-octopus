
# Configure Docker provider and connect to the local Docker socket
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "docker-registry" {
  name = "registry:latest"
}

resource "docker_container" "registry" {
    image = "${docker_image.docker-registry.latest}"
    name = "registry"
    ports = 
    {
        internal = 5000
        external = 5000
    }
    restart = "always"
}

# Need to include a wait-for-it type of approach not only for the docker containers docker-entrypoint.sh files
# but also for terraform such that after the registry container is built, the docker-file builds will
# successfully upload to the registry. 

resource "null_resource" "wait-for-it" {
    provisioner "local-exec" {
        command = "chmod a+x wait-for-it.sh && ./wait-for-it.sh localhost:5000 --timeout=0"
    }
}

# here we are providing the commands to build the docker images that will be used, and push them
# to the local repository
resource "null_resource" "topaz-build" {
    depends_on = ["docker_container.registry"]
    provisioner "local-exec" {
      command = "cd topaz-build && docker build --build-arg FFXI_REPO=${var.topaz_git_repo} --build-arg FFXI_BRANCH=${var.topaz_branch} --build-arg VER_LOCK=${var.ver_lock} -t topaz-build:latest . && docker tag topaz-build localhost:5000/topaz-build && docker push localhost:5000/topaz-build"
    }
}

resource "null_resource" "topaz-db" {
  depends_on = ["docker_container.registry"]
    provisioner "local-exec" {
      command = "cd topaz-db && docker build --build-arg FFXI_REPO=${var.topaz_git_repo} --build-arg FFXI_BRANCH=${var.topaz_branch} --build-arg MYSQL_DATABASE=${var.topaz-db} -t topaz-db:latest . && docker tag topaz-db localhost:5000/topaz-db && docker push localhost:5000/topaz-db"
    }
}

resource "null_resource" "topaz-connect" {
  depends_on = ["docker_container.registry"]
  provisioner "local-exec" {
      command = "cd topaz-connect && docker build --build-arg MYSQL_DATABASE=${var.topaz-db} -t topaz-connect:latest . && docker tag topaz-connect localhost:5000/topaz-connect && docker push localhost:5000/topaz-connect"
  }
}

resource "null_resource" "topaz-game" {
  depends_on = ["docker_container.registry"]
  provisioner "local-exec" {
      command = "cd topaz-game && docker build --build-arg MYSQL_HOST=${var.topaz-db} -t topaz-game:latest . && docker tag topaz-game localhost:5000/topaz-game && docker push localhost:5000/topaz-game"
  }
}

resource "null_resource" "topaz-search" {
depends_on = ["docker_container.registry"]
  provisioner "local-exec" {
      command = "cd topaz-search && docker build --build-arg MYSQL_DATABASE=${var.topaz-db} -t topaz-search:latest . && docker tag topaz-search localhost:5000/topaz-search && docker push localhost:5000/topaz-search"
  }
}

resource "null_resource" "topaz-ahbroker" {
  depends_on = ["docker_container.registry"]
  provisioner "local-exec" {
    command = "cd topaz-ahbroker && docker build --build-arg MYSQL_HOST=${var.topaz-db} --build-arg GITHUB_REPO=${var.github_repo_ahbroker} --build-arg GITHUB_BRANCH=${var.github_branch_ahbroker} -t topaz-ahbroker:latest . && docker tag topaz-ahbroker localhost:5000/topaz-ahbroker && docker push localhost:5000/topaz-ahbroker"
  }
}

resource "docker_image" "topaz-db" {
  depends_on = ["null_resource.topaz-db"]
  name = "localhost:5000/topaz-db:latest"
  provisioner "local-exec" {
      when    = "destroy"
      command = "docker rmi -f $(docker images -q topaz-db)"
    }
}

resource "docker_image" "topaz-build" {
  depends_on = ["null_resource.topaz-build"]
  name = "localhost:5000/topaz-build:latest"
  provisioner "local-exec" {
      when    = "destroy"
      command = "docker rmi -f $(docker images -q topaz-build)"
    }
}

resource "docker_image" "topaz-connect" {
  depends_on = ["null_resource.topaz-connect"]
  name = "localhost:5000/topaz-connect:latest"
  provisioner "local-exec" {
      when    = "destroy"
      command = "docker rmi -f $(docker images -q topaz-connect)"
    }
}

resource "docker_image" "topaz-game" {
  depends_on = ["null_resource.topaz-game"]
  name = "localhost:5000/topaz-game:latest"
  provisioner "local-exec" {
      when    = "destroy"
      command = "docker rmi -f $(docker images -q topaz-game)"
    }
}

resource "docker_image" "topaz-search" {
  depends_on = ["null_resource.topaz-search"]
  name = "localhost:5000/topaz-search:latest"
  provisioner "local-exec" {
      when    = "destroy"
      command = "docker rmi -f $(docker images -q topaz-search)"
    }
}

resource "docker_image" "topaz-ahbroker" {
  depends_on = ["null_resource.topaz-ahbroker"]
  name = "localhost:5000/topaz-ahbroker:latest"
  provisioner "local-exec" {
      when    = "destroy"
      command = "docker rmi -f $(docker images -q topaz-ahbroker)"
    }
}

# If you want to have docker volumes instead of using host volume,
# uncomment the below and make the changes in each of the resource
# sections

# Creates a docker volume "db_data".
#resource "docker_volume" "db_data" {
#  name = "db_data"
#}

# Creates a docker volume "build-volume"
#resource "docker_volume" "build-volume" {
#  name="build-volue"
#}


# Create a new docker network
resource "docker_network" "topaz_network" {
  name = "ffxi_topaz"
}

# Create containers for db, ahbroker and server
resource "docker_container" "topaz-db" {
  depends_on = ["null_resource.topaz-db"]
  image = "${docker_image.topaz-db.latest}"
  name  = "${var.topaz-db}"
  hostname = "${var.topaz-db}"
  volumes = {
      host_path="${var.db_volume}"
      #volume_name="${docker_volume.db_data.name}"
      container_path="/var/lib/mysql"
  }
  env = [
      "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}",
      "MYSQL_USER=${var.mysql_login}", 
      "MYSQL_DATABASE=${var.mysql_database}", 
      "MYSQL_PASSWORD=${var.mysql_password}",
      "ZONE_IP=${var.ffxi_zoneip}"
  ]
  ports =  
      {
        internal = 3306
        external = 23055
      }
  restart="always"
  network_mode="${docker_network.topaz_network.name}"
}

resource "docker_container" "topaz-ahbroker" {
  depends_on = ["null_resource.topaz-build", "docker_container.topaz-db", "null_resource.topaz-ahbroker"]
  image = "${docker_image.topaz-ahbroker.latest}"
  name = "topaz-ahbroker"
  hostname = "topaz-ahbroker"
  env = [
    "MYSQL_HOST=${docker_container.topaz-db.name}", 
    "MYSQL_USER=${var.mysql_login}", 
    "MYSQL_DATABASE=${var.mysql_database}", 
    "MYSQL_PASSWORD=${var.mysql_password}",
    "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}",
    "AH_BOTNAME=${var.ah_botname}",
    "AH_SINGLE=${var.ah_single}",
    "AH_STACK=${var.ah_stack}"
  ]
  restart="always"
  network_mode="${docker_network.topaz_network.name}"
}

resource "docker_container" "topaz-build" {
  depends_on = ["null_resource.topaz-build"]
  image = "${docker_image.topaz-build.latest}"
  name  = "topaz-build"
  hostname = "topaz-build"
    volumes = {
      host_path="${var.build_volume}"
      #volume_name="${docker_volume.build-volume.name}"
      container_path="/usr/build"
  }
  env = [ 
      "MYSQL_HOST=${docker_container.topaz-db.name}", 
      "MYSQL_LOGIN=${var.mysql_login}",
      "MYSQL_DATABASE=${var.mysql_database}",
      "MYSQL_PASSWORD=${var.mysql_password}",
      "ZONE_IP=${var.ffxi_zoneip}",
      "SERVERNAME=${var.ffxi_servername}",
      "lightluggage_block=${var.lightluggage_block}",
      "ah_base_fee_single=${var.ah_base_fee_single}",
      "ah_base_fee_stacks=${var.ah_base_fee_stacks}",
      "ah_tax_rate_single=${var.ah_tax_rate_single}",
      "ah_tax_rate_stacks=${var.ah_tax_rate_stacks}",
      "ah_max_fee=${var.ah_max_fee}",
      "exp_rate=${var.exp_rate}",
      "exp_loss_rate=${var.exp_loss_rate}",
      "exp_party_gap_penalties=${var.exp_party_gap_penalties}",
      "fov_allow_alliance=${var.fov_allow_alliance}",
      "vanadiel_time_offset=${var.vanadiel_time_offset}",
      "fame_multiplier=${var.fame_multiplier}",
      "exp_retain=${var.exp_retain}",
      "exp_loss_level=${var.exp_loss_level}",
      "level_sync_enable=${var.level_sync_enable}",
      "disable_gear_scaling=${var.disable_gear_scaling}",
      "all_jobs_widescan=${var.all_jobs_widescan}",
      "speed_mod=${var.speed_mod}",
      "mob_speed_mod=${var.mob_speed_mod}",
      "skillup_chance_multiplier=${var.skillup_chance_multiplier}",
      "craft_chance_multiplier=${var.craft_chance_multiplier}",
      "player_hp_multiplier=${var.player_hp_multiplier}",
      "player_mp_multiplier=${var.player_mp_multiplier}",
      "max_merit_points=${var.max_merit_points}",
      "ENABLE_COP=${var.enable_cop}",
      "ENABLE_TOAU=${var.enable_toau}",
      "ENABLE_WOTG=${var.enable_wotg}",
      "ENABLE_ACP=${var.enable_acp}",
      "ENABLE_AMK=${var.enable_amk}",
      "ENABLE_ASA=${var.enable_asa}",
      "ENABLE_ABYSSEA=${var.enable_abyssea}",
      "ENABLE_SOA=${var.enable_soa}",
      "ENABLE_ROV=${var.enable_rov}",
      "ENABLE_VOIDWATCH=${var.enable_voidwatch}",
      "INITIAL_LEVEL_CAP=${var.initial_levl_cap}",
      "MAX_LEVEL=${var.max_level}",
      "NORMAL_MOB_MAX_LEVEL_RANGE_MIN=${var.normal_mob_max_level_range_min}",
      "NORMAL_MOB_MAX_LEVEL_RANGE_MAX=${var.normal_mob_max_level_range_max}",
      "START_GIL=${var.start_gil}",
      "START_INVENTORY=${var.start_inventory}",
      "OPENING_CUTSCENE_ENABLE=${var.opening_cutscene_enable}",
      "ALL_MAPS=${var.all_maps}",
      "UNLOCK_OUTPOST_WARPS=${var.unlock_outpost_warps}",
      "USE_ADOULIN_WEAPON_SKILL_CHANGES=${var.use_adoulin_weapon_skill_changes}",
      "HEALING_TP_CHANGE=${var.healing_tp_change}",
      "LandKingSystem_NQ=${var.landkingsystem_nq}",
      "LandKingSystem_HQ=${var.landkingsystem_hq}",
      "BETWEEN_2DYNA_WAIT_TIME=${var.between_2dyna_wait_time}",
      "DYNA_MIDNIGHT_RESET=${var.dyna_midnight_reset}",
      "DYNA_LEVEL_MIN=${var.dyna_level_min}",
      "TIMELESS_HOURGLASS_COST=${var.timeless_hourglass_cost}",
      "PRISMATIC_HOURGLASS_COST=${var.prismatic_hourglass_cost}",
      "CURRENCY_EXCHANGE_RATE=${var.currency_exchange_rate}",
      "RELIC_2ND_UPGRADE_WAIT_TIME=${var.relic_2nd_upgrade_wait_time}",
      "RELIC_3RD_UPGRADE_WAIT_TIME=${var.relic_3rd_upgrade_wait_time}",
      "FREE_COP_DYNAMIS=${var.free_cop_dynamis}",
      "OldSchoolG1=${var.oldschoolg1}",
      "OldSchoolG2=${var.oldschoolg2}",
      "FrigiciteDuration=${var.fragiciteduration}",
      "SNEAK_INVIS_DURATION_MULTIPLIER=${var.sneak_invisi_duration_multiplier}",
      "ENABLE_COP_ZONE_CAP=${var.enable_cop_zone_cap}",
      "NUMBER_OF_DM_EARRINGS=${var.number_of_dm_earrings}",
      "HOMEPOINT_TELEPORT=${var.homepoint_teleport}",
      "ENM_COOLDOWN=${var.enm_cooldown}",
      "FORCE_SPAWN_QM_RESET_TIME=${var.force_spawn_qm_reset_time}",
      "VISITANT_BONUS=${var.visitant_bonus}"
      ]

  network_mode="${docker_network.topaz_network.name}"
}

resource "docker_container" "topaz-connect" {
  depends_on = ["null_resource.topaz-build", "docker_container.topaz-build", "null_resource.topaz-connect"]
  image = "${docker_image.topaz-connect.latest}"
  name = "topaz-connect"
  hostname = "topaz-connect"
  volumes = {
      host_path="${var.build_volume}"
      #volume_name="${docker_volume.build-volume.name}"
      container_path="/usr/build"
  }
  ports = [
      {
          internal = 54001
          external = 54001
      },
      {
          internal = 54230
          external = 54230
      },
      {
          internal = 54231
          external = 54231
      }
  ]
  restart="always"
  network_mode="${docker_network.topaz_network.name}"
}

resource "docker_container" "topaz-game" {
  depends_on = ["null_resource.topaz-build", "docker_container.topaz-connect", "null_resource.topaz-game"]
  image = "${docker_image.topaz-game.latest}"
  count = "${length(keys(local.single))}"
  name = "${lookup(local.single[element(keys(local.single), count.index)], "name")}"
  hostname = "${lookup(local.single[element(keys(local.single), count.index)], "name")}"
  #memory = 25
  volumes = {
      host_path="${var.build_volume}"
      #volume_name="${docker_volume.build-volume.name}"
      container_path="/usr/build"
  }
  ports = [
      {
        protocol = "udp"
        internal = "${lookup(local.single[element(keys(local.single), count.index)], "zoneport")}"
        external = "${lookup(local.single[element(keys(local.single), count.index)], "zoneport")}"
      }
  ]
    env = [
      "MYSQL_HOST=${docker_container.topaz-db.name}", 
      "MYSQL_LOGIN=${var.mysql_login}",
      "MYSQL_DATABASE=${var.mysql_database}",
      "MYSQL_PASSWORD=${var.mysql_password}",
      "zoneids=${lookup(local.single[element(keys(local.single), count.index)], "zoneids")}",
      "zoneport=${lookup(local.single[element(keys(local.single), count.index)], "zoneport")}"
  ]
  restart="always"
  network_mode="${docker_network.topaz_network.name}"
}

resource "docker_container" "topaz-search" {
  depends_on = ["null_resource.topaz-build", "docker_container.topaz-connect", "null_resource.topaz-search"]
  image = "${docker_image.topaz-search.latest}"
  name = "topaz-search"
  hostname = "topaz-search"
  volumes = {
      host_path="${var.build_volume}"
      #volume_name="${docker_volume.build-volume.name}"
      container_path="/usr/build"
  }
  ports = [
      {
        internal = 54002
        external = 54002
      }
  ]
  restart="always"
  network_mode="${docker_network.topaz_network.name}"
}