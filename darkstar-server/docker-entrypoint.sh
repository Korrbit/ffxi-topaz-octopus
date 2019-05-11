#!/bin/bash

set -ex

MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_PORT=${MYSQL_PORT:-3306}
MYSQL_LOGIN=${MYSQL_LOGIN:-darkstar}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-darkstar}
MYSQL_DATABASE=${MYSQL_DATABASE:-dspdb}
SERVERNAME=${SERVERNAME:-DarkStar}

## map_darkstar.conf Server Configuration
skillup_chance_multiplier=${skillup_chance_multiplier:-2.5}
craft_chance_multiplier=${craft_chance_multiplier:-2.6}
player_hp_multiplier=${player_hp_multiplier:-1.0}
player_mp_multiplier=${player_mp_multiplier:-1.0}
max_merit_points=${max_merit_points:-30}

## settings.lua Server Configuration
ENABLE_COP=${ENABLE_COP:-0;}
ENABLE_TOAU=${ENABLE_TOAU:-0;}
ENABLE_WOTG=${ENABLE_WOTG:-0;}
ENABLE_ACP=${ENABLE_ACP:-0;}
ENABLE_AMK=${ENABLE_AMK:-0;}
ENABLE_ASA=${ENABLE_ASA:-0;}
ENABLE_ABYSSEA=${ENABLE_ABYSSEA:-0;}
ENABLE_SOA=${ENABLE_SOA:-0;}
ENABLE_ROV=${ENABLE_ROV:-0;}
ENABLE_VOIDWATCH=${ENABLE_VOIDWATCH:-0;}

INITIAL_LEVEL_CAP=${INITIAL_LEVEL_CAP:-50;}
MAX_LEVEL=${MAX_LEVEL:-75;}
START_GIL=${START_GIL:-10;}
START_INVENTORY=${START_INVENTORY:-30;}
OPENING_CUTSCENE_ENABLE=${OPENING_CUTSCENE_ENABLE:-0;}
ALL_MAPS=${ALL_MAPS:-0;}
UNLOCK_OUTPOST_WARPS=${UNLOCK_OUTPOST_WARPS:-0;}

USE_ADOULIN_WEAPON_SKILL_CHANGES=${USE_ADOULIN_WEAPON_SKILL_CHANGES:-false;}

HEALING_TP_CHANGE=${HEALING_TP_CHANGE:--100;}

LandKingSystem_NQ=${LandKingSystem_NQ:-0;}
LandKingSystem_HQ=${LandKingSystem_HQ:-0;}


BETWEEN_2DYNA_WAIT_TIME=${BETWEEN_2DYNA_WAIT_TIME:-24;}
DYNA_MIDNIGHT_RESET=${DYNA_MIDNIGHT_RESET:-true;}
DYNA_LEVEL_MIN=${DYNA_LEVEL_MIN:-65;}
TIMELESS_HOURGLASS_COST=${TIMELESS_HOURGLASS_COST:-500000;}
PRISMATIC_HOURGLASS_COST=${PRISMATIC_HOURGLASS_COST:-50000;}
CURRENCY_EXCHANGE_RATE=${CURRENCY_EXCHANGE_RATE:-100;}
RELIC_2ND_UPGRADE_WAIT_TIME=${RELIC_2ND_UPGRADE_WAIT_TIME:-7200;}
RELIC_3RD_UPGRADE_WAIT_TIME=${RELIC_3RD_UPGRADE_WAIT_TIME:-3600;}
FREE_COP_DYNAMIS=${FREE_COP_DYNAMIS:-0;}

OldSchoolG1=${OldSchoolG1:-false;}
OldSchoolG2=${OldSchoolG2:-false;}
FrigiciteDuration=${FrigiciteDuration:-30;}

SNEAK_INVIS_DURATION_MULTIPLIER=${SNEAK_INVIS_DURATION_MULTIPLIER:-1;}

ENABLE_COP_ZONE_CAP=${ENABLE_COP_ZONE_CAP:-1;}
NUMBER_OF_DM_EARRINGS=${NUMBER_OF_DM_EARRINGS:-1;}
HOMEPOINT_TELEPORT=${HOMEPOINT_TELEPORT:-0;}
ENM_COOLDOWN=${ENM_COOLDOWN:-120;}
FORCE_SPAWN_QM_RESET_TIME=${FORCE_SPAWN_QM_RESET_TIME:-300;}

VISITANT_BONUS=${VISITANT_BONUS:-1.00;}


## modify configuration
function modConfig() {
    local db_files=(login_darkstar.conf map_darkstar.conf search_server.conf)

    for f in ${db_files[@]}
    do
        if [[ -f /darkstar/conf/$f ]]; then
            sed -i "s/^\(mysql_host:\s*\).*\$/\1$MYSQL_HOST/" /darkstar/conf/$f
            sed -i "s/^\(mysql_port:\s*\).*\$/\1$MYSQL_PORT/" /darkstar/conf/$f
            sed -i "s/^\(mysql_login:\s*\).*\$/\1$MYSQL_LOGIN/" /darkstar/conf/$f
            sed -i "s/^\(mysql_password:\s*\).*\$/\1$MYSQL_PASSWORD/" /darkstar/conf/$f
            sed -i "s/^\(mysql_database:\s*\).*\$/\1$MYSQL_DATABASE/" /darkstar/conf/$f
        fi
    done

    sed -i "s/^\(servername:\s*\).*\$/\1$SERVERNAME/" /darkstar/conf/login_darkstar.conf
}

function modSettings() {
    local conf_file=(map_darkstar.conf)
    local settings_file=(settings.lua)

    for f in ${conf_file[@]}
    do
        if [[ -f /darkstar/conf/$f ]]; then
            sed -i "s/^\(skillup_chance_multiplier:\s*\).*\$/\1$skillup_chance_multiplier/" /darkstar/conf/$f
            sed -i "s/^\(craft_chance_multiplier:\s*\).*\$/\1$craft_chance_multiplier/" /darkstar/conf/$f
            sed -i "s/^\(player_hp_multiplier:\s*\).*\$/\1$player_hp_multiplier/" /darkstar/conf/$f
            sed -i "s/^\(player_mp_multiplier:\s*\).*\$/\1$player_mp_multiplier/" /darkstar/conf/$f
            sed -i "s/^\(max_merit_points:\s*\).*\$/\1$max_merit_points/" /darkstar/conf/$f
        fi
    done

    for f in ${settings_file[@]}
    do
        if [[ -f /darkstar/scripts/globals/$f ]]; then
            sed -i "s/^\(ENABLE_COP[[:blank:]]*=\s*\).*\$/\1$ENABLE_COP/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_TOAU[[:blank:]]*=\s*\).*\$/\1$ENABLE_TOAU/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_WOTG[[:blank:]]*=\s*\).*\$/\1$ENABLE_WOTG/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_ACP[[:blank:]]*=\s*\).*\$/\1$ENABLE_ACP/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_AMK[[:blank:]]*=\s*\).*\$/\1$ENABLE_AMK/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_ASA[[:blank:]]*=\s*\).*\$/\1$ENABLE_ASA/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_ABYSSEA[[:blank:]]*=\s*\).*\$/\1$ENABLE_ABYSSEA/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_SOA[[:blank:]]*=\s*\).*\$/\1$ENABLE_SOA/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_ROV[[:blank:]]*=\s*\).*\$/\1$ENABLE_ROV/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_VOIDWATCH[[:blank:]]*=\s*\).*\$/\1$ENABLE_VOIDWATCH/" /darkstar/scripts/globals/$f
            sed -i "s/^\(INITIAL_LEVEL_CAP[[:blank:]]*=\s*\).*\$/\1$INITIAL_LEVEL_CAP/" /darkstar/scripts/globals/$f
            sed -i "s/^\(MAX_LEVEL[[:blank:]]*=\s*\).*\$/\1$MAX_LEVEL/" /darkstar/scripts/globals/$f
            sed -i "s/^\(START_GIL[[:blank:]]*=\s*\).*\$/\1$START_GIL/" /darkstar/scripts/globals/$f
            sed -i "s/^\(START_INVENTORY[[:blank:]]*=\s*\).*\$/\1$START_INVENTORY/" /darkstar/scripts/globals/$f
            sed -i "s/^\(OPENING_CUTSCENE_ENABLE[[:blank:]]*=\s*\).*\$/\1$OPENING_CUTSCENE_ENABLE/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ALL_MAPS[[:blank:]]*=\s*\).*\$/\1$ALL_MAPS/" /darkstar/scripts/globals/$f
            sed -i "s/^\(UNLOCK_OUTPOST_WARPS[[:blank:]]*=\s*\).*\$/\1$UNLOCK_OUTPOST_WARPS/" /darkstar/scripts/globals/$f
            sed -i "s/^\(USE_ADOULIN_WEAPON_SKILL_CHANGES[[:blank:]]*=\s*\).*\$/\1$USE_ADOULIN_WEAPON_SKILL_CHANGES/" /darkstar/scripts/globals/$f
            sed -i "s/^\(HEALING_TP_CHANGE[[:blank:]]*=\s*\).*\$/\1$HEALING_TP_CHANGE/" /darkstar/scripts/globals/$f
            sed -i "s/^\(LandKingSystem_NQ[[:blank:]]*=\s*\).*\$/\1$LandKingSystem_NQ/" /darkstar/scripts/globals/$f
            sed -i "s/^\(LandKingSystem_HQ[[:blank:]]*=\s*\).*\$/\1$LandKingSystem_HQ/" /darkstar/scripts/globals/$f
            sed -i "s/^\(BETWEEN_2DYNA_WAIT_TIME[[:blank:]]*=\s*\).*\$/\1$BETWEEN_2DYNA_WAIT_TIME/" /darkstar/scripts/globals/$f
            sed -i "s/^\(DYNA_MIDNIGHT_RESET[[:blank:]]*=\s*\).*\$/\1$DYNA_MIDNIGHT_RESET/" /darkstar/scripts/globals/$f
            sed -i "s/^\(DYNA_LEVEL_MIN[[:blank:]]*=\s*\).*\$/\1$DYNA_LEVEL_MIN/" /darkstar/scripts/globals/$f
            sed -i "s/^\(TIMELESS_HOURGLASS_COST[[:blank:]]*=\s*\).*\$/\1$TIMELESS_HOURGLASS_COST/" /darkstar/scripts/globals/$f
            sed -i "s/^\(PRISMATIC_HOURGLASS_COST[[:blank:]]*=\s*\).*\$/\1$PRISMATIC_HOURGLASS_COST/" /darkstar/scripts/globals/$f
            sed -i "s/^\(CURRENCY_EXCHANGE_RATE[[:blank:]]*=\s*\).*\$/\1$CURRENCY_EXCHANGE_RATE/" /darkstar/scripts/globals/$f
            sed -i "s/^\(RELIC_2ND_UPGRADE_WAIT_TIME[[:blank:]]*=\s*\).*\$/\1$RELIC_2ND_UPGRADE_WAIT_TIME/" /darkstar/scripts/globals/$f
            sed -i "s/^\(RELIC_3RD_UPGRADE_WAIT_TIME[[:blank:]]*=\s*\).*\$/\1$RELIC_3RD_UPGRADE_WAIT_TIME/" /darkstar/scripts/globals/$f
            sed -i "s/^\(FREE_COP_DYNAMIS[[:blank:]]*=\s*\).*\$/\1$FREE_COP_DYNAMIS/" /darkstar/scripts/globals/$f
            sed -i "s/^\(OldSchoolG1[[:blank:]]*=\s*\).*\$/\1$OldSchoolG1/" /darkstar/scripts/globals/$f
            sed -i "s/^\(OldSchoolG2[[:blank:]]*=\s*\).*\$/\1$OldSchoolG2/" /darkstar/scripts/globals/$f
            sed -i "s/^\(FrigiciteDuration[[:blank:]]*=\s*\).*\$/\1$FrigiciteDuration/" /darkstar/scripts/globals/$f
            sed -i "s/^\(SNEAK_INVIS_DURATION_MULTIPLIER[[:blank:]]*=\s*\).*\$/\1$SNEAK_INVIS_DURATION_MULTIPLIER/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENABLE_COP_ZONE_CAP[[:blank:]]*=\s*\).*\$/\1$ENABLE_COP_ZONE_CAP/" /darkstar/scripts/globals/$f
            sed -i "s/^\(NUMBER_OF_DM_EARRINGS[[:blank:]]*=\s*\).*\$/\1$NUMBER_OF_DM_EARRINGS/" /darkstar/scripts/globals/$f
            sed -i "s/^\(HOMEPOINT_TELEPORT[[:blank:]]*=\s*\).*\$/\1$HOMEPOINT_TELEPORT/" /darkstar/scripts/globals/$f
            sed -i "s/^\(ENM_COOLDOWN[[:blank:]]*=\s*\).*\$/\1$ENM_COOLDOWN/" /darkstar/scripts/globals/$f
            sed -i "s/^\(FORCE_SPAWN_QM_RESET_TIME[[:blank:]]*=\s*\).*\$/\1$FORCE_SPAWN_QM_RESET_TIME/" /darkstar/scripts/globals/$f
            sed -i "s/^\(VISITANT_BONUS[[:blank:]]*=\s*\).*\$/\1$VISITANT_BONUS/" /darkstar/scripts/globals/$f
        fi
    done
}

modConfig
modSettings

exec /usr/local/bin/supervisord