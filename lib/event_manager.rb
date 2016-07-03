require 'csv'
require 'sunlight/congress'
require 'erb'


def clean_zipcode zipcode
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode zipcode
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letter(id, personal_letter)
  Dir.mkdir "output" unless Dir.exist? "output"
  File.open("output/thanks_#{id}.html", 'w') { |file| file.puts personal_letter }
end


def main
  Sunlight::Congress.api_key = File.read('./.env.API_KEY').chomp
  template_letter = ERB.new File.read "form_letter.html.erb"
  puts "Event Manager Initialized!"

  contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol
  contents.each do |row|
    id = row[0]
    name = row[:first_name]

    zipcode = clean_zipcode row[:zipcode]
    legislators = legislators_by_zipcode zipcode

    personal_letter = template_letter.result binding

    save_thank_you_letter(id, personal_letter)
  end
end

if __FILE__ == $0
  main
end
