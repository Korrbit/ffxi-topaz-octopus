
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
# successfully upload to the registry. Currently a terrform apply needs to be run twice.

resource "null_resource" "wait-for-it" {
    provisioner "local-exec" {
        command = "chmod a+x wait-for-it.sh && ./wait-for-it.sh localhost:5000 --timeout=0"
    }
}

# here we are providing the commands to build the docker images that will be used, and push them
# to the local repository
resource "null_resource" "darkstar-dsbuild" {
    provisioner "local-exec" {
      command = "cd darkstar-dsbuild && docker build --build-arg FFXI_REPO=${var.darkstar_git_repo} --build-arg FFXI_BRANCH=${var.darkstar_branch} --build-arg VER_LOCK=${var.ver_lock} -t darkstar-dsbuild:latest . && docker tag darkstar-dsbuild localhost:5000/darkstar-dsbuild && docker push localhost:5000/darkstar-dsbuild"
    }
    depends_on = ["docker_container.registry"]
}

resource "null_resource" "darkstar-db" {
    provisioner "local-exec" {
      command = "cd darkstar-db && docker build --build-arg MYSQL_DATABASE=${var.darkstar-db} -t darkstar-db:latest . && docker tag darkstar-db localhost:5000/darkstar-db && docker push localhost:5000/darkstar-db"
    }
    depends_on = ["docker_container.registry"]
}

resource "null_resource" "darkstar-dsconnect" {
  provisioner "local-exec" {
      command = "cd darkstar-dsconnect && docker build --build-arg MYSQL_DATABASE=${var.darkstar-db} -t darkstar-dsconnect:latest . && docker tag darkstar-dsconnect localhost:5000/darkstar-dsconnect && docker push localhost:5000/darkstar-dsconnect"
  }
  depends_on = ["docker_container.registry"]
}

resource "null_resource" "darkstar-dsgame" {
  provisioner "local-exec" {
      command = "cd darkstar-dsgame && docker build --build-arg MYSQL_DATABASE=${var.darkstar-db} -t darkstar-dsgame:latest . && docker tag darkstar-dsgame localhost:5000/darkstar-dsgame && docker push localhost:5000/darkstar-dsgame"
  }
}

resource "null_resource" "darkstar-dssearch" {
  provisioner "local-exec" {
      command = "cd darkstar-dssearch && docker build --build-arg MYSQL_DATABASE=${var.darkstar-db} -t darkstar-dssearch:latest . && docker tag darkstar-dssearch localhost:5000/darkstar-dssearch && docker push localhost:5000/darkstar-dssearch"
  }
  depends_on = ["docker_container.registry"]
}

resource "null_resource" "darkstar-ahbroker" {
  provisioner "local-exec" {
    command = "cd darkstar-ahbroker && docker build -t darkstar-ahbroker:latest . && docker tag darkstar-ahbroker localhost:5000/darkstar-ahbroker && docker push localhost:5000/darkstar-ahbroker"
  }
  depends_on = ["docker_container.registry"]
}

resource "docker_image" "darkstar-db" {
  name = "localhost:5000/darkstar-db:latest"
}

resource "docker_image" "darkstar-dsbuild" {
  name = "localhost:5000/darkstar-dsbuild:latest"
}

resource "docker_image" "darkstar-dsconnect" {
  name = "localhost:5000/darkstar-dsconnect:latest"
}

resource "docker_image" "darkstar-dsgame" {
  name = "localhost:5000/darkstar-dsgame:latest"
}

resource "docker_image" "darkstar-dssearch" {
  name = "localhost:5000/darkstar-dssearch:latest"
}

resource "docker_image" "darkstar-ahbroker" {
  name = "localhost:5000/darkstar-ahbroker:latest"
}

# Creates a docker volume "db_data".
#resource "docker_volume" "db_data" {
#  name = "db_data"
#}

resource "docker_volume" "build-volume" {
  name="build-volue"
}


# Create a new docker network
resource "docker_network" "darkstar_network" {
  name = "ffxi_darkstar"
}

# Create containers for db, ahbroker and server
resource "docker_container" "darkstar-db" {
  image = "${docker_image.darkstar-db.latest}"
  name  = "${var.darkstar-db}"
  hostname = "${var.darkstar-db}"
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
  network_mode="${docker_network.darkstar_network.name}"
}

resource "docker_container" "darkstar-ahbroker" {
    image = "${docker_image.darkstar-ahbroker.latest}"
    name = "darkstar-ahbroker"
    hostname = "darkstar-ahbroker"
    env = [
      "MYSQL_HOST=${docker_container.darkstar-db.name}", 
      "MYSQL_USER=${var.mysql_login}", 
      "MYSQL_DATABASE=${var.mysql_database}", 
      "MYSQL_PASSWORD=${var.mysql_password}",
      "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}"
    ]
    restart="always"
    network_mode="${docker_network.darkstar_network.name}"
    depends_on = ["docker_container.darkstar-db"]
}

resource "docker_container" "darkstar-dsbuild" {

  image = "${docker_image.darkstar-dsbuild.latest}"
  name  = "darkstar-dsbuild"
  hostname = "darkstar-dsbuild"
    volumes = {
      volume_name="${docker_volume.build-volume.name}"
      container_path="/usr/build"
  }
  env = [ 
      "MYSQL_HOST=${docker_container.darkstar-db.name}", 
      "MYSQL_LOGIN=${var.mysql_login}", 
      "MYSQL_DATABASE=${var.mysql_database}", 
      "MYSQL_PASSWORD=${var.mysql_password}", 
      "SERVERNAME=${var.ffxi_servername}",
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

  network_mode="${docker_network.darkstar_network.name}"
  depends_on = ["null_resource.darkstar-dsbuild"]
}

resource "docker_container" "darkstar-dsconnect" {
  image = "${docker_image.darkstar-dsconnect.latest}"
  name = "darkstar-dsconnect"
  hostname = "darkstar-dsconnect"
  volumes = {
      volume_name="${docker_volume.build-volume.name}"
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
  network_mode="${docker_network.darkstar_network.name}"
  depends_on = ["docker_container.darkstar-dsbuild", "null_resource.darkstar-dsconnect"]
}

resource "docker_container" "darkstar-dsgame" {
  image = "${docker_image.darkstar-dsgame.latest}"
  name = "darkstar-dsgame"
  hostname = "darkstar-dsgame"
  volumes = {
      volume_name="${docker_volume.build-volume.name}"
      container_path="/usr/build"
  }
  ports = [
      {
        protocol = "udp"
        internal = 54230
        external = 54230
      }
  ]
  restart="always"
  network_mode="${docker_network.darkstar_network.name}"
  depends_on = ["docker_container.darkstar-dsconnect", "null_resource.darkstar-dsgame"]
}

resource "docker_container" "darkstar-dssearch" {
  image = "${docker_image.darkstar-dssearch.latest}"
  name = "darkstar-dssearch"
  hostname = "darkstar-dssearch"
  volumes = {
      volume_name="${docker_volume.build-volume.name}"
      container_path="/usr/build"
  }
  ports = [
      {
        internal = 54002
        external = 54002
      }
  ]
  restart="always"
  network_mode="${docker_network.darkstar_network.name}"
  depends_on = ["docker_container.darkstar-dsconnect", "null_resource.darkstar-dssearch"]
}