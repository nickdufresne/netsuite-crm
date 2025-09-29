require 'csv'

def blank?(val)
  val.nil? || val == ""
end

def nice_date(val)
  Date.parse(val).strftime("%m/%d/%Y")
end

subscriptions = {}
CSV.foreach("./account-change-orders/dr-subscriptions.csv", headers: true) do |csv|
  # skip impoterd orders customer
  subscriptions[csv["district_id"]] ||= []
  subscriptions[csv["district_id"]] << csv
end
path = File.expand_path("../import/2-subscriptions.csv", __FILE__)
puts "[WRITE] #{path} ..."
CSV.open(path, "w") do |out|
  out << ["Customer Internal ID", "Customer Number", "Subscription Name", "Subscription Internal ID", "DR District ID", "State Date", "End Date"]
  CSV.foreach("./account-change-orders/customer-district-ids.csv", headers: true) do |csv|

    district_id = csv["District ID"]
    if subscriptions[district_id]
      subscriptions[district_id].sort_by{|s| s["start_date"]}.each do |s|
        name = [s["start_date"], s["end_date"]].join(" - ")
        out << [csv["Internal ID"],csv["Customer ID"], name, s["subscription_id"], district_id, nice_date(s["start_date"]), nice_date(s["end_date"])]
      end
    end
  end
end
