require 'rubygems'
require 'mysql'

ZONES = {
  # Kalimdor
  "331" => 'ASHENVALE',
  "16" => 'AZSHARA',
  "3524" => 'AZUREMYST_ISLE',
  "3525" => 'BLOODMYST_ISLE',
  "148" => 'DARKSHORE',
  "1657" => 'DARNASSUS',
  "405" => 'DESOLACE',
  "14" => 'DUROTAR',
  "15" => 'DUSTWALLOW_MARSH',
  "361" => 'FELWOOD',
  "357" => 'FERALAS',
  "493" => 'MOONGLADE',
  "215" => 'MULGORE',
  "1637" => 'ORGRIMMAR',
  "1377" => 'SILITHUS',
  "406" => 'STONETALON_MOUNTAINS',
  "440" => 'TANARIS',
  "141" => 'TELDRASSIL',
  "3557" => 'EXODAR',
  "400" => 'THOUSAND_NEEDLES',
  "1638" => 'THUNDER_BLUFF',
  "490" => 'UNGORO_CRATER',
  "618" => 'WINTERSPRING',

  # Kalimdor - Cataclysm
  "5695" => 'AHNQIRAJ_THE_FALLEN_KINGDOM',
  "616" => 'MOUNT_HYJAL',
  "4709" => 'SOUTHERN_BARRENS',
  "17" => 'NORTHERN_BARRENS',
  "5034" => 'ULDUM',

  # Eastern Kingdoms
  "45" => 'ARATHI_HIGHLANDS',
  "3" => 'BADLANDS',
  "4" => 'BLASTED_LANDS',
  "46" => 'BURNING_STEPPES',
  "41" => 'DEADWIND_PASS',
  "1" => 'DUN_MOROGH',
  "10" => 'DUSKWOOD',
  "139" => 'EASTERN_PLAGUELANDS',
  "12" => 'ELWYNN_FOREST',
  "3430" => 'EVERSONG_WOODS',
  "3433" => 'GHOSTLANDS',
  "267" => 'HILLSBRAD_FOOTHILLS',
  "47" => 'HINTERLANDS',
  "1537" => 'IRONFORGE',
  "38" => 'LOCH_MODAN',
  "44" => 'REDRIDGE_MOUNTAINS',
  "51" => 'SEARING_GORGE',
  "3487" => 'SILVERMOON',
  "130" => 'SILVERPINE_FOREST',
  "1519" => 'STORMWIND',
  "33" => 'STRANGLETHORN_VALE',
  "4080" => 'QUEL_DANAS',
  "8" => 'SWAMP_OF_SORROWS',
  "85" => 'TIRISFAL_GLADES',
  "1497" => 'UNDERCITY',
  "28" => 'WESTERN_PLAGUELANDS',
  "40" => 'WESTFALL',
  "11" => 'WETLANDS',

  # Eastern Kingdoms - Cataclysm
  "5095" => 'TOL_BARAD',
  "4815" => 'KELPTHAR_FOREST',
  "5145" => 'ABYSSAL_DEPTHS',
  "4755" => 'RUINS_OF_GILNEAS_CITY',
  # "" => 'TOL_BARAD_PENINSULA', # this doesn't seem to have zone_id on WoWHead
  "5146" => 'VASHJIR',
  "5144" => 'SHIMMERING_EXPANSE',
  "4714" => 'RUINS_OF_GILNEAS',
  "5339" => 'NORTHERN_STRANGLETHORN',
  "4922" => 'TWILIGHT_HIGHLANDS',
  "5287" => 'CAPE_OF_STRANGLETHORN',

  # Outland
  "3522" => 'BLADES_EDGE_MOUNTAINS',
  "3483" => 'HELLFIRE_PENINSULA',
  "3518" => 'NAGRAND',
  "3523" => 'NETHERSTORM',
  "3520" => 'SHADOWMOON_VALLEY',
  "3703" => 'SHATTRATH',
  "3519" => 'TEROKKAR_FOREST',
  "3521" => 'ZANGARMARSH',

  # Northrend
  "3537" => 'BOREAN_TUNDRA',
  "2817" => 'CRYSTALSONG_FOREST',
  "4395" => 'DALARAN',
  "65" => 'DRAGONBLIGHT',
  "394" => 'GRIZZLY_HILLS',
  "495" => 'HOWLING_FJORD',
  "4742" => 'HROTHGARS_LANDING',
  "210" => 'ICECROWN_GLACIER',
  "3711" => 'SHOLAZAR_BASIN',
  "67" => 'STORM_PEAKS',
  "4197" => 'LAKE_WINTERGRASP',
  "66" => 'ZULDRAK',

  # Maelstrom
  "4737" => 'KEZAN',
  "5042" => 'DEEPHOLM',
  "5416" => 'MAELSTROM',
  "4720" => 'LOST_ISLES'
}

def lookup_zone(id)
  ZONES[id.to_s]
end

puts '-- This data is collected courtesy of Wowhead.com

if not GathererDB.Wowhead.isLoading then return end

GathererDB.Wowhead.data = {'

dbh = Mysql.real_connect("localhost", "root", "", "gatherer_db")

zones = dbh.query("SELECT DISTINCT(zone) FROM objects")

while zone = zones.fetch_row do
  unless lookup_zone(zone[0]).nil?
    puts "\t#{lookup_zone(zone[0])} = {"
    types = dbh.query("SELECT DISTINCT(type_id) FROM objects WHERE zone = '#{zone[0]}' ORDER BY type_id ASC")

    while type = types.fetch_row do
      puts "\t\t[#{type[0]}] = {"
      print "\t\t\t"

      objects = dbh.query("SELECT coords FROM objects WHERE zone = '#{zone[0]}' AND type_id = '#{type[0]}'")
      count = 0
      while object = objects.fetch_row do
        print "#{object[0]},"

        if count == 8
          print "\n\t\t\t"
          count = 0
        else
          count = count + 1
        end
      end
   
      puts "\n\t\t},"
    end

    puts "\t},"
  end
end

puts "}"
