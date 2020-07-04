### Default Configuration ###

variable "topaz_git_repo" {
  default = "https://github.com/project-topaz/topaz.git"
  description = "Select the repo to push down into the dockerfiles on build. Default value: https://github.com/project-topaz/topaz.git"
}
 
variable "topaz_branch" {
  default= "release"
  description = "define which branch you wish to pull from."
}

variable "ver_lock" {
  default = "1"
  description = "0 - disabled (every version allowed) 1 - enabled - strict (only exact CLIENT_VER allowed, default) 2 - enabled - greater than or equal  (matching or greater than CLIENT_VER allowed)"
}

variable "db_volume" {
  default = "/opt/db"
  description = "unlike docker-compose, must be absolute path. physical location where database files will be stored on local system."
}

variable "build_volume" {
  default = "/home/korrbit/development/ffxi-topaz-octopus/build"
  description = "unlike docker-compose, must be absolute path. physical location where build files will be stored on local system."
}

variable "topaz-db" {
  default= "topaz-db"
  description= "topaz db container name."
}

variable "mysql_password" {
    default = "some_pass"
    description = "Password for MySQL Connection."
}

variable "mysql_root_password" {
    default = "some_pass"
    description = "Password for root."
}

variable "mysql_database" {
    default = "tpzdb"
    description = "Name of MySQL database."
}

variable "mysql_login" {
  default = "topaz"
}

variable "ffxi_servername" {
  default = "Topaz"
  description = "FFXI Server name to create."
}

variable "ffxi_zoneip" {
    default = "127.0.0.1"
    description = "IP of host system."
}

### Default Configuration ###

### AH BROKER ###

variable "github_repo_ahbroker" {
  default= "https://github.com/AdamGagorik/pydarkstar.git"
  description= "github repo for ahbroker."
}

variable "github_branch_ahbroker" {
  default= "master"
  description= "which branch to pull."
}

variable "ah_botname" {
  default = "Zissou"
  description = "Name of the buyer and seller for AH Broker"
}

variable "ah_single" {
  default = 5
  description = "How many to stock for singles"
}

variable "ah_stack" {
  default = 5
  description = "How many to stock for stacks"
}

### AH BROKER ###

### map_topaz Server Configuration ###

variable "lightluggage_block" {
  default = 4
  description = "Minimal number of 0x3A packets which uses for detect lightluggage (set 0 for disable)"
}

# AH fee structure, defaults are retail.
variable "ah_base_fee_single" {
  default = 1
}

variable "ah_base_fee_stacks" {
  default = 4
}

variable "ah_tax_rate_single" {
  default = 1.0
}

variable "ah_tax_rate_stacks" {
  default = 0.5
}

variable "ah_max_fee" {
  default = 10000
}

#Misc EXP related settings
variable "exp_rate" {
  default = 1.0
}

variable "exp_loss_rate" {
  default = 1.0
}

variable "exp_party_gap_penalties" {
 default = 1 
}

variable "fov_allow_alliance" {
  default = 1
}

variable "vanadiel_time_offset" {
  default = 0
  description = "Determine when JP midnight is."
}

variable "fame_multiplier" {
  default = 1.00
  description = "For old fame calculation use .25"
}

variable "exp_retain" {
  default = 0
  description = "Percentage of experience normally lost to keep upon death. 0 means full loss, where 1 means no loss."
}

variable "exp_loss_level" {
  default = 4
  description = "Minimum level at which experience points can be lost"
}

variable "level_sync_enable" {
  default = 1
  description = "Enable/disable Level Sync"
}

variable "disable_gear_scaling" {
  default = 0
  description = "Disables ability to equip higher level gear when level cap/sync effect is on player."
}

variable "all_jobs_widescan" {
  default = 0
  description = "Enable/disable jobs other than BST and RNG having widescan"
}

variable "speed_mod" {
  default = 0
  description = "Modifier to apply to player speed. 0 means default speed of 40, where 20 would mean speed 60 or -10 would mean speed 30."
}

variable "mob_speed_mod" {
  default = 0
  description = "Modifier to apply to agro'd monster speed. 0 means default speed of 40, where 20 would mean speed 60 or -10 would mean speed 30."
}

variable "skillup_chance_multiplier" {
    default = 2.5
    description = "Allows you to manipulate the constant multiplier in the skill-up rate formulas, having a potent effect on skill-up rates."
}

variable "craft_chance_multiplier" {
    default = 2.6
}

variable "player_hp_multiplier" {
    default = 1.0
}

variable "player_mp_multiplier" {
    default = 1.0
}

variable "max_merit_points" {
    default = 30
}

### map_topaz Server Configuration ###

### settings.lua Server Configuration ###

variable "enable_cop" {
    default = "0"
}

variable "enable_toau" {
  default = "0"
}

variable "enable_wotg" {
  default = "0"
}

variable "enable_acp" {
  default = "0"
}

variable "enable_amk" {
  default = "0"
}

variable "enable_asa" {
  default = "0"
}

variable "enable_abyssea" {
  default = "0"
}

variable "enable_soa" {
  default = "0"
}

variable "enable_rov" {
  default = "0"
}

variable "enable_voidwatch" {
  default = "0"
  description = "Not an expansion, but has its own storyline."
}

# CHARACTER CONFIG
variable "initial_levl_cap" {
  default = "50"
  description = "The initial level cap for new players."
}

variable "max_level" {
  default = "75"
  description = "Level max of the server, lowers the attainable cap by disabling Limit Break quests."
}

variable "normal_mob_max_level_range_min" {
  default = "81"
  description = "Lower Bound of Max Level Range for Normal Mobs (0 = Uncapped)"
}

variable "normal_mob_max_level_range_max" {
  default = "84"
  description = "Upper Bound of Max Level Range for Normal Mobs (0 = Uncapped)"
}

variable "start_gil" {
  default = "1000"
  description = "Amount of gil given to newly created characters."
}

variable "start_inventory" {
  default = "30"
  description = "Starting inventory and satchel size.  Ignores values < 30.  Do not set above 80!"
}

variable "opening_cutscene_enable" {
  default = "1"
  description = "Set to 1 to enable opening cutscenes, 0 to disable."
}

variable "all_maps" {
  default = "0"
  description = "Set to 1 to give starting characters all the maps."
}

variable "unlock_outpost_warps" {
  default = "0"
  description = "Set to 1 to give starting characters all outpost warps.  2 to add Tu'Lia and Tavnazia."
}

variable "use_adoulin_weapon_skill_changes" {
  default = "false"
  description = "true/false. Change to toggle new Adoulin weapon skill damage calculations"
}

variable "healing_tp_change" {
  default = "-100"
  description = "Change in TP for each healing tick. Default is -100"
}

variable "landkingsystem_nq" {
  default = "0"
  description = "Sets spawn type for: Behemoth, Fafnir, Adamantoise, King Behemoth, Nidhog, Aspidochelone. Use 0 for timed spawns, 1 for force pop only, 2 for both."
}

variable "landkingsystem_hq" {
  default = "0"
  description = "Sets spawn type for: Behemoth, Fafnir, Adamantoise, King Behemoth, Nidhog, Aspidochelone. Use 0 for timed spawns, 1 for force pop only, 2 for both."
}

# DYNAMIS SETTINGS

variable "between_2dyna_wait_time" {
  default = "24"
  description = "Hours before player can re-enter Dynamis. Default is 1 Earthday (24 hours)."
}

variable "dyna_midnight_reset" {
  default = "true"
  description = "if true, makes the wait time count by number of server midnights instead of full 24 hour intervals."
}

variable "dyna_level_min" {
  default = "65"
  description = "level min for entering in Dynamis."
}

variable "timeless_hourglass_cost" {
  default = "50000"
  description = "refund for the timeless hourglass for Dynamis."
}

variable "prismatic_hourglass_cost" {
  default = "5000"
  description = "cost of the prismatic hourglass for Dynamis."
}

variable "currency_exchange_rate" {
  default = "100"
  description = "X Tier 1 ancient currency -> 1 Tier 2, and so on.  Certain values may conflict with shop items.  Not designed to exceed 198."
}

variable "relic_2nd_upgrade_wait_time" {
  default = "7200"
  description = "wait time for 2nd relic upgrade (stage 2 -> stage 3) in seconds. 7200s = 2 hours."
}

variable "relic_3rd_upgrade_wait_time" {
  default = "3600"
  description = "wait time for 3rd relic upgrade (stage 3 -> stage 4) in seconds. 3600s = 1 hour."
}

variable "free_cop_dynamis" {
  default = "0"
  description = "Authorize player to entering inside COP Dynamis without completing COP mission ( 1 = enable 0= disable)"
}

# QUEST/MISSION SPECIFIC SETTINGS

variable "oldschoolg1" {
  default = "false"
  description = "Set to true to require farming Exoray Mold, Bombd Coal, and Ancient Papyrus drops instead of allowing key item method."
}

variable "oldschoolg2" {
  default = "false"
  description = "Set true to require the NMs for Atop the Highest Mountains be dead to get KI like before SE changed it."
}

variable "fragiciteduration" {
  default = "30"
  description = "When OldSChoolG2 is enabled, this is the time (in seconds) you have from killing Boreal NMs to click the ??? target. Default 30"
}

variable "sneak_invisi_duration_multiplier" {
  default = "1"
  description = "multiplies duration of sneak,invis,deodorize to reduce player torture. 1 = retail behavior."
}

# MISC
variable "enable_cop_zone_cap" {
  default = "0"
  description = "enable or disable lvl cap"
}

variable "number_of_dm_earrings" {
  default = "1"
  description = "Number of earrings players can simultaneously own from Divine Might before scripts start blocking them (Default: 1)"
}

variable "homepoint_teleport" {
  default = "0"
  description = "Enables the homepoint teleport system."
}

variable "enm_cooldown" {
  default = "120"
  description = "Number of hours before a player can obtain same KI for ENMs (default: 5 days)"
}

variable "force_spawn_qm_reset_time" {
  default = "300"
  description = "Number of seconds the ??? remains hidden for after the despawning of the mob it force spawns."
}

# ABYSSEA
variable "visitant_bonus" {
  default = "1.00"
  description = "Default: 1.00 - (retail) - Multiplies the base time value of each Traverser Stone."
}

### settings.lua Server Configuration ###