# Calculate TF and DF
=begin
format:
	id cluster_number
	user1 tf1
	user2 tf2
	...
=end
df_hash = {}
File.open("../data/1050/result.csv", "rb").each_line do |l|
	tmp = l.split(",")
	index = tmp[0].split("\"")[1].to_i
	id = tmp[1].split("\"")[1].split(".")[0].to_i
	cluster = tmp[2].split("\"")[1].to_i

	puts ">> #{index}.\t processing \t#{id}.txt...\t(#{1000-index}\tremain)"

	user_array = eval(File.open("../data/all/users/#{id}.txt", "rb").read)
	output = File.open("../data/1050/6_TF/#{id}.txt", "w")
	hash = {}

	user_array.each do |u|
		if hash.has_key?(u)
			hash[u] = hash[u]+1
		else
			hash[u] = 1

			# count df
			if df_hash.has_key?(u)
				df_hash[u] = df_hash[u] + 1
			else
				df_hash[u] = 1
			end
			
		end
	end
	hash_sort = hash.sort_by{|k,v|v}

	# output << "#{id} #{cluster}\n"
	hash_sort.each do |key, value|
		output << "#{key} #{value}\n"
	end

	output.close
end

# output df format
=begin
	user1 df
	user2 df
	...
=end
f = File.open("../data/1050/df.txt", "w")
df_hash.each do |key, value|
	f << "#{key} #{value}\n"
end
f.close