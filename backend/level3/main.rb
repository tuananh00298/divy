require 'json'
require 'date'

def read_file
  JSON.parse(File.read('data/input.json'))
end

def get_info
  rentals = []
  read_file['rentals'].each do |rental|
    distand = rental['distance']
    price_per_day = read_file['cars'][0]['price_per_day']
    price_per_km = read_file['cars'][0]['price_per_km']
    number_day = calcu_date(rental["end_date"], rental["start_date"])
    total_price = price_day(number_day, price_per_day) + calcu_price(distand, price_per_km)
    commission = commission(total_price,number_day)
    p commission
    rentals << { 'id' => rental['id'],
                 'price' => total_price.to_i,
                 'commission' => commission(total_price, number_day)
    }
  end
  rentals
end

def calcu_price(value, fee)
  value*fee
end

def calcu_date(start_date, end_date)
  day = parse_date(start_date) - parse_date(end_date) + 1
  return 1 if day == 0

  day
end

def price_day date, fee
  price1 = date*fee
  counpon_10 = counpon(3, 0.1, fee)
  counpon_30 = counpon(6, 0.3, fee)
  if date <= 3 && date > 1
    price = counpon((date-1), 0.1, fee)
  elsif date <= 10 && date > 4
    price = counpon_10 + counpon(date-3, 0.3, fee)
  elsif date > 10
    price = counpon_10 + counpon_30 + ((date-10)*0.5)*fee
  else
    price = 0
  end
  price1 - price
end

def counpon(date, counpon, fee)
  date*counpon*fee
end

def commission(total, number_day)
  commission = total*0.3
  insuran = commission/2
  assistan = number_day*100
  drivy_fee = commission - insuran - assistan
  {insurance_fee: insuran.to_i,
   assistance_fee: assistan.to_i, \
   drivy_fee: drivy_fee.to_i}
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