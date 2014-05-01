# hours array
hours_arrays = Array.new(5200) do |i|
	1243785600 + i *3600
end

f = File.open("../data/1050/time_series/interval.csv", "w")
f << "Index,Time,seconds\n"
hours_arrays.each_with_index do |e,i|
	t = Time.at(e)
	f << "#{i},#{t},#{e}\n"
end

f.close