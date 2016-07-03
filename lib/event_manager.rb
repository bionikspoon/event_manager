puts "Event Manager Initialized!"

lines = File.readlines 'event_attendees.csv'
lines.each_with_index do |line, i|
  next if i == 0
  columns = line.split(',')
  names = columns[2]
  puts names
end