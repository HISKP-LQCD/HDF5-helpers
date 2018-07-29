# Make the HDF5 package available.
#install.packages("h5")
library(h5)

library(hadron)

time.extent <- 48

# Open HDF5 file.
f <- h5file('C2_p0_A1g_avg.h5')

# Extract the actual data from the object, whatever that is in detail. Out
# comes a data frame which has the configuration index as a label. It is a 1D
# structure though.
b <- f['data']['block0_values'][]

# Here we “reshape” it into a matrix with 48 rows because we know that the data
# has 48 time slices. Rows are the time slices, columns are the configurations.
m <- matrix(b, nrow=time.extent)

# This plots the first column, that will give a correlation function.
plot(m[, 1], main='First Row', xlab='Time Slice', ylab='Correlator')

# Then we plot the first time slice of all configurations, just because we can.
plot(m[1,], main='First Time Slice', xlab='Configuration Number', ylab='Correlator')

# We apply the Ulli Wolff method to compute the correlation time for fixed time
# slice accross the configurations.
corrs <- apply(m, 1, function(x) uwerrprimary(x))

corrs.val <- sapply(corrs, function(x) (x)$tauint)
corrs.err <- sapply(corrs, function(x) (x)$dtauint)

plotwitherror(1:length(corrs.val), corrs.val, corrs.err,
              main='Autocorrelation Across Configurations',
              xlab='Time Slice',
              ylab='Integrated Autocorrelation Time')
