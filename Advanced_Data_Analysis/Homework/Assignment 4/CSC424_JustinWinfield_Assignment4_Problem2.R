#Cluster Analysis - Part of HW 4
d.metric <- d.oct.clean[c(6,14:20)]
d.metric.std <- apply(d.metric, 2, sd)
d.kmed <- pam(d.metric.std, k=5, diss=F)
plot(d.kmed, which.plots=1)
d.kmed$clustering
