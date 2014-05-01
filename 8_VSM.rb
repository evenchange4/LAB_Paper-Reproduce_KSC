File.open("../data/1050/result.csv", "rb").each_line do |l|
	tmp = l.split(",")
	index = tmp[0].split("\"")[1].to_i
	id = tmp[1].split("\"")[1].split(".")[0].to_i
	cluster = tmp[2].split("\"")[1].to_i

	puts ">> #{index}.\t processing \t#{id}.txt...\t(#{1000-index}\tremain)"
	
	hash={}
	File.open("../data/1050/7_TFIDF/#{id}.txt", "rb").each_line do |line|
		tmp2 = line.split(" ")
		term = tmp2[0]
		group = tmp2[1].to_i
		tf = tmp2[2].to_i
		df = tmp2[3].to_i
		if hash.has_key?(group)
			hash[group]["tf"] = hash[group]["tf"] + tf
			hash[group]["df"] = hash[group]["df"] + df
			hash[group]["number"] = hash[group]["number"] + 1
		else
			hash[group] = {"tf"=>tf, "df"=>df, "number" => 1}
		end
	end	

	f = File.open("../data/1050/8_VSM_TFIDF_200/#{id}.txt", "w")

	hash.each do |key, value|
		f << "#{key} #{value['tf'].to_f/value['number']} #{value['df'].to_f/value['number']}\n"
	end

	f.close

end