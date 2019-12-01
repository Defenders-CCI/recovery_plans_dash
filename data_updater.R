# setwd("/home/jacobmalcom/open/five_year_review")

print(Sys.Date())

library(digest)
library(readr)
library(rvest)

cur_lis <- readRDS("ESA_listed.rds")
attempt <- try(
  listed <- suppressMessages(read_csv("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=csv&distinct=true&columns=%2Fspecies%40sn%2Ccn%2Cstatus%2Cdesc%2Clisting_date%2Ccountry%3B%2Fspecies%2Ftaxonomy%40group%3B%2Fspecies%2Ffws_region%40desc&sort=%2Fspecies%40sn%20asc&filter=%2Fspecies%40country%20!%3D%20'Foreign'&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')"))
)

if(class(attempt) == "try-error") {
  att2 <- try(
    listed <- suppressMessages(read_csv("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=csv&distinct=true&columns=%2Fspecies%40sn%2Ccn%2Cstatus%2Cdesc%2Clisting_date%2Ccountry%3B%2Fspecies%2Ftaxonomy%40group%3B%2Fspecies%2Ffws_region%40desc&sort=%2Fspecies%40sn%20asc&filter=%2Fspecies%40country%20!%3D%20'Foreign'&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')"))
  )
}

if(exists("listed")) {
  if(dim(listed)[1] < 1000) {
    stop("Something is amiss.")
  } else {
    if(digest(listed) !=  digest(cur_lis)) { 
      file.rename("ESA_listed.csv", 
                  paste0("ESA_listed", Sys.Date(), ".csv"))
      write_csv(listed, "ESA_listed.csv")
      print("File backed up and new data written.")
    } else {
      print("No listing changes.")
    }
  }
} else {
  stop("Listing not downloaded from FWS.")
}


cur_rec <- suppressMessages(read_csv("recovery_data.csv"))
att3 <- try(
  rec_html <- read_html("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=htmltable&distinct=true&columns=%2Fspecies%40cn%2Csn%2Cstatus%2Cdesc%2Clisting_date%3B%2Fspecies%2Ftaxonomy%40group%3B%2Fspecies%2Ffws_region%40desc%3B%2Fspecies%2Fdocument%40title%2Cdoc_date%2Cdoc_type_qualifier&sort=%2Fspecies%40sn%20asc&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')&filter=%2Fspecies%40country%20!%3D%20'Foreign'&filter=%2Fspecies%2Fdocument%40doc_type%20%3D%20'Recovery%20Plan'")
)
if(class(att3) == "try-error") {
  att4 <- try(
    rec_html <- read_html("https://ecos.fws.gov/ecp/pullreports/catalog/species/report/species/export?format=htmltable&distinct=true&columns=%2Fspecies%40cn%2Csn%2Cstatus%2Cdesc%2Clisting_date%3B%2Fspecies%2Ftaxonomy%40group%3B%2Fspecies%2Ffws_region%40desc%3B%2Fspecies%2Fdocument%40title%2Cdoc_date%2Cdoc_type_qualifier&sort=%2Fspecies%40sn%20asc&filter=%2Fspecies%40status%20in%20('Endangered'%2C'Threatened')&filter=%2Fspecies%40country%20!%3D%20'Foreign'&filter=%2Fspecies%2Fdocument%40doc_type%20%3D%20'Recovery%20Plan'")
  )
}

if(exists("rec_html")) {
  recovery <- html_table(rec_html)[[1]]
  if(dim(recovery)[1] < 1000) {
    stop("Something is amiss.")
  } else {
    if(digest(recovery) !=  digest(cur_5yr)) { 
      file.rename("recovery_data.rds", 
                  paste0("recovery_data", Sys.Date(), ".rds"))
      saveRDS(recovery, "recovery_data.rds")
    } else {
      print("No 5-year review change")
    }
  }
} else {
  stop("Recovery data not downloaded from FWS.")
}