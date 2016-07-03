require 'csv'
require 'sunlight/congress'

Sunlight::Congress.api_key = File.read('./.env.API_KEY').chomp


def main
  puts "Event Manager Initialized!"

  contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
  contents.each do |row|
    name = row[:first_name]
    zipcode = clean_zipcode row[:zipcode]
    legislators = legislators_by_zipcode zipcode
    puts "#{name} #{zipcode} #{legislators}"
  end
end

def clean_zipcode zipcode
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode zipcode
  Sunlight::Congress::Legislator
      .by_zipcode(zipcode)
      .collect { |legislator| "#{legislator.first_name} #{legislator.last_name}" }
      .join(', ')
end

if __FILE__ == $0
  main
end
