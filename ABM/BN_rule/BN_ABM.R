library(bnlearn)
library(Rgraphviz)
library(gplots)
library(plyr)
library(alluvial)
library(boot)
library(klaR)
library(entropy)

setwd("C:/Users/pyangac/Documents/research/cabbi/ABM_pilot/BN_rule")
source("table_2_bl.R")
source("BN_validation.R")

df = read.table("BN_data_start1_adj.csv",header=TRUE,sep=",")
df$ID = NULL
df.complete = na.omit(df)

df.factor = data.frame(lapply(df, as.factor))
df.factor_complete = data.frame(lapply(df.complete, as.factor))

dag = model2network(paste("[farm_size][info_use][peer_ec][benefit][concern][lql][SC_Contract][SC_Rev_mean][SC_Rev_range]",
                          "[imp_env|farm_size:info_use][max_fam|info_use:peer_ec]",
                          "[SC_Will|benefit:concern:imp_env:max_fam:lql:SC_Contract:SC_Rev_mean:SC_Rev_range]",
                          "[SC_Ratio|SC_Will:SC_Contract:SC_Rev_mean:SC_Rev_range]", sep=""))
graph.par(list(nodes=list(lwd=2, fontsize=15)))
jpeg(filename = "ABM_network.jpg",
     width = 24, height = 10, units = "in", 
     bg = "white", res = 300)
graphviz.plot(dag,shape = "ellipse")
dev.off()

dag.fitted = bn.fit(dag,df.factor)
# df.imputed = impute(dag.fitted, df.factor) 
# write.csv(df.imputed,"BN_data_start1_adj_filled.csv")

sim_all = rbn(dag.fitted,n = 10^6)
sim_all = sim_all[complete.cases(sim_all), ]

write.csv(sim_all,'BN_df.csv', row.names=FALSE)
