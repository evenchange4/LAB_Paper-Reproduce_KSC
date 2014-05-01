MAX = 1050

dictionary = Hash.new
File.open("../data/all/dictionary/1.txt", "rb").each_line do |l|
	temp = l.split("\t")
	dictionary[temp[1].split("\n")[0]] = temp[0]
end

top = 1
top_array = Array.new
File.open("../data/rank.txt", "rb").each_line do |l|
	top = top +1
	temp = l.split("\t")
	top_array << dictionary[temp[0]]
	if top == MAX + 1
		break
	end
end

File.open("../data/1050/1050.list.txt", "w") do |f|
	f << top_array
end

top_array.each do |i|
	system("cp", "../data/all/date/#{i}.txt", "../data/1050/date/#{i}.txt")
	system("cp", "../data/all/users/#{i}.txt", "../data/1050/users/#{i}.txt")
end