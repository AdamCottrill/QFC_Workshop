#=============================================================
# c:/1work/Modelling/QFC_workshop/examples/8_admb_r/admbUtils_demo.r
# Created: 12/04/13 5:44 PM
#
# DESCRIPTION:
#
# This scripts demonstrates how to use the basic functions in
# ADMButils to read and write files that can be read by/ or are
# produced by AD Model Builder.
# 
#=============================================================

# LIBRARIES:
library(lattice)
library(ADMButils)

#=============================================================

#read in the same dataset we have been working with all day
mydata <- read.csv('whitefish.csv', header=TRUE)
head(mydata)

#===============
#  write.dat()

#write.dat takes a filename and named list of data elements and
#creates a dat file that can be read by admb.  Elemnts in the data
#list must match the order expected by admb.
fname <- "Von_Bert.dat"
data_list <- list(Linf_L=300, Linf_U=1200, nobs=nrow(mydata),
                  data=mydata)
write.dat(L=data_list,name=fname)

#write_dat() also recodes any character or factor variables and includes a
#key in dat file. Try
#write.dat(L=list(iris=iris),name='iris.dat')

#===============
#  write.pin()

#write.pin takes a filename and named list of parameters and their
#starting values and creates a dat file that can be read by admb.
#Elements in the parameter list must match the order that parameters
#are declared in the parameter section of your tpl.
fname <- "Von_Bert.pin"
pin_list <- list(Linf=max(mydata$FLEN), k=0.3, t0=0)
write.pin(L=pin_list, name=fname)


#===============
#  read.par()

# given the path to a fitted admb object, read.par() will read the parameter file and return its contents as a named list, including the gradient, objectitive function and parameter count.
# if reduced==TRUE, the parameter estimates will be omitted (see read.std())
fit <-  read.par("Von_Bert", reduce=FALSE)
fit
str(fit)
fit$par.cnt
fit$obj.fct
fit$gradient
fit$Linf

#===============
#  read.std()

# given the path to a fitted admb object, read.std() will read the std file and return its contents either as a dataframe or as a named list, 
fit <-  read.std("Von_Bert")
fit
str(fit)

fit <-  read.std("Von_Bert", as.df=FALSE)
fit
str(fit)



#===============
#  read.fit()

# given the path to a fitted admb object, read.fit() will read the parameter and std files and return their contents as a named list, including the gradient, objectitive function and parameter count.
#read.fit() is actually just a wrapper for read.par() and read.std()
fit <-  read.fit("Von_Bert")
str(fit)
fit$est
fit$std
fit$cov
fit$cor


#===============
#read.mcmc()

#read.mcmc() will attempt to read in an mcmc file, parse it and return
#a coda object.  If the mcmc file is a cvs file with a header row, no
#additional arguments are needed.

# don't forget to create mcmc chain first;
# -mcmc 100000 -mcsave 50
# -mceval

mcmc <- read.mcmc(mcmc.file="mcmc.csv")
class(mcmc)
str(mcmc)
# because its already an mcmc object we can use some of R's canned
# plotting functions for mcmc's.
plot(mcmc)                  
xyplot(mcmc,  aspect="fill", layout=c(2,2))
densityplot(mcmc, aspect="fill", layout=c(2,2))
acfplot(mcmc, aspect="fill", layout=c(2,2))
qqmath(mcmc, aspect="fill", layout=c(2,2))


#===============
# readcxx()

# if you used admb2r to create an rdat file for additional model output, you can call readcxx() to get a named list that contain all of the values in par file, the std file and the contents of rdat.

fit <-  readcxx("Von_Bert")
str(fit)
fit$std

#scalars in vector list can be accessed with literal scripting:
fit$dims['nobs']
fit$dims$nobs    # Error - won't work for vectors
#scalars in info_list can be accessed as sublists
fit$dims2$nobs
fit$dims2['nobs']  #both work here.


plot(fit$residuals$Age,fit$residuals$resid)
