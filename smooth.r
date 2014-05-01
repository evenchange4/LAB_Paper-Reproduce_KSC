setup_data = read.csv('M:/Shared Virtual Machines/PaperReproduce/data/1000/time_series_all/1678806.csv')

set1 = subset(setup_data, Index >= 440 & Index <= 570)

smooth <- function(setup_data, b,c) {
	with(setup_data, {
	    plot(Index, Volume)
	    lines(ksmooth(Index, Volume, "normal", bandwidth = b), col = 3)
	})



	a = with(setup_data, {
	    ksmooth(Index, Volume, "normal", bandwidth = b)
	})
	print(a["y"][[1]][[c]])	
}
smooth(set1, 6, 5)

# print(a["y"][[1]][[c]])	
