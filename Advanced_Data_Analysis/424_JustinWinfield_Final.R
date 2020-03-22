#####
## Reading a JSON file
### install jsonlite package (done in the console)
library(jsonlite)

divvy.json.url <- "https://feeds.divvybikes.com/stations/stations.json"

divvy.data <- fromJSON(txt=divvy.json.url)
head(divvy.data)
View(divvy.data)
names(divvy.data)

x <- divvy.data$stationBeanList
head(x, 1)
View(x)

head(x[c(5:6, 11,13:14)])
x1 <- x[c(5:6, 11,13:14)]
View(x1)
write.csv(x1, file="full_station_name.csv")


#Load Libraries
library(tidyr)
library(ggplot2)
library(ca)
library(cluster)


#Read-in dataset(s)
d <- read.csv("divvy_sorted.csv", header=T, sep=",")
head(d)
View(d)
dim(d) #657,503 observations, 20 variables

# Data Manipulation
# Subsetting for only October data. Removing all missing values from dataset
d$start_time <- as.character.Date(d$start_time)
d.oct <- d[d$start_time < "2017-11-01 00:00:00 UTC", ]
d.oct.clean <- d.oct %>% drop_na()
View(d.oct.clean)

temp.write <- d.oct.clean[c(8,23)]
write.csv(temp.write, file="temporary_clean.csv")

d.oct.clean$from_station_name <-  as.character(d.oct.clean$from_station_name)
d.oct.clean$to_station_name <-  as.character(d.oct.clean$to_station_name)
d.oct.clean$to_station_id <-  as.character(d.oct.clean$to_station_id)
d.oct.clean$usertype <- as.character(d.oct.clean$usertype)
d.oct.clean$gender <- as.character(d.oct.clean$gender) #From here, these variables are now being read as characters instead of factors

# Creating a new variable called birth_generation to group the birth year into Generations
attach(d.oct.clean)
d.oct.clean$birth_gen[d.oct.clean$birthyear < 1946] <-  "Greatest Gen"
d.oct.clean$birth_gen[d.oct.clean$birthyear >= 1946 & d.oct.clean$birthyear <= 1964] <-  "Baby Boomers"
d.oct.clean$birth_gen[d.oct.clean$birthyear > 1965 & d.oct.clean$birthyear <= 1979] <-  "Gen X"
d.oct.clean$birth_gen[d.oct.clean$birthyear > 1980 & d.oct.clean$birthyear <= 2000] <-  "Millenials"
d.oct.clean$birth_gen[d.oct.clean$birthyear > 2001] <-  "Gen Z"
detach(d.oct.clean)

# Creating a new variables, from_zipcode to group the station names together
############
attach(d.oct.clean)
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "2112 W Peterson Ave"] <- "60659"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "63rd St Beach" |
                           d.oct.clean$from_station_name == "Bennett Ave & 79th St" |
                           d.oct.clean$from_station_name == "Jeffery Blvd & 67th St" |
                           d.oct.clean$from_station_name == "Jeffery Blvd & 71st St" |
                           d.oct.clean$from_station_name == "Jeffery Blvd & 76th St" |
                           d.oct.clean$from_station_name == "Phillips Ave & 79th St" |
                           d.oct.clean$from_station_name == "Rainbow Beach" |
                           d.oct.clean$from_station_name == "Saginaw Ave & Exchange Ave" |
                           d.oct.clean$from_station_name == "South Shore Dr & 67th St" |
                           d.oct.clean$from_station_name == "South Shore Dr & 71st St" |
                           d.oct.clean$from_station_name == "South Shore Dr & 74th St" |
                           d.oct.clean$from_station_name == "Stony Island Ave & 67th St" |
                           d.oct.clean$from_station_name == "Stony Island Ave & 71st St" |
                           d.oct.clean$from_station_name == "Yates Blvd & 75th St"] <- "60649"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "900 W Harrison St" | 
                           d.oct.clean$from_station_name == "Aberdeen St & Jackson Blvd" |
                           d.oct.clean$from_station_name =="Aberdeen St & Monroe St" | 
                           d.oct.clean$from_station_name == "Ada St & Washington Blvd" |
                           d.oct.clean$from_station_name == "Canal St & Harrison St" |
                           d.oct.clean$from_station_name == "Canal St & Taylor St" |
                           d.oct.clean$from_station_name == "Clinton St & Polk St (*)" |
                           d.oct.clean$from_station_name == "Clinton St & Roosevelt Rd" |
                           d.oct.clean$from_station_name == "Clinton St & Tilden St" |
                           d.oct.clean$from_station_name == "Green St & Randolph St" |
                           d.oct.clean$from_station_name == "Halsted St & Maxwell St" |
                           d.oct.clean$from_station_name == "Halsted St & Polk St" |
                           d.oct.clean$from_station_name == "Loomis St & Jackson Blvd" |
                           d.oct.clean$from_station_name == "Loomis St & Lexington St" |
                           d.oct.clean$from_station_name == "Loomis St & Taylor St (*)" |
                           d.oct.clean$from_station_name == "May St & Taylor St" |
                           d.oct.clean$from_station_name == "Morgan St & Lake St" |
                           d.oct.clean$from_station_name == "Morgan St & Polk St" |
                           d.oct.clean$from_station_name == "Peoria St & Jackson Blvd" |
                           d.oct.clean$from_station_name == "Racine Ave (May St) & Fulton St" |
                           d.oct.clean$from_station_name == "Racine Ave & Congress Pkwy" |
                           d.oct.clean$from_station_name == "Racine Ave & Randolph St" |
                           d.oct.clean$from_station_name == "Sangamon St & Washington Blvd (*)" |
                           d.oct.clean$from_station_name == "Stave St & Armitage Ave" |
                           d.oct.clean$from_station_name == "Wells St & Polk St"] <- "60607"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Adler Planetarium" |
                           d.oct.clean$from_station_name == "Buckingham Fountain" |
                           d.oct.clean$from_station_name == "Burnham Harbor" |
                           d.oct.clean$from_station_name == "Clark St & 9th St (AMLI)" |
                           d.oct.clean$from_station_name == "Clark St & Congress Pkwy" |
                           d.oct.clean$from_station_name == "Dearborn St & Van Buren St (*)" |
                           d.oct.clean$from_station_name == "Delano Ct & Roosevelt Rd" |
                           d.oct.clean$from_station_name == "Federal St & Polk St" |
                           d.oct.clean$from_station_name == "Field Museum" |
                           d.oct.clean$from_station_name == "Financial Pl & Congress Pkwy" |
                           d.oct.clean$from_station_name == "Indiana Ave & Roosevelt Rd" |
                           d.oct.clean$from_station_name == "Michigan Ave & 14th St" |
                           d.oct.clean$from_station_name == "Michigan Ave & 8th St" |
                           d.oct.clean$from_station_name == "Michigan Ave & Congress Pkwy" |
                           d.oct.clean$from_station_name == "Shedd Aquarium" |
                           d.oct.clean$from_station_name == "State St & Harrison St" |
                           d.oct.clean$from_station_name == "Wabash Ave & 16th St" |
                           d.oct.clean$from_station_name == "Wabash Ave & 9th St" |
                           d.oct.clean$from_station_name == "Wabash Ave & Roosevelt Rd"] <- "60605"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Albany Ave & 26th St" |
                           d.oct.clean$from_station_name == "Central Park Ave & Ogden Ave" |
                           d.oct.clean$from_station_name == "Kedzie Ave & 21st St" |
                           d.oct.clean$from_station_name == "Kedzie Ave & 24th St" |
                           d.oct.clean$from_station_name == "Lawndale Ave & 23rd St" |
                           d.oct.clean$from_station_name == "Millard Ave & 26th St" |
                           d.oct.clean$from_station_name == "California Ave & 26th St"] <- "60623"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Albany Ave & Bloomingdale Ave" |
                           d.oct.clean$from_station_name == "California Ave & Altgeld St" |
                           d.oct.clean$from_station_name == "California Ave & Francis Pl" |
                           d.oct.clean$from_station_name == "California Ave & Milwaukee Ave" |
                           d.oct.clean$from_station_name == "California Ave & North Ave" |
                           d.oct.clean$from_station_name == "Campbell Ave & Fullerton Ave" |
                           d.oct.clean$from_station_name == "Campbell Ave & North Ave" |
                           d.oct.clean$from_station_name == "Central Park Ave & North Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Charleston St" |
                           d.oct.clean$from_station_name == "Drake Ave & Fullerton Ave" |
                           d.oct.clean$from_station_name == "Humboldt Blvd & Armitage Ave" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Milwaukee Ave" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Palmer Ct" |
                           d.oct.clean$from_station_name == "Kosciuszko Park" |
                           d.oct.clean$from_station_name == "Leavitt St & Armitage Ave" |
                           d.oct.clean$from_station_name == "Logan Blvd & Elston Ave" |
                           d.oct.clean$from_station_name == "Milwaukee Ave & Rockwell St" |
                           d.oct.clean$from_station_name == "Milwaukee Ave & Wabansia Ave" |
                           d.oct.clean$from_station_name == "Richmond St & Diversey Ave" |
                           d.oct.clean$from_station_name == "Spaulding Ave & Armitage Ave" |
                           d.oct.clean$from_station_name == "Western Ave & Winnebago Ave"] <- "60647"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Albany Ave & Montrose Ave" |
                           d.oct.clean$from_station_name == "Campbell Ave & Montrose Ave" |
                           d.oct.clean$from_station_name == "Christiana Ave & Lawrence Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Foster Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Leland Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Sunnyside Ave" |
                           d.oct.clean$from_station_name == "Francisco Ave & Foster Ave" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Bryn Mawr Ave" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Foster Ave" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Leland Ave" |
                           d.oct.clean$from_station_name == "Leavitt St & Lawrence Ave" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Leavitt St" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Winona St" |
                           d.oct.clean$from_station_name == "Manor Ave & Leland Ave" |
                           d.oct.clean$from_station_name == "Rockwell St & Eastwood Ave" |
                           d.oct.clean$from_station_name == "St. Louis Ave & Balmoral Ave" |
                           d.oct.clean$from_station_name == "Washtenaw Ave & Lawrence Ave" |
                           d.oct.clean$from_station_name == "Western Ave & Leland Ave"] <- "60625"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Artesian Ave & Hubbard St" |
                           d.oct.clean$from_station_name == "Ashland Ave & Harrison St" |
                           d.oct.clean$from_station_name == "Ashland Ave & Lake St" |
                           d.oct.clean$from_station_name == "California Ave & Lake St" |
                           d.oct.clean$from_station_name == "Damen Ave & Madison St" |
                           d.oct.clean$from_station_name == "Hermitage Ave & Polk St" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Harrison St" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Lake St" |
                           d.oct.clean$from_station_name == "Ogden Ave & Congress Pkwy" |
                           d.oct.clean$from_station_name == "Sacramento Blvd & Franklin Blvd" |
                           d.oct.clean$from_station_name == "Western Ave & Congress Pkwy" |
                           d.oct.clean$from_station_name == "Western Ave & Monroe St" |
                           d.oct.clean$from_station_name == "Wolcott Ave & Polk St" |
                           d.oct.clean$from_station_name == "Wood St & Taylor St"] <- "60612"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Ashland Ave & 13th St" | 
                           d.oct.clean$from_station_name == "Ashland Ave & 21st St" |
                           d.oct.clean$from_station_name == "Ashland Ave & Archer Ave" |
                           d.oct.clean$from_station_name == "Blue Island Ave & 18th St" |
                           d.oct.clean$from_station_name == "Damen Ave & Coulter St" |
                           d.oct.clean$from_station_name == "Damen Ave & Cullerton St" |
                           d.oct.clean$from_station_name == "Fairfield Ave & Roosevelt Rd" |
                           d.oct.clean$from_station_name == "Halsted St & 21st St" |
                           d.oct.clean$from_station_name == "Halsted St & Archer Ave" |
                           d.oct.clean$from_station_name == "Halsted St & Roosevelt Rd" |
                           d.oct.clean$from_station_name == "Loomis St & Archer Ave" |
                           d.oct.clean$from_station_name == "May St & Cullerton St" |
                           d.oct.clean$from_station_name == "Morgan Ave & 14th Pl" |
                           d.oct.clean$from_station_name == "Morgan St & 18th St" |
                           d.oct.clean$from_station_name == "Morgan St & 31st St" |
                           d.oct.clean$from_station_name == "Ogden Ave & Roosevelt Rd" |
                           d.oct.clean$from_station_name == "Paulina St & 18th St" |
                           d.oct.clean$from_station_name == "Racine Ave & 13th St" |
                           d.oct.clean$from_station_name == "Racine Ave & 15th St" |
                           d.oct.clean$from_station_name == "Racine Ave & 18th St" |
                           d.oct.clean$from_station_name == "Washtenaw Ave & Ogden Ave (*)" |
                           d.oct.clean$from_station_name == "Western Ave & 21st St" |
                           d.oct.clean$from_station_name == "Western Ave & 24th St" |
                           d.oct.clean$from_station_name == "Western Ave & 28th St" |
                           d.oct.clean$from_station_name == "California Ave & 21st St" |
                           d.oct.clean$from_station_name == "California Ave & 23rd Pl"] <- "60608"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Ashland Ave & 50th St" |
                           d.oct.clean$from_station_name == "Ashland Ave & McDowell Ave" |
                           d.oct.clean$from_station_name == "Ashland Ave & Pershing Rd" |
                           d.oct.clean$from_station_name == "Damen Ave & 51st St" |
                           d.oct.clean$from_station_name == "Damen Ave & Pershing Rd" |
                           d.oct.clean$from_station_name == "Elizabeth St & 47th St" |
                           d.oct.clean$from_station_name == "Halsted St & 35th St (*)" |
                           d.oct.clean$from_station_name == "Halsted St & 37th St" |
                           d.oct.clean$from_station_name == "Halsted St & 47th Pl" |
                           d.oct.clean$from_station_name == "Halsted St & 51st St" |
                           d.oct.clean$from_station_name == "Hoyne Ave & 47th St" |
                           d.oct.clean$from_station_name == "Leavitt St & Archer Ave" |
                           d.oct.clean$from_station_name == "Marshfield Ave & 44th St" |
                           d.oct.clean$from_station_name == "Morgan St & Pershing Rd" |
                           d.oct.clean$from_station_name == "Princeton Ave & 47th St" |
                           d.oct.clean$from_station_name == "Princeton Ave & Garfield Blvd" |
                           d.oct.clean$from_station_name == "Racine Ave & 35th St" |
                           d.oct.clean$from_station_name == "Racine Ave & Garfield Blvd" |
                           d.oct.clean$from_station_name == "Seeley Ave & Garfield Blvd" |
                           d.oct.clean$from_station_name == "Shields Ave & 43rd St" |
                           d.oct.clean$from_station_name == "State St & Pershing Rd" |
                           d.oct.clean$from_station_name == "Throop St & 52nd St" |
                           d.oct.clean$from_station_name == "Union Ave & Root St" |
                           d.oct.clean$from_station_name == "Wallace St & 35th St" |
                           d.oct.clean$from_station_name == "Western Blvd & 48th Pl" |
                           d.oct.clean$from_station_name == "Wood St & 35th St"] <- "60609"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Ashland Ave & 63rd St" |
                           d.oct.clean$from_station_name == "Ashland Ave & 69th St" |
                           d.oct.clean$from_station_name == "Ashland Ave & Garfield Blvd" |
                           d.oct.clean$from_station_name == "Damen Ave & 59th St" |
                           d.oct.clean$from_station_name == "Marshfield Ave & 59th St" |
                           d.oct.clean$from_station_name == "Racine Ave & 65th St"] <- "60636"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Ashland Ave & Augusta Blvd" |
                           d.oct.clean$from_station_name == "Ashland Ave & Grand Ave" |
                           d.oct.clean$from_station_name == "Carpenter St & Huron St" |
                           d.oct.clean$from_station_name == "Dayton St & North Ave" |
                           d.oct.clean$from_station_name == "Eckhart Park" |
                           d.oct.clean$from_station_name == "Elston Ave & Wabansia Ave" |
                           d.oct.clean$from_station_name == "Halsted St & Blackhawk St (*)" |
                           d.oct.clean$from_station_name == "Halsted St & North Branch St" |
                           d.oct.clean$from_station_name == "Noble St & Milwaukee Ave" |
                           d.oct.clean$from_station_name == "Ogden Ave & Chicago Ave" |
                           d.oct.clean$from_station_name == "Ogden Ave & Race Ave" |
                           d.oct.clean$from_station_name == "Sheffield Ave & Kingsbury St"] <- "60642"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Ashland Ave & Belle Plaine Ave" |
                           d.oct.clean$from_station_name == "Ashland Ave & Grace St" |
                           d.oct.clean$from_station_name == "Broadway & Cornelia Ave" |
                           d.oct.clean$from_station_name == "Broadway & Sheridan Rd" |
                           d.oct.clean$from_station_name == "Broadway & Waveland Ave" |
                           d.oct.clean$from_station_name == "Clarendon Ave & Gordon Ter" |
                           d.oct.clean$from_station_name == "Clarendon Ave & Junior Ter" |
                           d.oct.clean$from_station_name == "Clark St & Grace St" |
                           d.oct.clean$from_station_name == "Clark St & Montrose Ave" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Waveland Ave" |
                           d.oct.clean$from_station_name == "Montrose Harbor" |
                           d.oct.clean$from_station_name == "Paulina St & Montrose Ave" |
                           d.oct.clean$from_station_name == "Pine Grove Ave & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Pine Grove Ave & Waveland Ave" |
                           d.oct.clean$from_station_name == "Ravenswood Ave & Berteau Ave" |
                           d.oct.clean$from_station_name == "Ravenswood Ave & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Ravenswood Ave & Montrose Ave (*)" |
                           d.oct.clean$from_station_name == "Sheridan Rd & Buena Ave" |
                           d.oct.clean$from_station_name == "Sheridan Rd & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Sheridan Rd & Montrose Ave" |
                           d.oct.clean$from_station_name == "Southport Ave & Clark St" |
                           d.oct.clean$from_station_name == "Southport Ave & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Southport Ave & Waveland Ave"] <- "60613"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Ashland Ave & Blackhawk St" |
                           d.oct.clean$from_station_name == "Ashland Ave & Chicago Ave" |
                           d.oct.clean$from_station_name == "Ashland Ave & Division St" |
                           d.oct.clean$from_station_name == "California Ave & Cortez St" |
                           d.oct.clean$from_station_name == "California Ave & Division St" |
                           d.oct.clean$from_station_name == "Claremont Ave & Hirsch St" |
                           d.oct.clean$from_station_name == "Damen Ave & Chicago Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Cortland St" |
                           d.oct.clean$from_station_name == "Damen Ave & Division St" |
                           d.oct.clean$from_station_name == "Damen Ave & Grand Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Pierce Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Thomas St (Augusta Blvd)" |
                           d.oct.clean$from_station_name == "Honore St & Division St" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Chicago Ave" |
                           d.oct.clean$from_station_name == "Leavitt St & North Ave" |
                           d.oct.clean$from_station_name == "Marshfield Ave & Cortland St" |
                           d.oct.clean$from_station_name == "Paulina Ave & North Ave" |
                           d.oct.clean$from_station_name == "Western Ave & Division St" |
                           d.oct.clean$from_station_name == "Western Ave & Walton St" |
                           d.oct.clean$from_station_name == "Wood St & Hubbard St" |
                           d.oct.clean$from_station_name == "Wood St & Milwaukee Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Augusta Blvd"] <- "60622"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Ashland Ave & Wellington Ave" |
                           d.oct.clean$from_station_name == "Broadway & Barry Ave" |
                           d.oct.clean$from_station_name == "Clark St & Wellington Ave" |
                           d.oct.clean$from_station_name == "Greenview Ave & Diversey Pkwy" |
                           d.oct.clean$from_station_name == "Halsted St & Roscoe St" |
                           d.oct.clean$from_station_name == "Lake Shore Dr & Belmont Ave" |
                           d.oct.clean$from_station_name == "Lake Shore Dr & Diversey Pkwy" |
                           d.oct.clean$from_station_name == "Lake Shore Dr & Wellington Ave" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Addison St" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Belmont Ave" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Roscoe St" |
                           d.oct.clean$from_station_name == "Racine Ave & Belmont Ave" |
                           d.oct.clean$from_station_name == "Sheffield Ave & Waveland Ave" |
                           d.oct.clean$from_station_name == "Sheffield Ave & Wellington Ave" |
                           d.oct.clean$from_station_name == "Southport Ave & Belmont Ave" |
                           d.oct.clean$from_station_name == "Southport Ave & Roscoe St" |
                           d.oct.clean$from_station_name == "Southport Ave & Wellington Ave" |
                           d.oct.clean$from_station_name == "Wilton Ave & Belmont Ave"] <- "60657"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Ashland Ave & Wrightwood Ave" |
                           d.oct.clean$from_station_name == "Bissell St & Armitage Ave" |
                           d.oct.clean$from_station_name == "Cannon Dr & Fullerton Ave" |
                           d.oct.clean$from_station_name == "Clark St & Armitage Ave" |
                           d.oct.clean$from_station_name == "Clark St & Lincoln Ave" |
                           d.oct.clean$from_station_name == "Clark St & North Ave" |
                           d.oct.clean$from_station_name == "Clark St & Wrightwood Ave" |
                           d.oct.clean$from_station_name == "Clifton Ave & Armitage Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Clybourn Ave" |
                           d.oct.clean$from_station_name == "Greenview Ave & Fullerton Ave" |
                           d.oct.clean$from_station_name == "Halsted St & Dickens Ave" |
                           d.oct.clean$from_station_name == "Halsted St & Willow St" |
                           d.oct.clean$from_station_name == "Halsted St & Wrightwood Ave" |
                           d.oct.clean$from_station_name == "Lakeview Ave & Fullerton Pkwy" |
                           d.oct.clean$from_station_name == "Larrabee St & Armitage Ave" |
                           d.oct.clean$from_station_name == "Larrabee St & Menomonee St" |
                           d.oct.clean$from_station_name == "Larrabee St & Webster Ave" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Diversey Pkwy" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Fullerton Ave" |
                           d.oct.clean$from_station_name == "Racine Ave & Fullerton Ave" |
                           d.oct.clean$from_station_name == "Racine Ave & Wrightwood Ave" |
                           d.oct.clean$from_station_name == "Sedgwick St & Webster Ave" |
                           d.oct.clean$from_station_name == "Sheffield Ave & Fullerton Ave" |
                           d.oct.clean$from_station_name == "Sheffield Ave & Webster Ave" |
                           d.oct.clean$from_station_name == "Sheffield Ave & Willow St" |
                           d.oct.clean$from_station_name == "Sheffield Ave & Wrightwood Ave" |
                           d.oct.clean$from_station_name == "Southport Ave & Clybourn Ave" |
                           d.oct.clean$from_station_name == "Southport Ave & Wrightwood Ave" |
                           d.oct.clean$from_station_name == "Stockton Dr & Wrightwood Ave" |
                           d.oct.clean$from_station_name == "Theater on the Lake" |
                           d.oct.clean$from_station_name == "Wells St & Concord Ln" |
                           d.oct.clean$from_station_name == "Wilton Ave & Diversey Pkwy" |
                           d.oct.clean$from_station_name == "Winchester Ave & Elston Ave" |
                           d.oct.clean$from_station_name == "Halsted St & Diversey Pkwy" |
                           d.oct.clean$from_station_name == "Hampden Ct & Diversey Pkwy"] <- "60614"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Austin Blvd & Chicago Ave" |
                           d.oct.clean$from_station_name == "Central Ave & Chicago Ave" |
                           d.oct.clean$from_station_name == "Spaulding Ave & Division St" |
                           d.oct.clean$from_station_name == "Troy St & North Ave"] <- "60651"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Austin Blvd & Lake St" |
                           d.oct.clean$from_station_name == "Austin Blvd & Madison St" |
                           d.oct.clean$from_station_name == "Central Ave & Harrison St" |
                           d.oct.clean$from_station_name == "Central Ave & Lake St" |
                           d.oct.clean$from_station_name == "Central Ave & Madison St" |
                           d.oct.clean$from_station_name == "Cicero Ave & Flournoy St" |
                           d.oct.clean$from_station_name == "Cicero Ave & Lake St" |
                           d.oct.clean$from_station_name == "Cicero Ave & Quincy St" |
                           d.oct.clean$from_station_name == "Laramie Ave & Gladys Ave" |
                           d.oct.clean$from_station_name == "Laramie Ave & Kinzie St" |
                           d.oct.clean$from_station_name == "Laramie Ave & Madison St"] <- "60644"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Avers Ave & Belmont Ave" |
                           d.oct.clean$from_station_name == "California Ave & Byron St" |
                           d.oct.clean$from_station_name == "California Ave & Fletcher St" |
                           d.oct.clean$from_station_name == "California Ave & Montrose Ave" |
                           d.oct.clean$from_station_name == "Central Park Ave & Elbridge Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Melrose Ave" |
                           d.oct.clean$from_station_name == "Damen Ave & Wellington Ave" |
                           d.oct.clean$from_station_name == "Drake Ave & Addison St" |
                           d.oct.clean$from_station_name == "Drake Ave & Montrose Ave" |
                           d.oct.clean$from_station_name == "Kimball Ave & Belmont Ave" |
                           d.oct.clean$from_station_name == "Leavitt St & Addison St" |
                           d.oct.clean$from_station_name == "Lincoln Ave & Belle Plaine Ave" |
                           d.oct.clean$from_station_name == "Monticello Ave & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Oakley Ave & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Oakley Ave & Roscoe St" |
                           d.oct.clean$from_station_name == "Sawyer Ave & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Seeley Ave & Roscoe St" |
                           d.oct.clean$from_station_name == "Talman Ave & Addison St" |
                           d.oct.clean$from_station_name == "Troy St & Elston Ave"] <- "60618"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Avondale Ave & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Kilbourn Ave & Irving Park Rd" |
                           d.oct.clean$from_station_name == "Kilbourn Ave & Milwaukee Ave" |
                           d.oct.clean$from_station_name == "Knox Ave & Montrose Ave" |
                           d.oct.clean$from_station_name == "Milwaukee Ave & Cuyler Ave" |
                           d.oct.clean$from_station_name == "Pulaski Rd & Eddy St"] <- "60641"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Benson Ave & Church St" |
                           d.oct.clean$from_station_name == "Central St & Girard Ave" |
                           d.oct.clean$from_station_name == "Central St Metra" |
                           d.oct.clean$from_station_name == "Chicago Ave & Dempster St" |
                           d.oct.clean$from_station_name == "Chicago Ave & Sheridan Rd" |
                           d.oct.clean$from_station_name == "Chicago Ave & Washington St" |
                           d.oct.clean$from_station_name == "Dodge Ave & Church St"] <- "60201"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Blackstone Ave & Hyde Park Blvd" |
                           d.oct.clean$from_station_name == "Calumet Ave & 51st St" |
                           d.oct.clean$from_station_name == "Cornell Ave & Hyde Park Blvd" |
                           d.oct.clean$from_station_name == "Cottage Grove Ave & 51st St" |
                           d.oct.clean$from_station_name == "Dorchester Ave & 49th St" |
                           d.oct.clean$from_station_name == "Ellis Ave & 53rd St" |
                           d.oct.clean$from_station_name == "Kimbark Ave & 53rd St" |
                           d.oct.clean$from_station_name == "Lake Park Ave & 47th St" |
                           d.oct.clean$from_station_name == "Lake Park Ave & 53rd St" |
                           d.oct.clean$from_station_name == "Shore Dr & 55th St" |
                           d.oct.clean$from_station_name == "Woodlawn Ave & 55th St"] <- "60615" 
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Bosworth Ave & Howard St" |
                           d.oct.clean$from_station_name == "Clark St & Columbia Ave" |
                           d.oct.clean$from_station_name == "Clark St & Jarvis Ave" |
                           d.oct.clean$from_station_name == "Clark St & Lunt Ave" |
                           d.oct.clean$from_station_name == "Clark St & Schreiber Ave" |
                           d.oct.clean$from_station_name == "Clark St & Touhy Ave" |
                           d.oct.clean$from_station_name == "Eastlake Ter & Rogers Ave" |
                           d.oct.clean$from_station_name == "Glenwood Ave & Morse Ave" |
                           d.oct.clean$from_station_name == "Glenwood Ave & Touhy Ave" |
                           d.oct.clean$from_station_name == "Greenview Ave & Jarvis Ave" |
                           d.oct.clean$from_station_name == "Paulina St & Howard St" |
                           d.oct.clean$from_station_name == "Sheridan Rd & Greenleaf Ave" |
                           d.oct.clean$from_station_name == "Sheridan Rd & Loyola Ave" |
                           d.oct.clean$from_station_name == "Wolcott Ave & Fargo Ave"] <- "60626"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Broadway & Argyle St" |
                           d.oct.clean$from_station_name == "Broadway & Berwyn Ave" |
                           d.oct.clean$from_station_name == "Broadway & Wilson Ave" |
                           d.oct.clean$from_station_name == "Clarendon Ave & Leland Ave" |
                           d.oct.clean$from_station_name == "Clark St & Berwyn Ave" |
                           d.oct.clean$from_station_name == "Clark St & Leland Ave" |
                           d.oct.clean$from_station_name == "Clark St & Winnemac Ave" |
                           d.oct.clean$from_station_name == "Lakefront Trail & Bryn Mawr Ave" |
                           d.oct.clean$from_station_name == "Marine Dr & Ainslie St" |
                           d.oct.clean$from_station_name == "Ravenswood Ave & Lawrence Ave" |
                           d.oct.clean$from_station_name == "Sheridan Rd & Lawrence Ave" |
                           d.oct.clean$from_station_name == "Winchester (Ravenswood) Ave & Balmoral Ave" |
                           d.oct.clean$from_station_name == "Winthrop Ave & Lawrence Ave" |
                           d.oct.clean$from_station_name == "Clifton Ave & Lawrence Ave" |
                           d.oct.clean$from_station_name == "Ravenswood Ave & Balmoral Ave"] <- "60640"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Broadway & Belmont Ave" |
                           d.oct.clean$from_station_name == "Budlong Woods Library" |
                           d.oct.clean$from_station_name == "Maplewood Ave & Peterson Ave" |
                           d.oct.clean$from_station_name == "Western Ave & Granville Ave"] <- "60659"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Broadway & Granville Ave" |
                           d.oct.clean$from_station_name == "Broadway & Ridge Ave" |
                           d.oct.clean$from_station_name == "Broadway & Thorndale Ave" |
                           d.oct.clean$from_station_name == "Clark St & Bryn Mawr Ave" |
                           d.oct.clean$from_station_name == "Clark St & Elmdale Ave"] <- "60660"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Calumet Ave & 18th St" |
                           d.oct.clean$from_station_name == "Calumet Ave & 21st St" |
                           d.oct.clean$from_station_name == "Calumet Ave & 33rd St" |
                           d.oct.clean$from_station_name == "Calumet Ave & 35th St" |
                           d.oct.clean$from_station_name == "Clinton St & 18th St" |
                           d.oct.clean$from_station_name == "Emerald Ave & 28th St" |
                           d.oct.clean$from_station_name == "Emerald Ave & 31st St" |
                           d.oct.clean$from_station_name == "Fort Dearborn Dr & 31st St" |
                           d.oct.clean$from_station_name == "Halsted St & 18th St" |
                           d.oct.clean$from_station_name == "Indiana Ave & 26th St" |
                           d.oct.clean$from_station_name == "Indiana Ave & 31st St" |
                           d.oct.clean$from_station_name == "Lake Park Ave & 35th St" |
                           d.oct.clean$from_station_name == "McCormick Place" |
                           d.oct.clean$from_station_name == "Michigan Ave & 18th St" |
                           d.oct.clean$from_station_name == "MLK Jr Dr & 29th St" |
                           d.oct.clean$from_station_name == "Normal Ave & Archer Ave" |
                           d.oct.clean$from_station_name == "Rhodes Ave & 32nd St" |
                           d.oct.clean$from_station_name == "Shields Ave & 28th Pl" |
                           d.oct.clean$from_station_name == "Shields Ave & 31st St" |
                           d.oct.clean$from_station_name == "State St & 19th St" |
                           d.oct.clean$from_station_name == "State St & 29th St" |
                           d.oct.clean$from_station_name == "State St & 33rd St" |
                           d.oct.clean$from_station_name == "State St & 35th St" |
                           d.oct.clean$from_station_name == "Wabash Ave & Cermak Rd" |
                           d.oct.clean$from_station_name == "Wells St & 19th St" |
                           d.oct.clean$from_station_name == "Wentworth Ave & 24th St" |
                           d.oct.clean$from_station_name == "Wentworth Ave & 33rd St" |
                           d.oct.clean$from_station_name == "Wentworth Ave & 35th St" |
                           d.oct.clean$from_station_name == "Wentworth Ave & Archer Ave"] <- "60616" 
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Calumet Ave & 71st St" |
                           d.oct.clean$from_station_name == "Cottage Grove Ave & 71st St" |
                           d.oct.clean$from_station_name == "Cottage Grove Ave & 78th St" |
                           d.oct.clean$from_station_name == "Cottage Grove Ave & 83rd St" |
                           d.oct.clean$from_station_name == "Eberhart (Vernon) Ave & 79th St" |
                           d.oct.clean$from_station_name == "Ellis Ave & 83rd St" |
                           d.oct.clean$from_station_name == "Evans Ave & 75th St" |
                           d.oct.clean$from_station_name == "Greenwood Ave & 79th St" |
                           d.oct.clean$from_station_name == "MLK Jr Dr & 83rd St" |
                           d.oct.clean$from_station_name == "State St & 76th St" |
                           d.oct.clean$from_station_name == "State St & 79th St" |
                           d.oct.clean$from_station_name == "Stony Island Ave & 75th St" |
                           d.oct.clean$from_station_name == "Vernon Ave & 75th St" |
                           d.oct.clean$from_station_name == "Wabash Ave & 83rd St" |
                           d.oct.clean$from_station_name == "Wabash Ave & 87th St" |
                           d.oct.clean$from_station_name == "Woodlawn Ave & 75th St"] <- "60619"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Canal St & Adams St" |
                           d.oct.clean$from_station_name == "Canal St & Jackson Blvd" |
                           d.oct.clean$from_station_name == "Canal St & Monroe St (*)" |
                           d.oct.clean$from_station_name == "Clinton St & Lake St" |
                           d.oct.clean$from_station_name == "Clinton St & Madison St" |
                           d.oct.clean$from_station_name == "Clinton St & Washington Blvd" |
                           d.oct.clean$from_station_name == "Desplaines St & Jackson Blvd" |
                           d.oct.clean$from_station_name == "Desplaines St & Kinzie St" |
                           d.oct.clean$from_station_name == "Desplaines St & Randolph St" |
                           d.oct.clean$from_station_name == "Green St & Madison St" |
                           d.oct.clean$from_station_name == "Jefferson St & Monroe St"] <- "60661"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Canal St & Madison St" |
                           d.oct.clean$from_station_name == "Franklin St & Jackson Blvd" |
                           d.oct.clean$from_station_name == "Franklin St & Lake St" |
                           d.oct.clean$from_station_name == "Franklin St & Monroe St" |
                           d.oct.clean$from_station_name == "Franklin St & Quincy St" |
                           d.oct.clean$from_station_name == "Wacker Dr & Washington St"] <- "60606"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Central Park Blvd & 5th Ave" |
                           d.oct.clean$from_station_name == "Conservatory Dr & Lake St" |
                           d.oct.clean$from_station_name == "Kedzie Ave & Roosevelt Rd" |
                           d.oct.clean$from_station_name == "Kenton Ave & Madison St" |
                           d.oct.clean$from_station_name == "Kostner Ave & Adams St" |
                           d.oct.clean$from_station_name == "Kostner Ave & Lake St" |
                           d.oct.clean$from_station_name == "Pulaski Rd & Congress Pkwy" |
                           d.oct.clean$from_station_name == "Pulaski Rd & Lake St" |
                           d.oct.clean$from_station_name == "Pulaski Rd & Madison St"] <- "60624"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Cityfront Plaza Dr & Pioneer Ct" |
                           d.oct.clean$from_station_name == "Fairbanks Ct & Grand Ave" |
                           d.oct.clean$from_station_name == "Lake Shore Dr & Ohio St" |
                           d.oct.clean$from_station_name == "McClurg Ct & Erie St" |
                           d.oct.clean$from_station_name == "McClurg Ct & Illinois St" |
                           d.oct.clean$from_station_name == "Michigan Ave & Oak St" |
                           d.oct.clean$from_station_name == "Michigan Ave & Pearson St" |
                           d.oct.clean$from_station_name == "Mies van der Rohe Way & Chestnut St" |
                           d.oct.clean$from_station_name == "Mies van der Rohe Way & Chicago Ave" |
                           d.oct.clean$from_station_name == "Rush St & Cedar St" |
                           d.oct.clean$from_station_name == "Rush St & Hubbard St" |
                           d.oct.clean$from_station_name == "Rush St & Superior St" |
                           d.oct.clean$from_station_name == "St. Clair St & Erie St" |
                           d.oct.clean$from_station_name == "Streeter Dr & Grand Ave" |
                           d.oct.clean$from_station_name == "Wabash Ave & Grand Ave"] <- "60611"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Clark St & Chicago Ave" |
                           d.oct.clean$from_station_name == "Dearborn St & Erie St" |
                           d.oct.clean$from_station_name == "Franklin St & Chicago Ave" |
                           d.oct.clean$from_station_name == "Kingsbury St & Erie St" |
                           d.oct.clean$from_station_name == "Kingsbury St & Kinzie St" |
                           d.oct.clean$from_station_name == "LaSalle Dr & Huron St(*)" |
                           d.oct.clean$from_station_name == "LaSalle St & Illinois St" |
                           d.oct.clean$from_station_name == "Milwaukee Ave & Grand Ave" |
                           d.oct.clean$from_station_name == "Orleans St & Merchandise Mart Plaza" |
                           d.oct.clean$from_station_name == "Orleans St & Ohio St" |
                           d.oct.clean$from_station_name == "Sedgwick St & Huron St" |
                           d.oct.clean$from_station_name == "State St & Kinzie St" |
                           d.oct.clean$from_station_name == "Wells St & Huron St" |
                           d.oct.clean$from_station_name == "LaSalle (Wells) St & Huron St"] <- "60654"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Clark St & Elm St" |
                           d.oct.clean$from_station_name == "Clark St & Schiller St" |
                           d.oct.clean$from_station_name == "Clybourn Ave & Division St" |
                           d.oct.clean$from_station_name == "Dearborn Pkwy & Delaware Pl" |
                           d.oct.clean$from_station_name == "Lake Shore Dr & North Blvd" |
                           d.oct.clean$from_station_name == "Larrabee St & Division St" |
                           d.oct.clean$from_station_name == "Larrabee St & Kingsbury St" |
                           d.oct.clean$from_station_name == "Larrabee St & North Ave" |
                           d.oct.clean$from_station_name == "Larrabee St & Oak St" |
                           d.oct.clean$from_station_name == "Orleans St & Chestnut St (NEXT Apts)" |
                           d.oct.clean$from_station_name == "Orleans St & Elm St (*)" |
                           d.oct.clean$from_station_name == "Ritchie Ct & Banks St" |
                           d.oct.clean$from_station_name == "Sedgwick St & North Ave" |
                           d.oct.clean$from_station_name == "Sedgwick St & Schiller St" |
                           d.oct.clean$from_station_name == "State St & Pearson St" |
                           d.oct.clean$from_station_name == "Wells St & Elm St" |
                           d.oct.clean$from_station_name == "Wells St & Evergreen Ave" |
                           d.oct.clean$from_station_name == "Wells St & Walton St"] <- "60610"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Clark St & Lake St" |
                           d.oct.clean$from_station_name == "Clark St & Randolph St" |
                           d.oct.clean$from_station_name == "Columbus Dr & Randolph St" |
                           d.oct.clean$from_station_name == "Daley Center Plaza" |
                           d.oct.clean$from_station_name == "Dusable Harbor" |
                           d.oct.clean$from_station_name == "Field Blvd & South Water St" |
                           d.oct.clean$from_station_name == "Michigan Ave & Lake St" |
                           d.oct.clean$from_station_name == "Millennium Park" |
                           d.oct.clean$from_station_name == "State St & Randolph St" |
                           d.oct.clean$from_station_name == "Stetson Ave & South Water St" |
                           d.oct.clean$from_station_name == "Wabash Ave & Wacker Pl"] <- "60601"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Cottage Grove Ave & 43rd St" |
                           d.oct.clean$from_station_name == "Cottage Grove Ave & 47th St" |
                           d.oct.clean$from_station_name == "Cottage Grove Ave & Oakwood Blvd" |
                           d.oct.clean$from_station_name == "Greenwood Ave & 47th St" |
                           d.oct.clean$from_station_name == "Indiana Ave & 40th St" |
                           d.oct.clean$from_station_name == "MLK Jr Dr & 47th St" |
                           d.oct.clean$from_station_name == "MLK Jr Dr & Pershing Rd" |
                           d.oct.clean$from_station_name == "Prairie Ave & 43rd St" |
                           d.oct.clean$from_station_name == "Woodlawn Ave & Lake Park Ave"] <- "60653"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Cottage Grove Ave & 63rd St" |
                           d.oct.clean$from_station_name == "Cottage Grove Ave & 67th St" |
                           d.oct.clean$from_station_name == "Dorchester Ave & 63rd St" |
                           d.oct.clean$from_station_name == "DuSable Museum" |
                           d.oct.clean$from_station_name == "Eberhart Ave & 61st St" |
                           d.oct.clean$from_station_name == "Ellis Ave & 55th St" |
                           d.oct.clean$from_station_name == "Ellis Ave & 58th St" |
                           d.oct.clean$from_station_name == "Ellis Ave & 60th St" |
                           d.oct.clean$from_station_name == "Harper Ave & 59th St" |
                           d.oct.clean$from_station_name == "Lake Park Ave & 56th St" |
                           d.oct.clean$from_station_name == "MLK Jr Dr & 56th St (*)" |
                           d.oct.clean$from_station_name == "MLK Jr Dr & 63rd St" |
                           d.oct.clean$from_station_name == "Museum of Science and Industry" |
                           d.oct.clean$from_station_name == "Prairie Ave & Garfield Blvd" |
                           d.oct.clean$from_station_name == "Stony Island Ave & 64th St" |
                           d.oct.clean$from_station_name == "University Ave & 57th St"] <- "60637"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Dearborn St & Adams St" |
                           d.oct.clean$from_station_name == "Dearborn St & Monroe St" |
                           d.oct.clean$from_station_name == "Lake Shore Dr & Monroe St" |
                           d.oct.clean$from_station_name == "LaSalle St & Adams St" |
                           d.oct.clean$from_station_name == "Wabash Ave & Adams St"] <- "60603"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Elmwood Ave & Austin St" |
                           d.oct.clean$from_station_name == "Valli Produce - Evanston Plaza"] <- "60202"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Exchange Ave & 79th St" |
                           d.oct.clean$from_station_name == "South Chicago Ave & 83rd St" |
                           d.oct.clean$from_station_name == "Stony Island Ave & 82nd St" |
                           d.oct.clean$from_station_name == "Stony Island Ave & South Chicago Ave"] <- "60617"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Halsted St & 56th St" |
                           d.oct.clean$from_station_name == "Halsted St & 59th St" |
                           d.oct.clean$from_station_name == "Halsted St & 63rd St" |
                           d.oct.clean$from_station_name == "Halsted St & 69th St" |
                           d.oct.clean$from_station_name == "May St & 69th St" |
                           d.oct.clean$from_station_name == "Normal Ave & 72nd St" |
                           d.oct.clean$from_station_name == "Perry Ave & 69th St" |
                           d.oct.clean$from_station_name == "Racine Ave & 61st St" |
                           d.oct.clean$from_station_name == "Wentworth Ave & 63rd St"] <- "60621"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Keystone Ave & Fullerton Ave"] <- "60639"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "MLK Jr Dr & Oakwood Blvd"] <- "60620"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Keystone Ave & Montrose Ave"] <- "60630"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "LaSalle St & Jackson Blvd" |
                           d.oct.clean$from_station_name == "Michigan Ave & Jackson Blvd" |
                           d.oct.clean$from_station_name == "State St & Van Buren St"] <- "60604"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "LaSalle St & Washington St" |
                           d.oct.clean$from_station_name == "Michigan Ave & Madison St" |
                           d.oct.clean$from_station_name == "Michigan Ave & Washington St"] <- "60602"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Oakley Ave & Touhy Ave" |
                           d.oct.clean$from_station_name == "Ridge Blvd & Howard St" |
                           d.oct.clean$from_station_name == "Ridge Blvd & Touhy Ave" |
                           d.oct.clean$from_station_name == "Warren Park East" |
                           d.oct.clean$from_station_name == "Warren Park West" |
                           d.oct.clean$from_station_name == "Western Ave & Howard St" |
                           d.oct.clean$from_station_name == "Western Ave & Lunt Ave"] <- "60645"
d.oct.clean$from_zipcode[d.oct.clean$from_station_name == "Sheridan Rd & Noyes St (NU)" |
                           d.oct.clean$from_station_name == "University Library (NU)"] <- "60208"
detach(d.oct.clean)


# Creating a new variable to_zipcode to group the station names together
attach(d.oct.clean)
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "2112 W Peterson Ave"] <- "60659"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "63rd St Beach" |
                         d.oct.clean$to_station_name == "Bennett Ave & 79th St" |
                         d.oct.clean$to_station_name == "Jeffery Blvd & 67th St" |
                         d.oct.clean$to_station_name == "Jeffery Blvd & 71st St" |
                         d.oct.clean$to_station_name == "Jeffery Blvd & 76th St" |
                         d.oct.clean$to_station_name == "Phillips Ave & 79th St" |
                         d.oct.clean$to_station_name == "Rainbow Beach" |
                         d.oct.clean$to_station_name == "Saginaw Ave & Exchange Ave" |
                         d.oct.clean$to_station_name == "South Shore Dr & 67th St" |
                         d.oct.clean$to_station_name == "South Shore Dr & 71st St" |
                         d.oct.clean$to_station_name == "South Shore Dr & 74th St" |
                         d.oct.clean$to_station_name == "Stony Island Ave & 67th St" |
                         d.oct.clean$to_station_name == "Stony Island Ave & 71st St" |
                         d.oct.clean$to_station_name == "Yates Blvd & 75th St"] <- "60649"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "900 W Harrison St" | 
                         d.oct.clean$to_station_name == "Aberdeen St & Jackson Blvd" |
                         d.oct.clean$to_station_name =="Aberdeen St & Monroe St" | 
                         d.oct.clean$to_station_name == "Ada St & Washington Blvd" |
                         d.oct.clean$to_station_name == "Canal St & Harrison St" |
                         d.oct.clean$to_station_name == "Canal St & Taylor St" |
                         d.oct.clean$to_station_name == "Clinton St & Polk St (*)" |
                         d.oct.clean$to_station_name == "Clinton St & Roosevelt Rd" |
                         d.oct.clean$to_station_name == "Clinton St & Tilden St" |
                         d.oct.clean$to_station_name == "Green St & Randolph St" |
                         d.oct.clean$to_station_name == "Halsted St & Maxwell St" |
                         d.oct.clean$to_station_name == "Halsted St & Polk St" |
                         d.oct.clean$to_station_name == "Loomis St & Jackson Blvd" |
                         d.oct.clean$to_station_name == "Loomis St & Lexington St" |
                         d.oct.clean$to_station_name == "Loomis St & Taylor St (*)" |
                         d.oct.clean$to_station_name == "May St & Taylor St" |
                         d.oct.clean$to_station_name == "Morgan St & Lake St" |
                         d.oct.clean$to_station_name == "Morgan St & Polk St" |
                         d.oct.clean$to_station_name == "Peoria St & Jackson Blvd" |
                         d.oct.clean$to_station_name == "Racine Ave (May St) & Fulton St" |
                         d.oct.clean$to_station_name == "Racine Ave & Congress Pkwy" |
                         d.oct.clean$to_station_name == "Racine Ave & Randolph St" |
                         d.oct.clean$to_station_name == "Sangamon St & Washington Blvd (*)" |
                         d.oct.clean$to_station_name == "Stave St & Armitage Ave" |
                         d.oct.clean$to_station_name == "Wells St & Polk St"] <- "60607"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Adler Planetarium" |
                         d.oct.clean$to_station_name == "Buckingham Fountain" |
                         d.oct.clean$to_station_name == "Burnham Harbor" |
                         d.oct.clean$to_station_name == "Clark St & 9th St (AMLI)" |
                         d.oct.clean$to_station_name == "Clark St & Congress Pkwy" |
                         d.oct.clean$to_station_name == "Dearborn St & Van Buren St (*)" |
                         d.oct.clean$to_station_name == "Delano Ct & Roosevelt Rd" |
                         d.oct.clean$to_station_name == "Federal St & Polk St" |
                         d.oct.clean$to_station_name == "Field Museum" |
                         d.oct.clean$to_station_name == "Financial Pl & Congress Pkwy" |
                         d.oct.clean$to_station_name == "Indiana Ave & Roosevelt Rd" |
                         d.oct.clean$to_station_name == "Michigan Ave & 14th St" |
                         d.oct.clean$to_station_name == "Michigan Ave & 8th St" |
                         d.oct.clean$to_station_name == "Michigan Ave & Congress Pkwy" |
                         d.oct.clean$to_station_name == "Shedd Aquarium" |
                         d.oct.clean$to_station_name == "State St & Harrison St" |
                         d.oct.clean$to_station_name == "Wabash Ave & 16th St" |
                         d.oct.clean$to_station_name == "Wabash Ave & 9th St" |
                         d.oct.clean$to_station_name == "Wabash Ave & Roosevelt Rd"] <- "60605"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Albany Ave & 26th St" |
                         d.oct.clean$to_station_name == "Central Park Ave & Ogden Ave" |
                         d.oct.clean$to_station_name == "Kedzie Ave & 21st St" |
                         d.oct.clean$to_station_name == "Kedzie Ave & 24th St" |
                         d.oct.clean$to_station_name == "Lawndale Ave & 23rd St" |
                         d.oct.clean$to_station_name == "Millard Ave & 26th St" |
                         d.oct.clean$to_station_name == "California Ave & 26th St"] <- "60623"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Albany Ave & Bloomingdale Ave" |
                         d.oct.clean$to_station_name == "California Ave & Altgeld St" |
                         d.oct.clean$to_station_name == "California Ave & Francis Pl" |
                         d.oct.clean$to_station_name == "California Ave & Milwaukee Ave" |
                         d.oct.clean$to_station_name == "California Ave & North Ave" |
                         d.oct.clean$to_station_name == "Campbell Ave & Fullerton Ave" |
                         d.oct.clean$to_station_name == "Campbell Ave & North Ave" |
                         d.oct.clean$to_station_name == "Central Park Ave & North Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Charleston St" |
                         d.oct.clean$to_station_name == "Drake Ave & Fullerton Ave" |
                         d.oct.clean$to_station_name == "Humboldt Blvd & Armitage Ave" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Milwaukee Ave" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Palmer Ct" |
                         d.oct.clean$to_station_name == "Kosciuszko Park" |
                         d.oct.clean$to_station_name == "Leavitt St & Armitage Ave" |
                         d.oct.clean$to_station_name == "Logan Blvd & Elston Ave" |
                         d.oct.clean$to_station_name == "Milwaukee Ave & Rockwell St" |
                         d.oct.clean$to_station_name == "Milwaukee Ave & Wabansia Ave" |
                         d.oct.clean$to_station_name == "Richmond St & Diversey Ave" |
                         d.oct.clean$to_station_name == "Spaulding Ave & Armitage Ave" |
                         d.oct.clean$to_station_name == "Western Ave & Winnebago Ave"] <- "60647"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Albany Ave & Montrose Ave" |
                         d.oct.clean$to_station_name == "Campbell Ave & Montrose Ave" |
                         d.oct.clean$to_station_name == "Christiana Ave & Lawrence Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Foster Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Leland Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Sunnyside Ave" |
                         d.oct.clean$to_station_name == "Francisco Ave & Foster Ave" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Bryn Mawr Ave" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Foster Ave" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Leland Ave" |
                         d.oct.clean$to_station_name == "Leavitt St & Lawrence Ave" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Leavitt St" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Winona St" |
                         d.oct.clean$to_station_name == "Manor Ave & Leland Ave" |
                         d.oct.clean$to_station_name == "Rockwell St & Eastwood Ave" |
                         d.oct.clean$to_station_name == "St. Louis Ave & Balmoral Ave" |
                         d.oct.clean$to_station_name == "Washtenaw Ave & Lawrence Ave" |
                         d.oct.clean$to_station_name == "Western Ave & Leland Ave"] <- "60625"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Artesian Ave & Hubbard St" |
                         d.oct.clean$to_station_name == "Ashland Ave & Harrison St" |
                         d.oct.clean$to_station_name == "Ashland Ave & Lake St" |
                         d.oct.clean$to_station_name == "California Ave & Lake St" |
                         d.oct.clean$to_station_name == "Damen Ave & Madison St" |
                         d.oct.clean$to_station_name == "Hermitage Ave & Polk St" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Harrison St" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Lake St" |
                         d.oct.clean$to_station_name == "Ogden Ave & Congress Pkwy" |
                         d.oct.clean$to_station_name == "Sacramento Blvd & Franklin Blvd" |
                         d.oct.clean$to_station_name == "Western Ave & Congress Pkwy" |
                         d.oct.clean$to_station_name == "Western Ave & Monroe St" |
                         d.oct.clean$to_station_name == "Wolcott Ave & Polk St" |
                         d.oct.clean$to_station_name == "Wood St & Taylor St"] <- "60612"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Ashland Ave & 13th St" | 
                         d.oct.clean$to_station_name == "Ashland Ave & 21st St" |
                         d.oct.clean$to_station_name == "Ashland Ave & Archer Ave" |
                         d.oct.clean$to_station_name == "Blue Island Ave & 18th St" |
                         d.oct.clean$to_station_name == "Damen Ave & Coulter St" |
                         d.oct.clean$to_station_name == "Damen Ave & Cullerton St" |
                         d.oct.clean$to_station_name == "Fairfield Ave & Roosevelt Rd" |
                         d.oct.clean$to_station_name == "Halsted St & 21st St" |
                         d.oct.clean$to_station_name == "Halsted St & Archer Ave" |
                         d.oct.clean$to_station_name == "Halsted St & Roosevelt Rd" |
                         d.oct.clean$to_station_name == "Loomis St & Archer Ave" |
                         d.oct.clean$to_station_name == "May St & Cullerton St" |
                         d.oct.clean$to_station_name == "Morgan Ave & 14th Pl" |
                         d.oct.clean$to_station_name == "Morgan St & 18th St" |
                         d.oct.clean$to_station_name == "Morgan St & 31st St" |
                         d.oct.clean$to_station_name == "Ogden Ave & Roosevelt Rd" |
                         d.oct.clean$to_station_name == "Paulina St & 18th St" |
                         d.oct.clean$to_station_name == "Racine Ave & 13th St" |
                         d.oct.clean$to_station_name == "Racine Ave & 15th St" |
                         d.oct.clean$to_station_name == "Racine Ave & 18th St" |
                         d.oct.clean$to_station_name == "Washtenaw Ave & Ogden Ave (*)" |
                         d.oct.clean$to_station_name == "Western Ave & 21st St" |
                         d.oct.clean$to_station_name == "Western Ave & 24th St" |
                         d.oct.clean$to_station_name == "Western Ave & 28th St" |
                         d.oct.clean$to_station_name == "California Ave & 21st St" |
                         d.oct.clean$to_station_name == "California Ave & 23rd Pl"] <- "60608"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Ashland Ave & 50th St" |
                         d.oct.clean$to_station_name == "Ashland Ave & McDowell Ave" |
                         d.oct.clean$to_station_name == "Ashland Ave & Pershing Rd" |
                         d.oct.clean$to_station_name == "Damen Ave & 51st St" |
                         d.oct.clean$to_station_name == "Damen Ave & Pershing Rd" |
                         d.oct.clean$to_station_name == "Elizabeth St & 47th St" |
                         d.oct.clean$to_station_name == "Halsted St & 35th St (*)" |
                         d.oct.clean$to_station_name == "Halsted St & 37th St" |
                         d.oct.clean$to_station_name == "Halsted St & 47th Pl" |
                         d.oct.clean$to_station_name == "Halsted St & 51st St" |
                         d.oct.clean$to_station_name == "Hoyne Ave & 47th St" |
                         d.oct.clean$to_station_name == "Leavitt St & Archer Ave" |
                         d.oct.clean$to_station_name == "Marshfield Ave & 44th St" |
                         d.oct.clean$to_station_name == "Morgan St & Pershing Rd" |
                         d.oct.clean$to_station_name == "Princeton Ave & 47th St" |
                         d.oct.clean$to_station_name == "Princeton Ave & Garfield Blvd" |
                         d.oct.clean$to_station_name == "Racine Ave & 35th St" |
                         d.oct.clean$to_station_name == "Racine Ave & Garfield Blvd" |
                         d.oct.clean$to_station_name == "Seeley Ave & Garfield Blvd" |
                         d.oct.clean$to_station_name == "Shields Ave & 43rd St" |
                         d.oct.clean$to_station_name == "State St & Pershing Rd" |
                         d.oct.clean$to_station_name == "Throop St & 52nd St" |
                         d.oct.clean$to_station_name == "Union Ave & Root St" |
                         d.oct.clean$to_station_name == "Wallace St & 35th St" |
                         d.oct.clean$to_station_name == "Western Blvd & 48th Pl" |
                         d.oct.clean$to_station_name == "Wood St & 35th St"] <- "60609"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Ashland Ave & 63rd St" |
                         d.oct.clean$to_station_name == "Ashland Ave & 69th St" |
                         d.oct.clean$to_station_name == "Ashland Ave & Garfield Blvd" |
                         d.oct.clean$to_station_name == "Damen Ave & 59th St" |
                         d.oct.clean$to_station_name == "Marshfield Ave & 59th St" |
                         d.oct.clean$to_station_name == "Racine Ave & 65th St"] <- "60636"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Ashland Ave & Augusta Blvd" |
                         d.oct.clean$to_station_name == "Ashland Ave & Grand Ave" |
                         d.oct.clean$to_station_name == "Carpenter St & Huron St" |
                         d.oct.clean$to_station_name == "Dayton St & North Ave" |
                         d.oct.clean$to_station_name == "Eckhart Park" |
                         d.oct.clean$to_station_name == "Elston Ave & Wabansia Ave" |
                         d.oct.clean$to_station_name == "Halsted St & Blackhawk St (*)" |
                         d.oct.clean$to_station_name == "Halsted St & North Branch St" |
                         d.oct.clean$to_station_name == "Noble St & Milwaukee Ave" |
                         d.oct.clean$to_station_name == "Ogden Ave & Chicago Ave" |
                         d.oct.clean$to_station_name == "Ogden Ave & Race Ave" |
                         d.oct.clean$to_station_name == "Sheffield Ave & Kingsbury St"] <- "60642"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Ashland Ave & Belle Plaine Ave" |
                         d.oct.clean$to_station_name == "Ashland Ave & Grace St" |
                         d.oct.clean$to_station_name == "Broadway & Cornelia Ave" |
                         d.oct.clean$to_station_name == "Broadway & Sheridan Rd" |
                         d.oct.clean$to_station_name == "Broadway & Waveland Ave" |
                         d.oct.clean$to_station_name == "Clarendon Ave & Gordon Ter" |
                         d.oct.clean$to_station_name == "Clarendon Ave & Junior Ter" |
                         d.oct.clean$to_station_name == "Clark St & Grace St" |
                         d.oct.clean$to_station_name == "Clark St & Montrose Ave" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Waveland Ave" |
                         d.oct.clean$to_station_name == "Montrose Harbor" |
                         d.oct.clean$to_station_name == "Paulina St & Montrose Ave" |
                         d.oct.clean$to_station_name == "Pine Grove Ave & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Pine Grove Ave & Waveland Ave" |
                         d.oct.clean$to_station_name == "Ravenswood Ave & Berteau Ave" |
                         d.oct.clean$to_station_name == "Ravenswood Ave & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Ravenswood Ave & Montrose Ave (*)" |
                         d.oct.clean$to_station_name == "Sheridan Rd & Buena Ave" |
                         d.oct.clean$to_station_name == "Sheridan Rd & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Sheridan Rd & Montrose Ave" |
                         d.oct.clean$to_station_name == "Southport Ave & Clark St" |
                         d.oct.clean$to_station_name == "Southport Ave & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Southport Ave & Waveland Ave"] <- "60613"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Ashland Ave & Blackhawk St" |
                         d.oct.clean$to_station_name == "Ashland Ave & Chicago Ave" |
                         d.oct.clean$to_station_name == "Ashland Ave & Division St" |
                         d.oct.clean$to_station_name == "California Ave & Cortez St" |
                         d.oct.clean$to_station_name == "California Ave & Division St" |
                         d.oct.clean$to_station_name == "Claremont Ave & Hirsch St" |
                         d.oct.clean$to_station_name == "Damen Ave & Chicago Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Cortland St" |
                         d.oct.clean$to_station_name == "Damen Ave & Division St" |
                         d.oct.clean$to_station_name == "Damen Ave & Grand Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Pierce Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Thomas St (Augusta Blvd)" |
                         d.oct.clean$to_station_name == "Honore St & Division St" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Chicago Ave" |
                         d.oct.clean$to_station_name == "Leavitt St & North Ave" |
                         d.oct.clean$to_station_name == "Marshfield Ave & Cortland St" |
                         d.oct.clean$to_station_name == "Paulina Ave & North Ave" |
                         d.oct.clean$to_station_name == "Western Ave & Division St" |
                         d.oct.clean$to_station_name == "Western Ave & Walton St" |
                         d.oct.clean$to_station_name == "Wood St & Hubbard St" |
                         d.oct.clean$to_station_name == "Wood St & Milwaukee Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Augusta Blvd"] <- "60622"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Ashland Ave & Wellington Ave" |
                         d.oct.clean$to_station_name == "Broadway & Barry Ave" |
                         d.oct.clean$to_station_name == "Clark St & Wellington Ave" |
                         d.oct.clean$to_station_name == "Greenview Ave & Diversey Pkwy" |
                         d.oct.clean$to_station_name == "Halsted St & Roscoe St" |
                         d.oct.clean$to_station_name == "Lake Shore Dr & Belmont Ave" |
                         d.oct.clean$to_station_name == "Lake Shore Dr & Diversey Pkwy" |
                         d.oct.clean$to_station_name == "Lake Shore Dr & Wellington Ave" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Addison St" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Belmont Ave" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Roscoe St" |
                         d.oct.clean$to_station_name == "Racine Ave & Belmont Ave" |
                         d.oct.clean$to_station_name == "Sheffield Ave & Waveland Ave" |
                         d.oct.clean$to_station_name == "Sheffield Ave & Wellington Ave" |
                         d.oct.clean$to_station_name == "Southport Ave & Belmont Ave" |
                         d.oct.clean$to_station_name == "Southport Ave & Roscoe St" |
                         d.oct.clean$to_station_name == "Southport Ave & Wellington Ave" |
                         d.oct.clean$to_station_name == "Wilton Ave & Belmont Ave"] <- "60657"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Ashland Ave & Wrightwood Ave" |
                         d.oct.clean$to_station_name == "Bissell St & Armitage Ave" |
                         d.oct.clean$to_station_name == "Cannon Dr & Fullerton Ave" |
                         d.oct.clean$to_station_name == "Clark St & Armitage Ave" |
                         d.oct.clean$to_station_name == "Clark St & Lincoln Ave" |
                         d.oct.clean$to_station_name == "Clark St & North Ave" |
                         d.oct.clean$to_station_name == "Clark St & Wrightwood Ave" |
                         d.oct.clean$to_station_name == "Clifton Ave & Armitage Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Clybourn Ave" |
                         d.oct.clean$to_station_name == "Greenview Ave & Fullerton Ave" |
                         d.oct.clean$to_station_name == "Halsted St & Dickens Ave" |
                         d.oct.clean$to_station_name == "Halsted St & Willow St" |
                         d.oct.clean$to_station_name == "Halsted St & Wrightwood Ave" |
                         d.oct.clean$to_station_name == "Lakeview Ave & Fullerton Pkwy" |
                         d.oct.clean$to_station_name == "Larrabee St & Armitage Ave" |
                         d.oct.clean$to_station_name == "Larrabee St & Menomonee St" |
                         d.oct.clean$to_station_name == "Larrabee St & Webster Ave" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Diversey Pkwy" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Fullerton Ave" |
                         d.oct.clean$to_station_name == "Racine Ave & Fullerton Ave" |
                         d.oct.clean$to_station_name == "Racine Ave & Wrightwood Ave" |
                         d.oct.clean$to_station_name == "Sedgwick St & Webster Ave" |
                         d.oct.clean$to_station_name == "Sheffield Ave & Fullerton Ave" |
                         d.oct.clean$to_station_name == "Sheffield Ave & Webster Ave" |
                         d.oct.clean$to_station_name == "Sheffield Ave & Willow St" |
                         d.oct.clean$to_station_name == "Sheffield Ave & Wrightwood Ave" |
                         d.oct.clean$to_station_name == "Southport Ave & Clybourn Ave" |
                         d.oct.clean$to_station_name == "Southport Ave & Wrightwood Ave" |
                         d.oct.clean$to_station_name == "Stockton Dr & Wrightwood Ave" |
                         d.oct.clean$to_station_name == "Theater on the Lake" |
                         d.oct.clean$to_station_name == "Wells St & Concord Ln" |
                         d.oct.clean$to_station_name == "Wilton Ave & Diversey Pkwy" |
                         d.oct.clean$to_station_name == "Winchester Ave & Elston Ave" |
                         d.oct.clean$to_station_name == "Halsted St & Diversey Pkwy" |
                         d.oct.clean$to_station_name == "Hampden Ct & Diversey Pkwy"] <- "60614"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Austin Blvd & Chicago Ave" |
                         d.oct.clean$to_station_name == "Central Ave & Chicago Ave" |
                         d.oct.clean$to_station_name == "Spaulding Ave & Division St" |
                         d.oct.clean$to_station_name == "Troy St & North Ave"] <- "60651"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Austin Blvd & Lake St" |
                         d.oct.clean$to_station_name == "Austin Blvd & Madison St" |
                         d.oct.clean$to_station_name == "Central Ave & Harrison St" |
                         d.oct.clean$to_station_name == "Central Ave & Lake St" |
                         d.oct.clean$to_station_name == "Central Ave & Madison St" |
                         d.oct.clean$to_station_name == "Cicero Ave & Flournoy St" |
                         d.oct.clean$to_station_name == "Cicero Ave & Lake St" |
                         d.oct.clean$to_station_name == "Cicero Ave & Quincy St" |
                         d.oct.clean$to_station_name == "Laramie Ave & Gladys Ave" |
                         d.oct.clean$to_station_name == "Laramie Ave & Kinzie St" |
                         d.oct.clean$to_station_name == "Laramie Ave & Madison St"] <- "60644"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Avers Ave & Belmont Ave" |
                         d.oct.clean$to_station_name == "California Ave & Byron St" |
                         d.oct.clean$to_station_name == "California Ave & Fletcher St" |
                         d.oct.clean$to_station_name == "California Ave & Montrose Ave" |
                         d.oct.clean$to_station_name == "Central Park Ave & Elbridge Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Melrose Ave" |
                         d.oct.clean$to_station_name == "Damen Ave & Wellington Ave" |
                         d.oct.clean$to_station_name == "Drake Ave & Addison St" |
                         d.oct.clean$to_station_name == "Drake Ave & Montrose Ave" |
                         d.oct.clean$to_station_name == "Kimball Ave & Belmont Ave" |
                         d.oct.clean$to_station_name == "Leavitt St & Addison St" |
                         d.oct.clean$to_station_name == "Lincoln Ave & Belle Plaine Ave" |
                         d.oct.clean$to_station_name == "Monticello Ave & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Oakley Ave & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Oakley Ave & Roscoe St" |
                         d.oct.clean$to_station_name == "Sawyer Ave & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Seeley Ave & Roscoe St" |
                         d.oct.clean$to_station_name == "Talman Ave & Addison St" |
                         d.oct.clean$to_station_name == "Troy St & Elston Ave"] <- "60618"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Avondale Ave & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Kilbourn Ave & Irving Park Rd" |
                         d.oct.clean$to_station_name == "Kilbourn Ave & Milwaukee Ave" |
                         d.oct.clean$to_station_name == "Knox Ave & Montrose Ave" |
                         d.oct.clean$to_station_name == "Milwaukee Ave & Cuyler Ave" |
                         d.oct.clean$to_station_name == "Pulaski Rd & Eddy St"] <- "60641"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Benson Ave & Church St" |
                         d.oct.clean$to_station_name == "Central St & Girard Ave" |
                         d.oct.clean$to_station_name == "Central St Metra" |
                         d.oct.clean$to_station_name == "Chicago Ave & Dempster St" |
                         d.oct.clean$to_station_name == "Chicago Ave & Sheridan Rd" |
                         d.oct.clean$to_station_name == "Chicago Ave & Washington St" |
                         d.oct.clean$to_station_name == "Dodge Ave & Church St"] <- "60201"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Blackstone Ave & Hyde Park Blvd" |
                         d.oct.clean$to_station_name == "Calumet Ave & 51st St" |
                         d.oct.clean$to_station_name == "Cornell Ave & Hyde Park Blvd" |
                         d.oct.clean$to_station_name == "Cottage Grove Ave & 51st St" |
                         d.oct.clean$to_station_name == "Dorchester Ave & 49th St" |
                         d.oct.clean$to_station_name == "Ellis Ave & 53rd St" |
                         d.oct.clean$to_station_name == "Kimbark Ave & 53rd St" |
                         d.oct.clean$to_station_name == "Lake Park Ave & 47th St" |
                         d.oct.clean$to_station_name == "Lake Park Ave & 53rd St" |
                         d.oct.clean$to_station_name == "Shore Dr & 55th St" |
                         d.oct.clean$to_station_name == "Woodlawn Ave & 55th St"] <- "60615" 
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Bosworth Ave & Howard St" |
                         d.oct.clean$to_station_name == "Clark St & Columbia Ave" |
                         d.oct.clean$to_station_name == "Clark St & Jarvis Ave" |
                         d.oct.clean$to_station_name == "Clark St & Lunt Ave" |
                         d.oct.clean$to_station_name == "Clark St & Schreiber Ave" |
                         d.oct.clean$to_station_name == "Clark St & Touhy Ave" |
                         d.oct.clean$to_station_name == "Eastlake Ter & Rogers Ave" |
                         d.oct.clean$to_station_name == "Glenwood Ave & Morse Ave" |
                         d.oct.clean$to_station_name == "Glenwood Ave & Touhy Ave" |
                         d.oct.clean$to_station_name == "Greenview Ave & Jarvis Ave" |
                         d.oct.clean$to_station_name == "Paulina St & Howard St" |
                         d.oct.clean$to_station_name == "Sheridan Rd & Greenleaf Ave" |
                         d.oct.clean$to_station_name == "Sheridan Rd & Loyola Ave" |
                         d.oct.clean$to_station_name == "Wolcott Ave & Fargo Ave"] <- "60626"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Broadway & Argyle St" |
                         d.oct.clean$to_station_name == "Broadway & Berwyn Ave" |
                         d.oct.clean$to_station_name == "Broadway & Wilson Ave" |
                         d.oct.clean$to_station_name == "Clarendon Ave & Leland Ave" |
                         d.oct.clean$to_station_name == "Clark St & Berwyn Ave" |
                         d.oct.clean$to_station_name == "Clark St & Leland Ave" |
                         d.oct.clean$to_station_name == "Clark St & Winnemac Ave" |
                         d.oct.clean$to_station_name == "Lakefront Trail & Bryn Mawr Ave" |
                         d.oct.clean$to_station_name == "Marine Dr & Ainslie St" |
                         d.oct.clean$to_station_name == "Ravenswood Ave & Lawrence Ave" |
                         d.oct.clean$to_station_name == "Sheridan Rd & Lawrence Ave" |
                         d.oct.clean$to_station_name == "Winchester (Ravenswood) Ave & Balmoral Ave" |
                         d.oct.clean$to_station_name == "Winthrop Ave & Lawrence Ave" |
                         d.oct.clean$to_station_name == "Clifton Ave & Lawrence Ave" |
                         d.oct.clean$to_station_name == "Ravenswood Ave & Balmoral Ave"] <- "60640"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Broadway & Belmont Ave" |
                         d.oct.clean$to_station_name == "Budlong Woods Library" |
                         d.oct.clean$to_station_name == "Maplewood Ave & Peterson Ave" |
                         d.oct.clean$to_station_name == "Western Ave & Granville Ave"] <- "60659"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Broadway & Granville Ave" |
                         d.oct.clean$to_station_name == "Broadway & Ridge Ave" |
                         d.oct.clean$to_station_name == "Broadway & Thorndale Ave" |
                         d.oct.clean$to_station_name == "Clark St & Bryn Mawr Ave" |
                         d.oct.clean$to_station_name == "Clark St & Elmdale Ave"] <- "60660"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Calumet Ave & 18th St" |
                         d.oct.clean$to_station_name == "Calumet Ave & 21st St" |
                         d.oct.clean$to_station_name == "Calumet Ave & 33rd St" |
                         d.oct.clean$to_station_name == "Calumet Ave & 35th St" |
                         d.oct.clean$to_station_name == "Clinton St & 18th St" |
                         d.oct.clean$to_station_name == "Emerald Ave & 28th St" |
                         d.oct.clean$to_station_name == "Emerald Ave & 31st St" |
                         d.oct.clean$to_station_name == "Fort Dearborn Dr & 31st St" |
                         d.oct.clean$to_station_name == "Halsted St & 18th St" |
                         d.oct.clean$to_station_name == "Indiana Ave & 26th St" |
                         d.oct.clean$to_station_name == "Indiana Ave & 31st St" |
                         d.oct.clean$to_station_name == "Lake Park Ave & 35th St" |
                         d.oct.clean$to_station_name == "McCormick Place" |
                         d.oct.clean$to_station_name == "Michigan Ave & 18th St" |
                         d.oct.clean$to_station_name == "MLK Jr Dr & 29th St" |
                         d.oct.clean$to_station_name == "Normal Ave & Archer Ave" |
                         d.oct.clean$to_station_name == "Rhodes Ave & 32nd St" |
                         d.oct.clean$to_station_name == "Shields Ave & 28th Pl" |
                         d.oct.clean$to_station_name == "Shields Ave & 31st St" |
                         d.oct.clean$to_station_name == "State St & 19th St" |
                         d.oct.clean$to_station_name == "State St & 29th St" |
                         d.oct.clean$to_station_name == "State St & 33rd St" |
                         d.oct.clean$to_station_name == "State St & 35th St" |
                         d.oct.clean$to_station_name == "Wabash Ave & Cermak Rd" |
                         d.oct.clean$to_station_name == "Wells St & 19th St" |
                         d.oct.clean$to_station_name == "Wentworth Ave & 24th St" |
                         d.oct.clean$to_station_name == "Wentworth Ave & 33rd St" |
                         d.oct.clean$to_station_name == "Wentworth Ave & 35th St" |
                         d.oct.clean$to_station_name == "Wentworth Ave & Archer Ave"] <- "60616" 
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Calumet Ave & 71st St" |
                         d.oct.clean$to_station_name == "Cottage Grove Ave & 71st St" |
                         d.oct.clean$to_station_name == "Cottage Grove Ave & 78th St" |
                         d.oct.clean$to_station_name == "Cottage Grove Ave & 83rd St" |
                         d.oct.clean$to_station_name == "Eberhart (Vernon) Ave & 79th St" |
                         d.oct.clean$to_station_name == "Ellis Ave & 83rd St" |
                         d.oct.clean$to_station_name == "Evans Ave & 75th St" |
                         d.oct.clean$to_station_name == "Greenwood Ave & 79th St" |
                         d.oct.clean$to_station_name == "MLK Jr Dr & 83rd St" |
                         d.oct.clean$to_station_name == "State St & 76th St" |
                         d.oct.clean$to_station_name == "State St & 79th St" |
                         d.oct.clean$to_station_name == "Stony Island Ave & 75th St" |
                         d.oct.clean$to_station_name == "Vernon Ave & 75th St" |
                         d.oct.clean$to_station_name == "Wabash Ave & 83rd St" |
                         d.oct.clean$to_station_name == "Wabash Ave & 87th St" |
                         d.oct.clean$to_station_name == "Woodlawn Ave & 75th St"] <- "60619"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Canal St & Adams St" |
                         d.oct.clean$to_station_name == "Canal St & Jackson Blvd" |
                         d.oct.clean$to_station_name == "Canal St & Monroe St (*)" |
                         d.oct.clean$to_station_name == "Clinton St & Lake St" |
                         d.oct.clean$to_station_name == "Clinton St & Madison St" |
                         d.oct.clean$to_station_name == "Clinton St & Washington Blvd" |
                         d.oct.clean$to_station_name == "Desplaines St & Jackson Blvd" |
                         d.oct.clean$to_station_name == "Desplaines St & Kinzie St" |
                         d.oct.clean$to_station_name == "Desplaines St & Randolph St" |
                         d.oct.clean$to_station_name == "Green St & Madison St" |
                         d.oct.clean$to_station_name == "Jefferson St & Monroe St"] <- "60661"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Canal St & Madison St" |
                         d.oct.clean$to_station_name == "Franklin St & Jackson Blvd" |
                         d.oct.clean$to_station_name == "Franklin St & Lake St" |
                         d.oct.clean$to_station_name == "Franklin St & Monroe St" |
                         d.oct.clean$to_station_name == "Franklin St & Quincy St" |
                         d.oct.clean$to_station_name == "Wacker Dr & Washington St"] <- "60606"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Central Park Blvd & 5th Ave" |
                         d.oct.clean$to_station_name == "Conservatory Dr & Lake St" |
                         d.oct.clean$to_station_name == "Kedzie Ave & Roosevelt Rd" |
                         d.oct.clean$to_station_name == "Kenton Ave & Madison St" |
                         d.oct.clean$to_station_name == "Kostner Ave & Adams St" |
                         d.oct.clean$to_station_name == "Kostner Ave & Lake St" |
                         d.oct.clean$to_station_name == "Pulaski Rd & Congress Pkwy" |
                         d.oct.clean$to_station_name == "Pulaski Rd & Lake St" |
                         d.oct.clean$to_station_name == "Pulaski Rd & Madison St"] <- "60624"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Cityfront Plaza Dr & Pioneer Ct" |
                         d.oct.clean$to_station_name == "Fairbanks Ct & Grand Ave" |
                         d.oct.clean$to_station_name == "Lake Shore Dr & Ohio St" |
                         d.oct.clean$to_station_name == "McClurg Ct & Erie St" |
                         d.oct.clean$to_station_name == "McClurg Ct & Illinois St" |
                         d.oct.clean$to_station_name == "Michigan Ave & Oak St" |
                         d.oct.clean$to_station_name == "Michigan Ave & Pearson St" |
                         d.oct.clean$to_station_name == "Mies van der Rohe Way & Chestnut St" |
                         d.oct.clean$to_station_name == "Mies van der Rohe Way & Chicago Ave" |
                         d.oct.clean$to_station_name == "Rush St & Cedar St" |
                         d.oct.clean$to_station_name == "Rush St & Hubbard St" |
                         d.oct.clean$to_station_name == "Rush St & Superior St" |
                         d.oct.clean$to_station_name == "St. Clair St & Erie St" |
                         d.oct.clean$to_station_name == "Streeter Dr & Grand Ave" |
                         d.oct.clean$to_station_name == "Wabash Ave & Grand Ave"] <- "60611"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Clark St & Chicago Ave" |
                         d.oct.clean$to_station_name == "Dearborn St & Erie St" |
                         d.oct.clean$to_station_name == "Franklin St & Chicago Ave" |
                         d.oct.clean$to_station_name == "Kingsbury St & Erie St" |
                         d.oct.clean$to_station_name == "Kingsbury St & Kinzie St" |
                         d.oct.clean$to_station_name == "LaSalle Dr & Huron St(*)" |
                         d.oct.clean$to_station_name == "LaSalle St & Illinois St" |
                         d.oct.clean$to_station_name == "Milwaukee Ave & Grand Ave" |
                         d.oct.clean$to_station_name == "Orleans St & Merchandise Mart Plaza" |
                         d.oct.clean$to_station_name == "Orleans St & Ohio St" |
                         d.oct.clean$to_station_name == "Sedgwick St & Huron St" |
                         d.oct.clean$to_station_name == "State St & Kinzie St" |
                         d.oct.clean$to_station_name == "Wells St & Huron St" |
                         d.oct.clean$to_station_name == "LaSalle (Wells) St & Huron St"] <- "60654"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Clark St & Elm St" |
                         d.oct.clean$to_station_name == "Clark St & Schiller St" |
                         d.oct.clean$to_station_name == "Clybourn Ave & Division St" |
                         d.oct.clean$to_station_name == "Dearborn Pkwy & Delaware Pl" |
                         d.oct.clean$to_station_name == "Lake Shore Dr & North Blvd" |
                         d.oct.clean$to_station_name == "Larrabee St & Division St" |
                         d.oct.clean$to_station_name == "Larrabee St & Kingsbury St" |
                         d.oct.clean$to_station_name == "Larrabee St & North Ave" |
                         d.oct.clean$to_station_name == "Larrabee St & Oak St" |
                         d.oct.clean$to_station_name == "Orleans St & Chestnut St (NEXT Apts)" |
                         d.oct.clean$to_station_name == "Orleans St & Elm St (*)" |
                         d.oct.clean$to_station_name == "Ritchie Ct & Banks St" |
                         d.oct.clean$to_station_name == "Sedgwick St & North Ave" |
                         d.oct.clean$to_station_name == "Sedgwick St & Schiller St" |
                         d.oct.clean$to_station_name == "State St & Pearson St" |
                         d.oct.clean$to_station_name == "Wells St & Elm St" |
                         d.oct.clean$to_station_name == "Wells St & Evergreen Ave" |
                         d.oct.clean$to_station_name == "Wells St & Walton St"] <- "60610"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Clark St & Lake St" |
                         d.oct.clean$to_station_name == "Clark St & Randolph St" |
                         d.oct.clean$to_station_name == "Columbus Dr & Randolph St" |
                         d.oct.clean$to_station_name == "Daley Center Plaza" |
                         d.oct.clean$to_station_name == "Dusable Harbor" |
                         d.oct.clean$to_station_name == "Field Blvd & South Water St" |
                         d.oct.clean$to_station_name == "Michigan Ave & Lake St" |
                         d.oct.clean$to_station_name == "Millennium Park" |
                         d.oct.clean$to_station_name == "State St & Randolph St" |
                         d.oct.clean$to_station_name == "Stetson Ave & South Water St" |
                         d.oct.clean$to_station_name == "Wabash Ave & Wacker Pl"] <- "60601"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Cottage Grove Ave & 43rd St" |
                         d.oct.clean$to_station_name == "Cottage Grove Ave & 47th St" |
                         d.oct.clean$to_station_name == "Cottage Grove Ave & Oakwood Blvd" |
                         d.oct.clean$to_station_name == "Greenwood Ave & 47th St" |
                         d.oct.clean$to_station_name == "Indiana Ave & 40th St" |
                         d.oct.clean$to_station_name == "MLK Jr Dr & 47th St" |
                         d.oct.clean$to_station_name == "MLK Jr Dr & Pershing Rd" |
                         d.oct.clean$to_station_name == "Prairie Ave & 43rd St" |
                         d.oct.clean$to_station_name == "Woodlawn Ave & Lake Park Ave"] <- "60653"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Cottage Grove Ave & 63rd St" |
                         d.oct.clean$to_station_name == "Cottage Grove Ave & 67th St" |
                         d.oct.clean$to_station_name == "Dorchester Ave & 63rd St" |
                         d.oct.clean$to_station_name == "DuSable Museum" |
                         d.oct.clean$to_station_name == "Eberhart Ave & 61st St" |
                         d.oct.clean$to_station_name == "Ellis Ave & 55th St" |
                         d.oct.clean$to_station_name == "Ellis Ave & 58th St" |
                         d.oct.clean$to_station_name == "Ellis Ave & 60th St" |
                         d.oct.clean$to_station_name == "Harper Ave & 59th St" |
                         d.oct.clean$to_station_name == "Lake Park Ave & 56th St" |
                         d.oct.clean$to_station_name == "MLK Jr Dr & 56th St (*)" |
                         d.oct.clean$to_station_name == "MLK Jr Dr & 63rd St" |
                         d.oct.clean$to_station_name == "Museum of Science and Industry" |
                         d.oct.clean$to_station_name == "Prairie Ave & Garfield Blvd" |
                         d.oct.clean$to_station_name == "Stony Island Ave & 64th St" |
                         d.oct.clean$to_station_name == "University Ave & 57th St"] <- "60637"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Dearborn St & Adams St" |
                         d.oct.clean$to_station_name == "Dearborn St & Monroe St" |
                         d.oct.clean$to_station_name == "Lake Shore Dr & Monroe St" |
                         d.oct.clean$to_station_name == "LaSalle St & Adams St" |
                         d.oct.clean$to_station_name == "Wabash Ave & Adams St"] <- "60603"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Elmwood Ave & Austin St" |
                         d.oct.clean$to_station_name == "Valli Produce - Evanston Plaza"] <- "60202"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Exchange Ave & 79th St" |
                         d.oct.clean$to_station_name == "South Chicago Ave & 83rd St" |
                         d.oct.clean$to_station_name == "Stony Island Ave & 82nd St" |
                         d.oct.clean$to_station_name == "Stony Island Ave & South Chicago Ave"] <- "60617"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Halsted St & 56th St" |
                         d.oct.clean$to_station_name == "Halsted St & 59th St" |
                         d.oct.clean$to_station_name == "Halsted St & 63rd St" |
                         d.oct.clean$to_station_name == "Halsted St & 69th St" |
                         d.oct.clean$to_station_name == "May St & 69th St" |
                         d.oct.clean$to_station_name == "Normal Ave & 72nd St" |
                         d.oct.clean$to_station_name == "Perry Ave & 69th St" |
                         d.oct.clean$to_station_name == "Racine Ave & 61st St" |
                         d.oct.clean$to_station_name == "Wentworth Ave & 63rd St"] <- "60621"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Keystone Ave & Fullerton Ave"] <- "60639"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "MLK Jr Dr & Oakwood Blvd"] <- "60620"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Keystone Ave & Montrose Ave"] <- "60630"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "LaSalle St & Jackson Blvd" |
                         d.oct.clean$to_station_name == "Michigan Ave & Jackson Blvd" |
                         d.oct.clean$to_station_name == "State St & Van Buren St"] <- "60604"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "LaSalle St & Washington St" |
                         d.oct.clean$to_station_name == "Michigan Ave & Madison St" |
                         d.oct.clean$to_station_name == "Michigan Ave & Washington St"] <- "60602"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Oakley Ave & Touhy Ave" |
                         d.oct.clean$to_station_name == "Ridge Blvd & Howard St" |
                         d.oct.clean$to_station_name == "Ridge Blvd & Touhy Ave" |
                         d.oct.clean$to_station_name == "Warren Park East" |
                         d.oct.clean$to_station_name == "Warren Park West" |
                         d.oct.clean$to_station_name == "Western Ave & Howard St" |
                         d.oct.clean$to_station_name == "Western Ave & Lunt Ave"] <- "60645"
d.oct.clean$to_zipcode[d.oct.clean$to_station_name == "Sheridan Rd & Noyes St (NU)" |
                         d.oct.clean$to_station_name == "University Library (NU)"] <- "60208"
detach(d.oct.clean)

############
#Creating a new variable, temp_scale, to change temperature into a categorical variable
attach(d.oct.clean)
d.oct.clean$temp_scale[d.oct.clean$temperature >= 0 & d.oct.clean$temperature < 6] <- "Cold"
d.oct.clean$temp_scale[d.oct.clean$temperature >= 6 & d.oct.clean$temperature < 11] <- "Cool"
d.oct.clean$temp_scale[d.oct.clean$temperature >= 11 & d.oct.clean$temperature < 16] <- "Fair"
d.oct.clean$temp_scale[d.oct.clean$temperature >= 16 & d.oct.clean$temperature < 21] <- "Warm"
d.oct.clean$temp_scale[d.oct.clean$temperature >= 21 & d.oct.clean$temperature < 26] <- "Very Warm"
d.oct.clean$temp_scale[d.oct.clean$temperature >= 26] <- "Hot"
detach(d.oct.clean)

#Creating a new variable, time_bucket, to change timeduration_mins into a categorical variable
attach(d.oct.clean)
d.oct.clean$time_bucket[d.oct.clean$tripduration_mins >= 0 & d.oct.clean$tripduration_mins <= 15] <- "Between 1 and 15 Mins"
d.oct.clean$time_bucket[d.oct.clean$tripduration_mins >= 16 & d.oct.clean$tripduration_mins <= 30] <- "Between 16 and 30 Mins"
d.oct.clean$time_bucket[d.oct.clean$tripduration_mins >= 31 & d.oct.clean$tripduration_mins <= 45] <- "Between 31 and 45 Mins"
d.oct.clean$time_bucket[d.oct.clean$tripduration_mins >= 46 & d.oct.clean$tripduration_mins <= 60] <- "Between 46 Mins and 1 hour"
d.oct.clean$time_bucket[d.oct.clean$tripduration_mins >= 61 ] <- "Over an hour"
detach(d.oct.clean)

# Creating a new variable, from_area_code and to_area_code, to bucket from_zipcodes to community area
attach(d.oct.clean)
d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60201" | 
                             d.oct.clean$from_zipcode == "60202" |
                             d.oct.clean$from_zipcode == "60208"] <- "Evanston"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60601" |
                             d.oct.clean$from_zipcode == "60602" |
                             d.oct.clean$from_zipcode == "60603" |
                             d.oct.clean$from_zipcode == "60604" |
                             d.oct.clean$from_zipcode == "60605" |
                             d.oct.clean$from_zipcode == "60606" |
                             d.oct.clean$from_zipcode == "60607" |
                             d.oct.clean$from_zipcode == "60654" |
                             d.oct.clean$from_zipcode == "60661"] <- "Loop"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60608" |
                                  d.oct.clean$from_zipcode == "60622" |
                                  d.oct.clean$from_zipcode == "60623" |
                                  d.oct.clean$from_zipcode == "60624" |
                                  d.oct.clean$from_zipcode == "60642" |
                                  d.oct.clean$from_zipcode == "60644" |
                                  d.oct.clean$from_zipcode == "60651"] <- "West Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60609" |
                             d.oct.clean$from_zipcode == "60621" |
                             d.oct.clean$from_zipcode == "60636"] <- "Southwest Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60610" |
                             d.oct.clean$from_zipcode == "60611" |
                             d.oct.clean$from_zipcode == "60645"] <- "Near North Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60612"] <- "Near West Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60637" |
                             d.oct.clean$from_zipcode == "60649" |
                             d.oct.clean$from_zipcode == "60653"] <- "South Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60616"] <- "Near South Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60617" |
                             d.oct.clean$from_zipcode == "60619"] <- "Far Southeast Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60618" |
                             d.oct.clean$from_zipcode == "60613" |
                             d.oct.clean$from_zipcode == "60614" |
                             d.oct.clean$from_zipcode == "60615" |
                             d.oct.clean$from_zipcode == "60647" |
                             d.oct.clean$from_zipcode == "60657" |
                             d.oct.clean$from_zipcode == "60659"] <- "North Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60620"] <- "Far Southwest Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60625" |
                             d.oct.clean$from_zipcode == "60626" |
                             d.oct.clean$from_zipcode == "60630" |
                             d.oct.clean$from_zipcode == "60640" |
                             d.oct.clean$from_zipcode == "60660"] <- "Far North Side"

d.oct.clean$from_area_code[d.oct.clean$from_zipcode == "60639" |
                             d.oct.clean$from_zipcode == "60641"] <- "Northwest Side"
############
d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60201" | 
                           d.oct.clean$to_zipcode == "60202" |
                           d.oct.clean$to_zipcode == "60208"] <- "Evanston"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60601" |
                           d.oct.clean$to_zipcode == "60602" |
                           d.oct.clean$to_zipcode == "60603" |
                           d.oct.clean$to_zipcode == "60604" |
                           d.oct.clean$to_zipcode == "60605" |
                           d.oct.clean$to_zipcode == "60606" |
                           d.oct.clean$to_zipcode == "60607" |
                           d.oct.clean$to_zipcode == "60654" |
                           d.oct.clean$to_zipcode == "60661"] <- "Loop"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60608" |
                                d.oct.clean$to_zipcode == "60622" |
                                d.oct.clean$to_zipcode == "60623" |
                                d.oct.clean$to_zipcode == "60624" |
                                d.oct.clean$to_zipcode == "60642" |
                                d.oct.clean$to_zipcode == "60644" |
                                d.oct.clean$to_zipcode == "60651"] <- "West Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60609" |
                           d.oct.clean$to_zipcode == "60621" |
                           d.oct.clean$to_zipcode == "60636"] <- "Southwest Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60610" |
                           d.oct.clean$to_zipcode == "60611" |
                           d.oct.clean$to_zipcode == "60645"] <- "Near North Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60612"] <- "Near West Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60637" |
                           d.oct.clean$to_zipcode == "60649" |
                           d.oct.clean$to_zipcode == "60653"] <- "South Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60616"] <- "Near South Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60617" |
                           d.oct.clean$to_zipcode == "60619"] <- "Far Southeast Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60618" |
                           d.oct.clean$to_zipcode == "60613" |
                           d.oct.clean$to_zipcode == "60614" |
                           d.oct.clean$to_zipcode == "60615" |
                           d.oct.clean$to_zipcode == "60647" |
                           d.oct.clean$to_zipcode == "60657" |
                           d.oct.clean$to_zipcode == "60659"] <- "North Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60620"] <- "Far Southwest Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60625" |
                           d.oct.clean$to_zipcode == "60626" |
                           d.oct.clean$to_zipcode == "60630" |
                           d.oct.clean$to_zipcode == "60640" |
                           d.oct.clean$to_zipcode == "60660"] <- "Far North Side"

d.oct.clean$to_area_code[d.oct.clean$to_zipcode == "60639" |
                           d.oct.clean$to_zipcode == "60641"] <- "Northwest Side"

detach(d.oct.clean)
#####
View(d.oct.clean)

# Correspondence Analysis - Trip Duration and Generation
subOct2 <- d.oct.clean[c(26, 21)]
table.subOct2 <- table(subOct2, dnn=c("Trip Duration", "Generation"))
margin.table(table.subOct2, 1)
caFit2 <- ca(table.subOct2)
summary(caFit2)
plot(caFit2, arrows = c(F, F))


# Correspondence Analysis - From Zip Code and Generation
subOct3 <- d.oct.clean[c(28, 21)]
table.subOct3 <- table(subOct3, dnn=c("From Station Zip Code", "Generation"))
margin.table(table.subOct3, 1)
caFit3 <- ca(table.subOct3)
summary(caFit3)
plot(caFit3, arrows = c(F, F))

# Correspondence Analysis - To Zip Code and Generation
subOct4 <- d.oct.clean[c(23, 21)]
table.subOct4 <- table(subOct4, dnn=c("To Station Zip Code", "Generation"))
margin.table(table.subOct4, 1)
caFit4 <- ca(table.subOct4)
summary(caFit4)
plot(caFit4, arrows = c(F, T))

# Correspondence Analysis - Temperature and Generation
subOct5 <- d.oct.clean[c(24, 21)]
table.subOct5 <- table(subOct5, dnn=c("Temperature", "Generation"))
margin.table(table.subOct5, 1)
caFit5 <- ca(table.subOct5)
summary(caFit5)
plot(caFit5, arrows = c(F, F))

# Correspondence Analysis - Temperature and From Station
subOct6 <- d.oct.clean[c(24, 26)]
table.subOct6 <- table(subOct6, dnn=c("Temperature", "Trip Duration"))
margin.table(table.subOct6, 1)
caFit6 <- ca(table.subOct6)
summary(caFit6)
plot(caFit6, arrows = c(F, F))

# Correspondence Analysis - Temperature and From Station
subOct7 <- d.oct.clean[c(28, 30)]
table.subOct7 <- table(subOct7, dnn=c("From Station Neighborhood", "ToStation Neighborhood"))
margin.table(table.subOct7, 1)
caFit7 <- ca(table.subOct7)
summary(caFit7)
plot(caFit7, arrows = c(F, F))
