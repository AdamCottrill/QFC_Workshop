#=============================================================
# c:/1work/Modelling/QFC_workshop/examples/extract_data/slh_whitefish.r
# Created: 11 Nov 2013 13:56:36

#
# DESCRIPTION:
#
#
#
# A. Cottrill
#=============================================================

# LIBRARIES:

library(RODBC)
library(reshape2)

# OTHER SCRIPTS:
#source("")

#=============================================================

dbase <- c("E:/Data Warehouse/Merged Datasets/Species_Databases/Lake_Whitefish/091_United.mdb")

qmas <- "'6-1'"
#qmas <- "'5-8','5-9'"
yr <- 2002
basin <- switch(qmas,
                "'6-1'"='nc',
                "'4-5'"='smb',
                'gb') 


sql <- 
"SELECT AGE, FLEN FROM All_BioData
INNER JOIN [LOCATION with LATLONG] ON All_BioData.GRID = [LOCATION with LATLONG].GRID
WHERE ((([LOCATION with LATLONG].QUOTA_ZONE) IN (qmas)) AND ((All_BioData.YEAR)='yr') AND ((All_BioData.AGE) Is Not Null) AND ((All_BioData.FLEN) Is Not Null))
ORDER BY All_BioData.AGE, All_BioData.FLEN;"


sql <- gsub('yr', yr,  sql)
sql <- gsub('qmas', qmas,  sql)


DBConnection <- odbcConnectAccess(dbase,uid = "", pwd = "")
data <- sqlQuery(DBConnection, sql)
    head(data)
    str(data)
    nrow(data)
odbcClose(DBConnection)            

N <- 10
ages <-  unique(data$AGE)
selected <- subset(data, data$AGE<0)

for (i in seq(along=ages)){
    sub <- subset(data, data$AGE==ages[i])
    if (nrow(sub) <= N){
        selected <- rbind(selected, sub)
    } else {
        selected <- rbind(selected, sub[sample(nrow(sub),N,replace=F),])
    }
}

outdir <- 'c:/1work/Modelling/QFC_workshop/examples/extract_data/'
fname <-paste0(outdir,'whitefish-',basin,'-', yr, '.csv')

               
jj <- selected[with(selected, order('AGE', 'FLEN')),]
write.csv(selected, fname,row.names=FALSE)

f <- function()
{
  ## Purpose:
  ## ----------------------------------------------------------------------
  ## Arguments:
  ## ----------------------------------------------------------------------
  ## Author: , Date:  5 Dec 2013, 14:54
}


library(reshape2)




#fit the model and predicte size at age
start = list('Linf'=max(data$FLEN), 't0'=0.0, 'k'=0.25)
vonB <- nls(FLEN ~ Linf * (1 - exp(-k * (AGE - t0))),
    data=data, start=start)

summary(vonB)

predicted <- data.frame('AGE' = seq((min(ages) -1),
                           max(ages) + 1, by=0.1), 'FLEN'=0)

predicted$FLEN <- predict(vonB,newdata=predicted)


#make a plot
plot(data$AGE, data$FLEN, xlab="Age",
      ylab="Fork Length (mm)")
lines(predicted$AGE, predicted$FLEN, col='blue')


#calculate mean size at age
mu <- cast(data, AGE~., value='FLEN', fun=mean)
names(mu) <- c('Age','Observed')
mu$Predicted <- predict(vonB, newdata=data.frame('AGE'=ages))


