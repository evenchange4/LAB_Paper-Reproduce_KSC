require 'csv'

$group_number = ARGV[0]

answer = Array.new(6) { |i| i = Array.new(982){false} }
clasif = Array.new(6) { |i| i = Array.new(982){false} }

CSV.foreach("../data/1050/11_output/output_#{$group_number}.csv", headers: true) do |row|
	n = row[0].to_i
	threshold = -2
	cluster = row["cluster"].to_i
	# c1 = row["1"].to_f >= threshold
	# c2 = row["2"].to_f >= threshold -1
	# c3 = row["3"].to_f >= threshold -1
	# c4 = row["4"].to_f >= threshold
	# c5 = row["5"].to_f >= threshold -1
	# c6 = row["6"].to_f >= 0

	c1 = row["1"].to_f >= 0
	c2 = row["2"].to_f >= 0
	c3 = row["3"].to_f >= 0
	c4 = row["4"].to_f >= 0
	c5 = row["5"].to_f >= 0
	c6 = row["6"].to_f >= 0

	answer[cluster-1][n-1] = true
		
	if c1
		clasif[0][n-1] = true
	end
		
	if c2
		clasif[1][n-1] = true
	end
		
	if c3
		clasif[2][n-1] = true
	end
		
	if c4
		clasif[3][n-1] = true
	end
		
	if c5
		clasif[4][n-1] = true
	end
		
	if c6
		clasif[5][n-1] = true
	end
end

## accuracy
puts "accuracy"
accuracy = []
# p answer[0]
micro = 0
(1..6).each do |i|
	tptn = 0
	(1..982).each do |j|
		tptn = tptn +1 if answer[i-1][j-1] == clasif[i-1][j-1]
	end
	micro = micro + tptn
	accuracy[i-1] = tptn.to_f/982
	puts "classification #{i}: \t #{tptn.to_f/982}"
end

# Macro-averaging precision
macro = 0
accuracy.each do |f|
	macro = macro + f
end
puts "Macro-averaging: \t #{macro/6}"

# Micro-averaging precision
puts "Micro-averaging: \t #{micro.to_f/(982*6)}"

puts "\nRecall"
# recall
micro_tp = 0
(1..6).each do |i|
	tp = 0
	t = 0
	(1..982).each do |j|
		tp = tp +1 if answer[i-1][j-1] and clasif[i-1][j-1]
		t = t + 1  if answer[i-1][j-1]
	end
	micro_tp = micro_tp + tp
	puts "classification #{i}: \t #{tp.to_f/t}"
end

puts "\nTable"
# Table
(1..6).each do |i|
	tp = 0
	t = 0
	p = 0
	(1..982).each do |j|
		tp = tp +1 if answer[i-1][j-1] and clasif[i-1][j-1]
		p = p + 1  if clasif[i-1][j-1]
		t = t + 1  if answer[i-1][j-1]
	end
	puts "classification #{i}: \t"
	puts "\t #{tp},\t #{p-tp},\t #{p}"
	puts "\t #{t-tp},\t #{982-t-(p-tp)},\t "
	puts "\t #{t},\t #{982-t},\t #{982}"
	puts 
end
