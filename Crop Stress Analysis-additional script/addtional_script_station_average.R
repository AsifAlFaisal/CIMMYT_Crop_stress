setwd("C:/Users/A.FAISAL/Documents/CIMMYT Scripts/Hussain Sir/Crop Stress Analysis-additional script")

df.tmax <- read.csv('DF_Tmax_BMD_final.csv')
df.tmin <- read.csv('DF_Tmin_BMD_final.csv')

###### MANUAL INPUT HERE ###
begin_year <- 1984                                          #input
end_year <- 2017                                            #input

begin_month <- 12                                           #input
begin_day <- 16                                             #input

end_month <- 12                                             #input
end_day <- 31                                               #input

crop_stage <- " Boro Rice (Optimum) [Sowing Stage]"         #input

###### END MANUAL INPUT SECTION ###

yr_range <- paste0(begin_year,"-",end_year)                                         #year range string
begin_date <- format(ISOdate(begin_year, begin_month, begin_day), format="%b %d")   #start date string
end_date <- format(ISOdate(end_year, end_month, end_day), format="%b %d")           #end date string
dt_range <- paste0(begin_date, "-", end_date)                                       #date range string


## MAX TEMP AVG ##
data.list <- list()

for (yr in begin_year:end_year){
  x <- which(df.tmax$Year==yr & df.tmax$Month==begin_month & df.tmax$Day==begin_day)
  y <- which(df.tmax$Year==yr & df.tmax$Month==end_month & df.tmax$Day==end_day)
  
  temp.df <- df.tmax[x:y,]
  
  data.list[[yr]] <- temp.df
  
  
};rm(temp.df)

temp1 <- do.call(rbind, data.list)
temp1 <- temp1[,4:length(temp1)]

final.df <- data.frame(t(colMeans(temp1)))
final.df['threshold'] <- 'MAX'
final.df['year_range'] <- yr_range
final.df['date_range'] <- dt_range
final.df['crop_stage'] <- crop_stage

column_order <- c("year_range", "date_range", "crop_stage", "threshold", names(temp1))
final.df <- final.df[, column_order]
###################


## MIN TEMP AVG ##
data.list2 <- list()

for (yr in begin_year:end_year){
  x <- which(df.tmin$Year==yr & df.tmin$Month==begin_month & df.tmin$Day==begin_day)
  y <- which(df.tmin$Year==yr & df.tmin$Month==end_month & df.tmin$Day==end_day)
  
  temp.df <- df.tmin[x:y,]
  
  data.list2[[yr]] <- temp.df
  
  
};rm(temp.df)

temp2 <- do.call(rbind, data.list2)
temp2 <- temp2[,4:length(temp2)]

final.df2 <- data.frame(t(colMeans(temp2)))
final.df2['threshold'] <- 'MIN'
final.df2['year_range'] <- yr_range
final.df2['date_range'] <- dt_range
final.df2['crop_stage'] <- crop_stage

column_order2 <- c("year_range", "date_range", "crop_stage", "threshold", names(temp2))
final.df2 <- final.df2[, column_order2]
###################

merged.df <- rbind(final.df, final.df2)


file_name <- paste0(yr_range, "_", dt_range, "_", crop_stage, ".csv")                  # csv file name

write.csv(merged.df, file = paste0('Stored Files/', file_name), row.names = FALSE)
