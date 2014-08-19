require 'csv'
require 'awesome_print'

table = CSV.read('/Users/seansmith/gSchoolWork/warmups/commute-warm-up/data/gschool_commute_data.csv', headers: true)

new = table.map do |row|
  row.to_hash
end

data =  new.group_by { |row| row["Person"] }

data.each do |k,v|
  v.each do |row|
    row.delete("Person")
  end
end

ap data

data["Nate"].each do |row|
  p "Nate's inbound commute on Week 4 Wednesday was #{row["Inbound"].to_i} minutes" if row["Week"] == "4" && row["Day"] == "Wednesday"
end

total = 0

data.each do |k,v|
  v.each do |row|
    total += (row["Inbound"].to_i + row["Outbound"].to_i)
  end
end

p "Average total commute: #{total/(data.count)/(data["Emily"].count)} minutes"

fastest = []

data.each do |k,v|
  time = 0
  divide_by = 0
  v.each do |row|
    if row["Mode"] == "Walk"
      time += (row["Inbound"].to_i + row["Outbound"].to_i)
      divide_by += 1
    end
  end
  fastest << [k, time/(divide_by > 0 ? divide_by : 1)]
end

fastest.delete_if { |result| result[1] == 0 }


who_won = fastest.sort_by{|times| times[1]}

p "The shortest walking commute was #{who_won[0][0]}, her average commute was: #{who_won[0][1]} minutes."

data.each do |k,v|
  v.sort_by { |row| row["Week"] }
end

# ap data


