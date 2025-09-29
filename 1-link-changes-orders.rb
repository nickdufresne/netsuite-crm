require 'csv'

def blank?(val)
  val.nil? || val == ""
end

dr = {}
netsuite = {}
customers = {}

CSV.foreach("./account-change-orders/dr.csv", headers: true) do |csv|
  num = csv["order_number"]
  next if blank?(num)

  if num =~ /^(\d+)/i 
    num = "S#{$1}"
  elsif num =~ /^S(\d+)/i
    num = "S#{$1}"
  end

  dr[num.upcase] = csv
end


CSV.foreach("./account-change-orders/netsuite.csv", headers: true) do |csv|
  # skip impoterd orders customer
  next if csv["Customer Internal ID"] == "954819"

  num = csv["Document Number"]
  netsuite[num.upcase] = csv
end

missing_in_netsuite = {}

dr.each do |so, row|
  if !netsuite[so.upcase]
    #puts "Missing in Netsuite: #{so}"
    missing_in_netsuite[so] = row
  end
end

matches = {}
missing_in_dr = []
netsuite.each do |so, row|
  if dr[so.upcase]
    customer_id = row["ID"]
    name = row["Name"]
    internal_id = row["Customer Internal ID"]
    district_id = dr[so]["district_id"]
    end_date = dr[so]["end_date"]
    district_name = dr[so]["name"]
    matches[internal_id] ||= []
    if !matches[internal_id].detect { |m| m[:district_id] == district_id }
      matches[internal_id] << {name: name, district_id: district_id, end_date: end_date, district_name: district_name, customer_id: customer_id}
    end
  elsif so !~ /^Q/i
    puts "Missing in DR: #{so} / #{row["Date"]}"
    missing_in_dr << row
  end
end

def reduce_rows(rows)
  puts "Reducing rows: #{rows.count}"
  rows.each do |row|
    puts "  #{row[:customer_id]} / #{row[:name]} / #{row[:district_id]} / #{row[:end_date]} / #{row[:district_name]}"
  end

  reduced_rows = rows.select{|row| Date.parse(row[:end_date]) >= Date.today}
  return reduced_rows if reduced_rows.count == 1

  reduced_rows = rows.select{|row| Date.parse(row[:end_date]).year >= 2025}
  return reduced_rows if reduced_rows.count == 1

  if reduced_rows.count == 0
    return [rows.sort_by { |row| Date.parse(row[:end_date]) }.reverse.first]
  end

  reduced_rows = rows.select { |row| row[:district_name] == row[:name] }
  return reduced_rows if reduced_rows.count == 1

  raise "Can't reduce!" 
end

CSV.open("./account-change-orders/customer-district-ids.csv", "w") do |csv|
  csv << ["Customer ID","Internal ID", "Netsuite Name", "District ID", "DR Name"]
  matches.each do |internal_id, rows|
    if rows.count > 1
      rows = reduce_rows(rows)
      puts "Reduced rows: #{rows.count}"
      rows.each do |row|
        puts "====>  #{row[:customer_id]} / #{row[:name]} / #{row[:district_id]} / #{row[:end_date]} / #{row[:district_name]}"
      end
    end
    
    rows.each do |row|
      csv << [row[:customer_id], internal_id, row[:name], row[:district_id], row[:district_name]]
    end
  end
end

puts "Matches: #{matches.count}"
puts "Missing in DR: #{missing_in_dr.count}"
puts "Missing in Netsuite: #{missing_in_netsuite.count}"
