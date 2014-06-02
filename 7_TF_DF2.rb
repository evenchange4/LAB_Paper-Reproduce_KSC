=begin 
	separate all the users to 50/100/200/300 groups,
	and calculate each "user" tf df
	usage: $ ruby 7_TF_DF2.rb 300
	output: 
		mariokitashvili 1 1 1 
		{user_id} {group} {tf} {df}
=end

def df_dictionary(hash)
	File.open("../data/1050/df.txt", "rb").each_line do |line|
		tmp2 = line.split(" ")
		term = tmp2[0]
		df = tmp2[1].to_i

		hash[term] = df
	end
	return hash
end

def output_result()
	File.open("../data/1050/result.csv", "rb").each_line do |l|
		tmp = l.split(",")
		index = tmp[0].split("\"")[1].to_i
		id = tmp[1].split("\"")[1].split(".")[0].to_i
		cluster = tmp[2].split("\"")[1].to_i

		puts ">> #{index}.\t processing \t#{id}.txt...\t(#{1000-index}\tremain)"
		
		tf_hash = {}
		File.open("../data/1050/6_TF/#{id}.txt", "rb").each_line do |line|
			tmp2 = line.split(" ")
			term = tmp2[0]
			tf = tmp2[1].to_i

			tf_hash[term] = tf
		end
		if tf_hash.size >= $group_number
			group_size = (tf_hash.size.to_f / $group_number).floor
		else
			group_size = 0
		end
		group_size_addone = group_size +1

		index = 1
		f = File.open("../data/1050/7_TFIDF/#{$group_number}/#{id}.txt", "w")
		tf_hash.each do |key, value|
			if index <= (tf_hash.size % $group_number)*(group_size_addone)
				n = (index/group_size_addone.to_f).ceil
			else
				n = ((index-(tf_hash.size % $group_number)*(group_size_addone))/group_size.to_f).ceil + (tf_hash.size % $group_number)
			end
			f << "#{key} #{n} #{value} #{$df_dic[key]}\n"
			index = index +1
		end
		f.close
	end
end

$group_number = ARGV[0].to_i
$df_dic = {}
df_dictionary($df_dic)
output_result()
