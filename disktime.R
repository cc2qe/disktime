#!/usr/bin/env Rscript

options(warn=-1)

# 2015-06-01

library(ggplot2)
library(ggthemes)
library(scales)

c.names <- c('date', 'time', 'epoch', 'wait')
## rows <- 336
work.dir <- '.'
data.dir <- paste0(work.dir, '/data')

# set timespan of the past 4 days
timespan <- c(Sys.time() - as.difftime(4, unit="days"), Sys.time())

# read data
disk.data <- NULL
for (disk.name in c('gc2718', 'gc2719', 'gc2802')) {
    d <- read.table(paste0(data.dir, '/', disk.name, '.time.txt'), col.names=c.names)
    d$disk <- disk.name
    
    disk.data <- rbind(disk.data, d)
}

## disk.data$posix <- as.POSIXct(disk.data$epoch, origin="1970-01-01", tz="America/Chicago")
disk.data$posix <- as.POSIXct(disk.data$epoch, origin="1970-01-01")
## tail(disk.data$posix[1])

## draw plot
pdf(paste0(work.dir, '/plots/', 'disktime.pdf'), h=4.5, w=7)

p <- ggplot(data=disk.data, aes(x=posix, y=wait, col=disk))
p <- p + theme_bw() + scale_color_gdocs()
p <- p + theme(panel.border = element_blank(), axis.text = element_text(color='black'), axis.line.x = element_line(), axis.line.y = element_line(), panel.grid=element_blank())
# p <- p + geom_point()
p <- p + geom_line()
p <- p + scale_y_log10(breaks=10**(-1:10))
p <- p + annotation_logticks(side='l', scaled=TRUE)
p <- p + xlab('Date') + ylab('Wait (s)')
p <- p + scale_x_datetime(date_breaks='12 hours', labels=date_format("%H:%M\n%m/%d", tz = "America/Chicago"), limits = timespan)
# p <- p + scale_x_datetime(date_breaks='12 hours', date_labels="%H:%M\n%m/%d", limits = timespan)
print(p)

## ggsave(paste0(work.dir, '/plots/', 'disktime.pdf'), p, h=4.5, w=7)

p <- ggplot(data=disk.data, aes(x=posix, y=wait, col=disk, fill=disk))
p <- p + theme_bw() + scale_color_gdocs() + scale_fill_gdocs()
p <- p + theme(panel.border = element_blank(), axis.text = element_text(color='black'), axis.line.x = element_line(), axis.line.y = element_line(), panel.grid=element_blank())
## p <- p + geom_point()
p <- p + geom_smooth(method="loess", se=T, span=0.1, formula=y~x, alpha=0.1)
## p <- p + scale_y_log10(breaks=10**(-1:10))
## p <- p + annotation_logticks(side='l', scaled=TRUE)
p <- p + xlab('Date') + ylab('Wait (s)')
p <- p + scale_x_datetime(date_breaks='12 hours', labels=date_format("%H:%M\n%m/%d", tz = "America/Chicago"), limits = timespan)
# p <- p + scale_x_datetime(date_breaks='12 hours', date_labels="%H:%M\n%m/%d", limits = timespan)
print(p)

garbage <- dev.off()
