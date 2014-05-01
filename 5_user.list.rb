# Create user list dictionary
=begin
format:
	index1 user_id1
	index2 user_id2
	...
=end
users = {}
File.open("../data/1050/result.csv", "rb").each_line do |l|
	tmp = l.split(",")
	index = tmp[0].split("\"")[1].to_i
	id = tmp[1].split("\"")[1].split(".")[0].to_i
	cluster = tmp[2].split("\"")[1].to_i

	puts ">> #{index}.\t processing \t#{id}.txt...\t(#{1000-index}\tremain)"

	user_array = eval(File.open("../data/all/users/#{id}.txt", "rb").read)

	user_array.each do |u|
		if !users.has_key?(u)
			users[u] = 1
		end

	end
		p users.size
end

f = File.open("../data/1050/dictionary/user.list.txt", "w")
index = 1
users.each do |key, value|
	f << "#{index}\t#{key}\n"
	index = index +1
end
f.close