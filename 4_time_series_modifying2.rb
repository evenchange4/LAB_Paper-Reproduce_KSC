# 去掉不滿 128 的，多找一些

MAX = 1000
puts "> Find top #{MAX} list..."
top = 1
top1050list = eval(File.open("../data/1050/1050.list.txt", "rb").read)
r = File.open("../data/1050/time_series128/rank.list.csv", "w")
miss = File.open("../data/1050/time_series128/miss.list.csv", "w")
top1050list.each_with_index do |i, index|
	f = File.open("../data/1050/select_range1050/#{i}.csv", "rb").read
	tmp = f.split("\n")
	size = tmp.size

	if size == 128
		top = top +1
		r << "#{index+1},#{i}\n"
		system("cp", "../data/1050/select_range1050/#{i}.csv", "../data/1050/time_series128/#{i}.csv")
	else
		miss << "#{index+1},#{i}\n"
	end

	if top == MAX + 1
		break
	end
end
r.close
miss.close
# top_array.each do |i|
# 	system("cp", "../data/all/date/#{i}.txt", "../data/1000/date/#{i}.txt")
# 	system("cp", "../data/all/users/#{i}.txt", "../data/1000/users/#{i}.txt")
# end