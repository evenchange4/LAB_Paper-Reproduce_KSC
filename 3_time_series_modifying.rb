
top1000list = eval(File.open("../data/1000/1000.list.txt", "rb").read)


top1000list.each_with_index do |i, index|

	f = File.open("../data/128/time_series/#{i}.csv", "rb").read
	tmp = f.split("\n")
	size = tmp.size
	last_index = tmp.last.split(",")[0].to_i

	if size < 128
		puts i
		f2 = File.open("../data/128/time_series_modify/#{i}.csv", "w")
		f2 << f
		(1..128-size).each do |j|
			f2 << "#{last_index+j},#{0}\n"
		end
	end
end
