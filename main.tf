
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

# here we are providing the commands to build the docker images that will be used, and push them
# to the local repository
resource "null_resource" "docker_file" {
    provisioner "local-exec" {
      command = "cd darkstar-server && docker build -t darkstar-server:latest . && docker tag darkstar-server localhost:5000/darkstar-server && docker push localhost:5000/darkstar-server"
    }
}

resource "null_resource" "docker_file2" {
    provisioner "local-exec" {
      command = "cd darkstar-db && docker build -t darkstar-db:latest . && docker tag darkstar-db localhost:5000/darkstar-db && docker push localhost:5000/darkstar-db"
    }
}

resource "null_resource" "docker_file3" {
    provisioner "local-exec" {
      command = "cd darkstar-ahbroker && docker build -t darkstar-ahbroker:latest . && docker tag darkstar-ahbroker localhost:5000/darkstar-ahbroker && docker push localhost:5000/darkstar-ahbroker"
    }
}

resource "docker_image" "darkstar-server" {
  name = "localhost:5000/darkstar-server:latest"
}

resource "docker_image" "darkstar-db" {
  name = "localhost:5000/darkstar-db:latest"
}

resource "docker_image" "darkstar-ahbroker" {
  name = "localhost:5000/darkstar-ahbroker:latest"
}

# Creates a docker volume "db_data".
resource "docker_volume" "db_data" {
  name = "db_data"
}

# Create a new docker network
resource "docker_network" "darkstar_network" {
  name = "ffxi_darkstar"
}

# Create containers for db, ahbroker and server
resource "docker_container" "darkstar-db" {
  image = "${docker_image.darkstar-db.latest}"
  name  = "darkstar-db"
  hostname = "darkstar-db"
  volumes = {
      volume_name="${docker_volume.db_data.name}"
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
}

resource "docker_container" "darkstar-server" {

  image = "${docker_image.darkstar-server.latest}"
  name  = "darkstar-server"
  hostname = "darkstar-server"
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
  ports = [ 
      {
        internal = 54230
        external = 54230
      },
      {
        protocol = "udp"
        internal = 54230
        external = 54230
      },
      {
        internal = 54231
        external = 54231
      }, 
      {
        internal = 54001
        external = 54001
      },
      {
        internal = 54002
        external = 54002
      }
  ]
  restart="always"
  network_mode="${docker_network.darkstar_network.name}"
}