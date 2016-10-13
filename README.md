# Project: Open Data NYC - an RShiny app development project
### [Project Description](doc/project2_desc.md)

Term: Fall 2016

+ Group 11
+ Projec title: 7 Major Felony in New York City
+ Team members
	+ Chenxi Huang
	+ Hayoung Kim
	+ Zhehao Liu

All 3 team members have pledged that they all put effort and work for this project.
	
+ Project summary: In this project, we explore the major felony data, aiming to provide information about crime throughout New York City. In particular, our shiny app includes a totaly of 6 main tabs and 3 subtabs, e.g. the Welcome page, NY neighborhood crime counts, Map Visualization, Deep Analysis (with 3 subtabs), Special Case(of the columbia neighborhood) and Aout Us.

+ App Introduction in Details:
1. Welcome Page is supposed to remind people that the importance of being safe if living in New York.
2. NY Neighborhood Crime is a page to display a variety of seven felonies among all 5 boroughs. It has a great feature of zooming in and out while users get to see the specific felony incident types and counts in each radius of the neighborhood.
3. Map Visualization is a way to illusrate felony incidents and the respective data tables.
4. Deep Analysis: Deep Analysis includes 3 subtabs. 
+                 (1) By Time tab displays felony incidents by different types of time, e.g. Years from 2010 to 2015, Months, Days and Hours.We've found that while it's obviously some crimes occur at night, some do take place in the middle of the day like Grand Larceny. Apart from that, crime counts also show seasonal patterns (especially monthly), rendering a future opportunity to explore the data more.
+                 (2) By Locations: By Locations also includes 2 more sub-subtabs. 
+                   Firstly in  By Different Boroughs, we get to compare the felony incidents among 5 different boroughs and how to compare is up to the users. Next in Precint Ranking, based on the total number of felony incidents, users can see the selected rankings of precints by slidering the bar and varifying the ranges. For instance, if I want to see the precints ranked from 25th to 35th, just use the slidebar to manage this range, and I can see a specific table of results.
+                 (3) By Crime Types: this interactive plot gives users a change to see the proportions of each of the 7 major felonies in a dynamic way such that they get to choose the specific year and boroughs. The pie charts perfectly illusrates that, for example, rapes don't happen as often as grand larceny or felony assaults. 
5. Special Case: this special case is designed for people living around Columbia University. It automates the felony incidents and how their distributions change with respect to a range of hours. This map gives users a very nice dynamic perspective of when and how many of these crimes happn during a spectrum of time. 
6. About Us: this tab provides users  with a generic information of the purpose of the app, the team and our self-introductions. Specifically, this is a chance to get to know the team and humanize the whole app.

+ Business Purpose: this app is of great use to those who are concerned over the safety issues in New York. Crimes happen everyday in New York, especially in boroughs like Bronx. People who relocate from elsewhere, parents who are looking for schools that can ensure their children's safeties, people who are looking for rentals as well as many other groups of people will be interested in this. Furthermore, this app can be used interactively with other shiny apps created for this project. 
+                   For example, people interested in running can use the Joggers app and also check our app to see the safe places to exercise (Actually, we often get crime alerts that people got robbed or sexually assaulted). Next, if you want to go to a bar at a specific hour in a specific place, how to choose bars can based on the safetyness of the neighborhood and look at our apps for more information. Same goes to people who are trying to rent apartments, parking their cars or eating in a restaurant. 
+ Overall, this app can accomodates the usage of other apps, along with offering an informative analysis on specific cases such as the area around Columbia Unversity. It creats to students and minorities (such as children, the olderly, and females) a feel of safetyness and an intelletual guide. 


```diff
+ **After your finish your shiny app, please replace the screenshot below with one from your own app.**
```

![screenshot](doc/Screen Shot 2016-10-12 at 11.47.16 AM.png)

	
**Contribution statement**: CH, HK and ZL all contributed analysis ideas for this work. CH is responsible for the in-depth analysis, app layout(e.g the app structure and page layout) and the interactive plots of felony data. HK is responsible for the interactive map based on user specified location as well as the hourly distribution of felony crimes around Columbia campus. ZL is responsible for the basic UI structure and interactive map with user input on specific time period. All team members approve our work presented in this GitHub repository including this contributions statement.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.

