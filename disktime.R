#!/usr/bin/env Rscript

# 2015-06-01

rows <- 120
diska <- tail(read.table('gc2718.time.txt'), rows)
diskb <- tail(read.table('gc2719.time.txt'), rows)
diskc <- tail(read.table('gc2802.time.txt'), rows)

col.list <- c('steelblue', 'indianred', 'gray50')

ymax <- max(c(diska[,4], diskb[,4], diskc[,4]))

pdf('disktime.pdf', height=8, width=8)
plot(diska[,3], diska[,4], type='n', axes=F, ylab='read-write duration (s)', xlab='time', ylim=c(0,ymax))
points(diska[,3], diska[,4], type='l', col=col.list[1])
points(diskb[,3], diskb[,4], type='l', col=col.list[2])
points(diskc[,3], diskc[,4], type='l', col=col.list[3])
axis(2)
axis(1, at=diska[seq(1,nrow(diska),nrow(diska)/10),3], labels=paste0(diska[seq(1,nrow(diska),nrow(diska)/10),1], '\n', diska[seq(1,nrow(diska),nrow(diska)/10),2]))

legend('topright', c('GC2718', 'GC2719', 'GC2802'), fill=col.list)

garbage <- dev.off()
