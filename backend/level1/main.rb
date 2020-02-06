require 'json'
require 'date'

def read_file
  JSON.parse(File.read('data/input.json'))
end

def get_info
  rentals = []

  read_file['rentals'].each do |rental|
    car_id = rental["car_id"]
    distand = rental['distance']
    price_per_day = read_file['cars'][car_id]['price_per_day']
    price_per_km = read_file['cars'][car_id]['price_per_km']
    number_day = calcu_date(rental["end_date"], rental["start_date"])
    total_price = calcu_price(number_day, price_per_day) + calcu_price(distand, price_per_km)
    rentals << { 'id' => rental['id'], 'price' => total_price }
  end
  rentals
end

def calcu_price(value, fee)
  value*fee
end

def calcu_date(start_date, end_date)
  parse_date(start_date) - parse_date(end_date)
end

def parse_date date
  Date.parse(date).mjd
end

def write_file
  File.open("data/output.json","w") do |f|
    f.write({ rentals: get_info }.to_json)
  end
end
write_file