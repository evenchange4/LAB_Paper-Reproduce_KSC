#!/usr/bin/Rscript


if(FALSE){
	# run six classifier of logistic regression model and output the prediction result
	# usage: $ ./11_logistic.r 300 
	# output:
	#		1	1007700	6	-3.547144091	-5.939170268	-2.749212149	-4.24986855	-4.214527331	2.055511179
	#		{hashtag} {cluster}	{1}	{2}	{3}	{4}	{5}	{6}
}

args<-commandArgs(TRUE)
group_number = args[1]

output_path = paste("../data/1050/11_output/output_", group_number, sep = "")
output_path = paste(output_path, ".csv", sep = "")

input_path = paste("../data/1050/9_VSM_TFIDF/", group_number, sep = "")
input_path = paste(input_path, ".csv", sep = "")

setup_data_all = read.csv(input_path, header = TRUE)

# saparate data
features = setup_data_all[9:9+as.numeric(group_number)-1]
origin_predict =  setup_data_all['cluster']
user_id = setup_data_all['hashtag']
data_classifier_1 = cbind(setup_data_all['c1'],features)
data_classifier_2 = cbind(setup_data_all['c2'],features)
data_classifier_3 = cbind(setup_data_all['c3'],features)
data_classifier_4 = cbind(setup_data_all['c4'],features)
data_classifier_5 = cbind(setup_data_all['c5'],features)
data_classifier_6 = cbind(setup_data_all['c6'],features)

# six classifier
logit1 <- glm(c1 ~ ., data = data_classifier_1, family = binomial("logit"))
logit2 <- glm(c2 ~ ., data = data_classifier_2, family = binomial("logit"))
logit3 <- glm(c3 ~ ., data = data_classifier_3, family = binomial("logit"))
logit4 <- glm(c4 ~ ., data = data_classifier_4, family = binomial("logit"))
logit5 <- glm(c5 ~ ., data = data_classifier_5, family = binomial("logit"))
logit6 <- glm(c6 ~ ., data = data_classifier_6, family = binomial("logit"))

# prediction
prediction_1 = predict(logit1, newdata = features)
prediction_2 = predict(logit2, newdata = features)
prediction_3 = predict(logit3, newdata = features)
prediction_4 = predict(logit4, newdata = features)
prediction_5 = predict(logit5, newdata = features)
prediction_6 = predict(logit6, newdata = features)
prediction = cbind(prediction_1,prediction_2,prediction_3,prediction_4,prediction_5,prediction_6)
colnames(prediction) <- c("1","2","3","4","5","6")

cluster_predict = c()
for(i in 1:nrow(setup_data_all)){
	idx  = which(prediction[i,] == max(prediction[i,]), arr.ind=TRUE)
	cluster_predict[i] = idx
}
result = cbind(user_id,origin_predict,cluster_predict)

tp = 0
for(i in 1:nrow(setup_data_all)){
	if (result[i,"cluster"] == result[i,"cluster_predict"]){
		tp = tp + 1
	}
}

print (tp/nrow(setup_data_all))

# output result
output = cbind(user_id,origin_predict,prediction)
write.csv(output, file = output_path)