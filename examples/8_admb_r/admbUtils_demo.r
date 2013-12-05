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
data_list <- list(Linf=max(mydata$FLEN), k=0.3, t0=0, sigma=1)
write.pin(L=data_list,name=fname)


#===============
#  read.fit()

# given the path to a fitted admb object, read.fit() will read the parameter and std files and return their contents as a named list, including the gradient, objectitive function and parameter count.
#read.fit() is actually just a wrapper for read.par() and read.std()
fit <-  read.fit("Von_Bert")
str(fit)
fit$est
fit$std


#===============
#read.mcmc()

#read.mcmc() will attempt to read in an mcmc file, parse it and return
#a coda object.  If the mcmc file is a cvs file with a header row, no
#additional arguments are needed.

mcmc <- read.mcmc(mcmc.file="mcmc.csv")

class(mcmc)
str(mcmc)
# because its already an mcmc object we can use some of R's canned
# plotting functions for mcmc's.
plot(mcmc)                  
xyplot(mcmc,  aspect="fill", layout=c(2,2))
densityplot(mcmc, aspect="fill", layout=c(2,2))
acfplot(my.mcmc, aspect="fill", layout=c(2,3))
qqmath(my.mcmc, aspect="fill", layout=c(2,3))


#===============
# readcxx()

# if you used admb2r to create an rdat file for additional model output, you can call readcxx() to get a named list that contain all of the values in par file, the std file and the contents of rdat.

fit <-  readcxx("Von_Bert")
str(fit)
fit$std

