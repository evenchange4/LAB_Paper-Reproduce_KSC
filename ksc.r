file_path = "/mnt/hgfs/Shared Virtual Machines/PaperReproduce/data/1050/time_series128"
setwd(file_path)

files <- as.character(list.files(path=file_path))	#Read all files in dictionary.
#print(length(files))
#print(typeof("./"))
x = as.matrix(read.csv(paste("./", files[1], sep = ""),header=FALSE)[,2])
#y = as.matrix(read.csv(paste("./", files[2], sep = ""),header=FALSE)[,2])

mfile = x
for (each_file in files) {
	if (each_file != files[1]) {
		temp = as.matrix(read.csv(paste("./", each_file, sep = ""),header=FALSE)[,2])
		mfile = cbind(mfile,temp)
	}
}
mfile = t(mfile)
print(nrow(mfile))

#Basic function
calc_dist <- function(x,y) {
	alpha = (t(x) %*% y) / (t(y) %*% y)
	x = as.matrix(x)
	y = as.matrix(y)
	dist = norm(x - (alpha[1,1] * y),"F") / norm(x,"F")
	#cat("distance =" , paste(dist,"\n"))
	#cat("\n")
	return(dist)
}

#Shift distance -5 to 5
shift_dist <- function(x,y) {
	min_dist = calc_dist(x,y)
	for (i in -5:5 ) {
		yshift = as.vector(y)
		optshift = 0
		opty = y
		if (i < 0) {
			i = i * (-1)
			vector_y = as.vector(y)
			start = i + 1
			yshift = c(vector_y[start:length(vector_y)],as.vector(matrix(0,1,i)))
		}
		else if (i > 0) {
			vector_y = as.vector(y)
			end = length(vector_y) - i
			yshift = c(as.vector(matrix(0,1,i)),vector_y[1:end])
		}
		m_yshift = as.matrix(yshift)
		shift_dist = calc_dist(x,m_yshift)
		if (shift_dist <= min_dist) {
			optshift = i
			opty = m_yshift
			min_dist = shift_dist
		}
	}
	result <- c(min_dist,optshift,opty)
	return(result)	
}

ksc_center <- function(cluster_set,all_time_series,k,cur_center) {
	temp = as.null()
	for (i in 1:length(cluster_set)) {
		if (cluster_set[i] == k) {
			if (sum(cur_center) == 0) {
				opt_a = all_time_series[i,]
			}
			else {
				result_shift = shift_dist(as.matrix(cur_center), as.matrix(all_time_series[i,]))
				opt_a = t(as.matrix(c(result_shift[3:length(result_shift)])))
			}
			temp <- rbind(temp, opt_a)
		}
	}
	if(is.null(temp)) {
		ksc = matrix(0,1,ncol(all_time_series))
		return(ksc)
	}
	b = temp/matrix(sqrt(sum(temp^2)),nrow(temp),ncol(temp))
	M = t(b) %*% b - nrow(temp) * diag(1,ncol(temp))
	eigen_value = eigen(M)$values
	eigen_vector = eigen(M)$vectors
	ksc = eigen_vector[,1]
	if (sum(ksc) < 0) {
		ksc = -ksc
	}
	return(ksc)
}

ksc_clustering <- function(all_time_series,K) {
	rows = nrow(all_time_series)
    #mem = floor(runif(0,K)) + 1
	mem = floor(runif(1000,0,K)) + 1
	cent = matrix(0,K,ncol(all_time_series))
	for (counter in 1:150) {
		ori_mem = mem
		D = matrix(0,rows,K)
		for ( k in 1:K) {
			cent[k,] = ksc_center(mem, all_time_series,k,as.matrix(cent[k,]))
		}
		for (i in 1:rows) {
			x = all_time_series[i,]
			for ( k in 1:K) {
				y = cent[k,]
				dist = shift_dist(x,y)
				D[i,k] = dist[1]
			}
		}
		for (i in 1:rows) {
			mem[i] = which.min(D[i,])
		}
		if (norm(as.matrix(ori_mem-mem)) == 0) {
			break
		}
		cat("counter=",counter)
    print("\n")
		print(mem)
	}
	result <- c(mem,cent)
	return(result)
}
#result_shift = shift_dist(x,y)
#result_shift = shift_dist(as.matrix(mfile[2,]),as.matrix(mfile[2,]))
#min_dist = result_shift[1]
#optshift = result_shift[2]
#opty = as.matrix(c(result_shift[3:length(result_shift)]))
#cat("Distance =" , paste(min_dist,"\n"))
#print(ncol(mfile)) # time series length
#print(as.matrix(mfile[i,]))
K = 6
result_cluster = ksc_clustering(mfile,K)
cluster_set = matrix(result_cluster[1:nrow(mfile)],1,nrow(mfile))
center =  matrix(result_cluster[(nrow(mfile) + 1):length(result_cluster)],K,ncol(mfile))
#print(cluster_set)
#print(center)
par(mfrow=c(2,3))
#par(mfrow=c(4,3))
for (i in 1:nrow(center)) {
	name = paste("Cluster", i, sep = " ")
	plot(center[i,], type="l",main=name)
}

# Write CSV in R
result = cbind(as.matrix(files),t(cluster_set))
write.csv(result, file="/mnt/hgfs/Shared Virtual Machines/PaperReproduce/data/KSCresult.csv")