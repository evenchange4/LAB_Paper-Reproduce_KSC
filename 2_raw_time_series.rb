=begin
2009-06-01 00:00:00 +0800 (1243785600) to
2010-01-03 15:00:00 +0800 (1262502000)
index 0: 1243785600~1243785600+3599 
map index = (x-1243785600)/3600
=end

# uninx "2009-12-31 22:21:42 +0800" -> 5134
def map_index(time)
	return (time.to_i-1243785600) / 3600
end

def make_time_series(raw_time_series)
	time_series = Array.new(5200, 0)
	raw_time_series.each do |t|
		tmp = t.split(" ")
		tmp1= tmp[0].split("-")
		tmp2= tmp[1].split(":")
		time = Time.new(tmp1[0],tmp1[1],tmp1[2],tmp2[0],tmp2[1],tmp2[2])
		# p "#{time}: #{map_index(time)}"
		if time.to_i >= 1243785600 && time.to_i <= 1262502000
			time_series[map_index(time)] = time_series[map_index(time)] + 1
		end
	end

	return time_series
end

top1050list = eval(File.open("../data/1050/1050.list.txt", "rb").read)

top1050list.each_with_index do |i, index|
	puts ">> #{index}.\t processing \t#{i}.txt...\t(#{1050-index}\tremain)"

	raw_time_series = eval(File.open("../data/1050/date/#{i}.txt", "rb").read)
	a = make_time_series(raw_time_series)

	f = File.open("../data/1050/time_series/#{i}.csv", "w")
	f << "hours,volume\n"
	a.each_with_index do |e,i|
		t = Time.at(e)
		f << "#{i},#{e}\n"
	end

	f.close
end

