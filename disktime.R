#!/usr/bin/env Rscript

# 2015-06-01

library(ggplot2)
library(ggthemes)

c.names <- c('date', 'time', 'epoch', 'wait')
rows <- 120
data.dir <- '/gscmnt/gc2719/halllab/users/cchiang/src/disktime/data'

# read data
disk.data <- NULL
for (disk.name in c('gc2718', 'gc2719', 'gc2802')) {
    d <- tail(read.table(paste0(data.dir, '/', disk.name, '.time.txt'), col.names=c.names), rows)
    d$disk <- disk.name
    
    disk.data <- rbind(disk.data, d)
}

disk.data$posix <- as.POSIXct(disk.data$epoch, origin="1970-01-01")

p <- ggplot(data=disk.data, aes(x=posix, y=wait, col=disk))
p <- p + theme_bw() + scale_color_gdocs()
p <- p + theme(panel.border = element_blank(), axis.text = element_text(color='black'), axis.line.x = element_line(), axis.line.y = element_line(), panel.grid=element_blank())
# p <- p + geom_point()
p <- p + geom_line()
p <- p + scale_y_log10(breaks=10**(-1:10))
p <- p + annotation_logticks(side='l', scaled=TRUE)
p <- p + xlab('Date') + ylab('Wait (s)')
p <- p + scale_x_datetime(date_breaks='4 hours', date_labels="%D\n%H:%M")
## p

ggsave('/gscmnt/gc2719/halllab/users/cchiang/src/disktime/plots/disktime.pdf', p, h=4.5, w=7)
