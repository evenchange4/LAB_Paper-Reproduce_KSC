=begin 
	format calculate every groups' TF-IDF and format the VSM csv file to fit model 
	usage: $ ruby 9_VSM2.rb 200

	output: one file of CSV format
		1007700	6	0	0	0	0	0	1	2.961895474	3.263162465		...
		{hashtag} {cluster} {c1} {c2} {c3} {c4}	{c5} {c6} {group1} {group2} ...
=end


$group_number = ARGV[0].to_i

f = File.open("../data/1050/9_VSM_TFIDF/#{$group_number}.csv", "w")
# head title
f << "hashtag,cluster,c1,c2,c3,c4,c5,c6"
(1..$group_number).each do |i|
	f << ",group#{i}"
end
f << "\n"

File.open("../data/1050/result.csv", "rb").each_line do |l|
	tmp = l.split(",")
	index = tmp[0].split("\"")[1].to_i
	id = tmp[1].split("\"")[1].split(".")[0].to_i
	cluster = tmp[2].split("\"")[1].to_i

	puts ">> #{index}.\t processing \t#{id}.txt...\t(#{1000-index}\tremain)"
	
	# N number, 屬於這個 group 有多少 user
	number_hash = {}
	File.open("../data/1050/7_TFIDF/#{$group_number}/#{id}.txt", "rb").each_line do |line|
		tmp3 = line.split(" ")
		group3 = tmp3[1]
		if number_hash.has_key?(group3)
			number_hash[group3] = number_hash[group3] + 1
		else
			number_hash[group3] = 1
		end
	end	

	# p number_hash

	hash={}
	File.open("../data/1050/8_VSM_TFIDF/#{$group_number}/#{id}.txt", "rb").each_line do |line|
		tmp2 = line.split(" ")
		group = tmp2[0]
		tf = tmp2[1].to_i
		df = tmp2[2].to_i

		tf_idf = tf.to_f * Math.log10((1000*number_hash[group])/df) #tf-idf
		# tf_idf = tf.to_f #TF
		# tf_idf = (1+Math.log10(tf.to_f)) * Math.log10((1000*number_hash[group])/df) #tf-idf
		# tf_idf = (1+Math.log10(tf.to_f)) * [0, Math.log10((1000*100-df)/df)].max # 0.626
		# tf_idf = (2+Math.log10(tf.to_f)) * [0, Math.log10((1000*100-df)/df)].max # 0.613
		# tf_idf = (1+Math.log10(tf.to_f)) * [0, Math.log10((1000*number_hash[group])/df)].max 

		hash[group] = tf_idf
	end	

	if hash.size != $group_number
		next
	end

	# id
	f << "#{id},#{cluster}"

	# cluser
	(1..6).each do |i|
		if i == cluster
			c = 1
		else
			c = 0
		end
		f << ",#{c}"
	end

	# if-idf values
	(1..$group_number).each do |i|
		key = i.to_s
		if hash.has_key?(key)
			f << ",#{hash[key]}"
		else
			f << ",#{0}"
		end
	end

	f << "\n"
end

f.close
