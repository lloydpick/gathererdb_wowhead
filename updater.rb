puts "GathererDB WoWHead All-In-One Updater..."

print "  Running scraper... "
system('ruby grabber.rb > /dev/null 2>&1')
puts "Done"

print "  Running printer... "
system('ruby printer.rb > DB_WowheadData.lua')
puts "Done"

print "  Moving file... "
system('mv DB_WowheadData.lua ..')
puts "Done"

print "  Changing GIT branch... "
system('git checkout master > /dev/null 2>&1')
puts "Done"

print "  Moving file back into GIT... "
system('cd ..')
system('mv /home/limi/repositories/DB_WowheadData.lua /home/limi/repositories/gathererdb_wowhead/')
puts "Done"

print "  Staging DB_WowheadData.lua... "
system('git add DB_WowheadData.lua')
puts "Done"

toc = <<END_TOC
## Interface: 40000
## 
## Title: GathererDB: |cffce0a11Wowhead|r
## Notes: Gatherer preloaded database, courtesy of |cffce0a11http://wowhead.com|r
## Version: 1.0.#{Time.now.strftime("%Y-%m-%d")}
##
## X-Website: http://www.gathereraddon.com
## X-Author: Norganna's AddOns - Nechckn, Project Administrator, MentalPower
## X-CompatibleLocales: enUS, enGB, deDE, frFR, koKR, zhCN, zhTW, esES
## X-Category: Tradeskill
## X-Date: 2010-09-06
##
## RequiredDeps: Gatherer

DB_WowheadMain.lua
DB_WowheadData.lua

END_TOC

print "  Writing new TOC file... "
File.open('GathererDB_Wowhead.toc', 'w') {|f| f.write(toc) }
puts "Done"

print "  Staging GathererDB_Wowhead.toc... "
system('git add GathererDB_Wowhead.toc')
puts "Done"

print "  Commiting files to GIT... "
system("git commit -m \"updated data #{Time.now.strftime("%d-%m-%Y")}\"")
puts "Done"

print "  Pushing files to GitHub... "
system('git push origin master > /dev/null 2>&1')
puts "Done"

puts "Finished!"
