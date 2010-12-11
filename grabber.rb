print "Starting up... "
require 'rubygems'
require 'nokogiri'
require 'mysql'
require 'open-uri'
puts "Done"

print "Connecting to mySQL... "
dbh = Mysql.real_connect("localhost", "gatherer", "", "gatherer_db")
puts "Done"

print "Clearing old data... "
dbh.query("TRUNCATE objects")
puts "Done"

# Mining nodes
print "Fetching mining node types... "; $stdout.flush 
mines = Nokogiri::HTML(open("http://www.wowhead.com/objects=-4"))
puts "Done"

print "  Extracting JS... "
mines_js = mines.xpath('//script[@type="text/javascript"]')
puts "Done"

print "  Searching for correct JS... "
listview_js = ""
mines_js.each do |js|
  if js.content[/Listview/x] != nil
    listview_js = js.content
  end
end
puts "Done"

print "  Regexing JS... "
  mines = listview_js.scan(/"id":(\d*),/i)
puts "Done"


# Herb nodes
print "Fetching herb node types... "; $stdout.flush 
herbs = Nokogiri::HTML(open("http://www.wowhead.com/objects=-3"))
puts "Done"

print "  Extracting JS... "
herbs_js = herbs.xpath('//script[@type="text/javascript"]')
puts "Done"

print "  Searching for correct JS... "
listview_js = ""
herbs_js.each do |js|
  if js.content[/Listview/x] != nil
    listview_js = js.content
  end
end
puts "Done"

print "  Regexing JS... "
  herbs = listview_js.scan(/"id":(\d*),/i)
puts "Done"

objects = mines | herbs

objects.each do |object|
  object_id = object[0].to_i

  puts "Searching for #{object}... "

  print "  Fetching object data... "; $stdout.flush 
  data = Nokogiri::HTML(open("http://www.wowhead.com/object=#{object_id}"))
  puts "Done"

  print "  Extracting JS... "
  all_js = data.xpath('//script[@type="text/javascript"]')
  puts "Done"

  print "  Searching for correct JS... "
  mapper_js = ""
  all_js.each do |js|
    if js.content[/g_mapperData/x] != nil
      mapper_js = js.content
    end
  end
  puts "Done"

  print "  Regexing JS... "
  results = mapper_js.scan(/(\d*): \{\n\d*: \{ count: \d*, coords: \[(.*)\] \}\n\}/i)
  puts "Done"

  print "  Putting data into DB... "
  results.each do |result|
    coord_results = result[1].scan(/\[(\d*.\d*),(\d*.\d*)\]/)
    coord_results.each do |coord|
      coords = sprintf("%0.02f", (coord[0].to_f / 10)).to_s.gsub('.','') + sprintf("%0.02f", (coord[1].to_f / 10)).to_s.gsub('.','')
      dbh.query("INSERT INTO objects (type_id, coords, zone) VALUES ('#{object_id}', '#{coords}', '#{result[0]}')")
    end
  end

  puts "Done"

end


print "Cleaning up..."
puts "Finished!"
