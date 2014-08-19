require 'csv'
require 'awesome_print'

## CSV INTO TABLE

table = CSV.read('/Users/seansmith/gSchoolWork/warmups/commute-warm-up/data/gschool_commute_data.csv', headers: true)

## CSV ROWS TO HASHES

hashes = table.map do |row|
  row.to_hash
end

## SORTING BY WEEK THEN DAY

days = {"Monday" => 1, "Tuesday" => 2, "Wednesday" => 3, "Thursday" => 4, "Friday" => 5}

new = hashes.sort do |a, b|
  if (a["Week"] <=> b["Week"]) == 0
    a = a["Day"]
    b = b["Day"]
    days[a] <=> days[b]
  else
    a["Week"] <=> b["Week"]
  end
end

## GROUPING BY PERSON

data = new.group_by { |row| row["Person"] }

data.each do |k,v|
  v.each do |row|
    row.delete("Person")
  end
end

## ANSWERS

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
