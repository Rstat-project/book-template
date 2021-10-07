# import package
# when there are more than one date-time formats
library(lubridate)

# set up working dir
setwd("../")

# parameters for assignments
current_assignment <- "Level01-assignment002"
# define the current deadline
deadline <- parse_date_time("2021/10/04 14:00:00","ymd_HMS",tz="Asia/Taipei")
##strptime("2021/10/04 14:00:00",format = '%Y/%m/%d %H:%m:%S', tz="Asia/Taipei")





# Locate Assignment.html from every project folder
assignment_paths <- dir(current_assignment, pattern = "Assignment.html",recursive = TRUE,include.dirs = TRUE,full.names = TRUE)

# store the submitted students
submitted_accounts <- gsub(assignment_paths,pattern = "Level01-assignment002/|/Assignment.html",replacement = "")
submitted_date <- NULL
submitted_check <- NULL
# making of meta table
for(i in 1:length(assignment_paths)){
# import the content from html files
    assignment_content <- readLines(assignment_paths[i],encoding = "UTF-8")
# extract the date from the html files    
    tmp_date <- gsub(assignment_content[grep(assignment_content,pattern = "class=\"date\"")],
                     pattern = "<(“[^”]*”|'[^’]*’|[^'”>])*>",
                     replacement = "")
print(i)
## We will use base::strptime when the date time format are fixed in YAML
if(!is.na(tmp_date)){
    submitted_check <- c(submitted_check, 
                         difftime(deadline, parse_date_time(tmp_date,"ymd_HMS",tz="Asia/Taipei"),  units = "secs" ) > 0 )
    
    submitted_date <- c(submitted_date, tmp_date)
}else{
    submitted_check <- NULL
    submitted_date <- NULL
   }
print(tmp_date)    
}

dt <- data.frame(name=submitted_accounts, date= submitted_date,check=submitted_check)

write.csv(dt, 
          file = paste0(current_assignment,"/","submitted_check.csv"),
          row.names = FALSE,
          fileEncoding = "UTF-8")



