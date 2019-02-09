---
id: 416
title: Transfort Bus Stops Through the Lens of GIS
date: 2016-01-18T05:05:33+00:00
author: Tyler Green
layout: post
guid: http://www.tyleragreen.com/blog/?p=416
permalink: /blog/2016/01/transfort-bus-stops-through-the-lens-of-gis/
categories:
  - Projects
tags:
  - fort collins
  - gis
  - gtfs
  - transfort
---
To better understand the Fort Collins population and what percentage of it is adequately served by Transfort bus stops, I decided to jump on board the GIS-hype train. I downloaded QGIS, read a bit at <a href="http://www.qgistutorials.com" target="_blank">qgistutorials.com</a>, and felt ready to dive in.

## You're talkin' about Transfort bus stops?

You bet I am! To begin (and prove to myself this wouldn't be the most manual project I'd ever taken on), I collected data from several sources. I have included a [Links](#links) section with paths to download the data yourself. You can also jump straight to the [data](#data), though you'll miss some sweet graphics along the way.

  1. Transfort &#8211; I could not find shapefiles for either the Transfort stops or routes, so I began with the GTFS feed. Data in this transit agency standard format is in a series of comma-separated text files. The three of interest to me were the stops.txt, shapes.txt, and routes.txt.
  2. City of Fort Collins &#8211; I used two shapefiles provided by the city, ones of city limits and street centerlines.
  3. Colorado Information Marketplace &#8211; Fortuitously, Colorado publishes population data on the census block level. These correspond to city blocks, which were necessary for analyzing the population within Fort Collins.

To visualize the population density, I began with a heatmap. The census blocks shapefile is essentially a table of polygons, each with an attribute containing the population of that block in 2010. I filtered the layer to only include blocks within Larimer County and then created a layer of the census block centroids, which turned each polygon into a point. At this point, the default layer unit was degrees. To analyze this layer in meters, I reprojected the layer to SIRGAS 2000 / UTM Zone 13N. I then created a raster heatmap with a radius of 402 meters, which corresponds to a quarter-mile radius. This is an area of approximately 0.2 square miles, which is also listed in the map legend.

Before analyzing bus stops, I wanted to visually present each Transfort route. This required converting the shapes.txt file into a routes shapefile. QGIS can do this with the "Points to path" tool under Vector Creation algorithms. I have uploaded the resulting shapefile, along with PDFs of the following maps, in the [Downloads](#downloads) section.

<div style="text-align:center"><img src="/assets/img/2016-01-10/routes_with_density.png" alt="Population Density with Transfort Bus Stops"></div>

In addition to population density, I wanted to study walking distance from Transfort bus stops. Latitude and longitude information for each stop is contained within the stops.txt file. The QGIS plugin MMQGIS allows imports of these using "Geometry Import from CSV File." I again needed to reproject the resulting layer to SIRGAS 2000 / UTM Zone 13N to ensure the layer units were meters. I wanted see the results of a 10-minute walk radii, so I created 804 meter (half-mile) buffers around each bus stop.

<div style="text-align:center"><img src="/assets/img/2016-01-10/half_mile_buffers.png" alt="Ten-Minute Walk Radii from Tranfort Bus Stops"></div>

Since the half-mile coverage seemed surprisingly complete, I created a layer of 402 meter (quarter-mile) buffers around each bus stop to show the area within a 5-minute walk.

<div style="text-align:center"><img src="/assets/img/2016-01-10/quarter_mile_buffers.png" alt="Five-Minute Walk Radii from Transfort Bus Stops"></div>

To allow the population density layer to blend with the walk distance buffers, I changed the layer blending mode to Darken.  The shades of green in the image below show dense areas overlapping with a 5-minute walk radius from a bus stop.

<div style="text-align:center"><img src="/assets/img/2016-01-10/quarter_mile_buffers_blend.png" alt="Population Density with Five-Minute Walk Radii from Transfort Bus Stops"></div>

## <a style="text-decoration: none!important;" name="data"></a>Do you have any numbers I can 'wow' my friends with?

<div style="text-align:center"><img src="/assets/img/2016-01-10/data_table.png" alt="Fort Collins Population within Walking Distance of Transfort Bus Stops"></div>

I'm glad you asked! Another powerful feature of GIS is quantitative analysis. I used "Basic statistics" on the 2010 population field of the census block centroids layer to calculate the population of Larimer county. For the population of Fort Collins, I selected the census blocks that lie within the city limits polygon using a Spatial Query. Running statistics on these selected census block centroids produced the city population number in the table above.

You can see that the first half-mile buffer population is larger than the city population. I calculated the population within the walking distance buffers using two methods to adjust for this:

  1. No Flex Route &#8211; The FLEX is a commuter route operated by Transfort whose northern terminus is the South Transit Center. Several of its northern-most stops are inside Fort Collins city limits. I made the decision to remove the population near FLEX stops as commuter bus service has lower frequencies, and therefore different usage patterns, than a typical city bus. This was accomplished by joining the stops shapefile with stop_times.txt and trips.txt to give each route a column with its route name. I then used the Query Builder to select all stops whose route name was not "FLEX".
  2. City Limits &#8211; The northwest corner of the Transfort routes actually runs outside of Fort Collins city limits, meaning the people living close to these stops were not included in my calculated city population. I performed a Spatial Query to select the bus stops within the city limits polygon boundary. These are the only stops I calculated buffers around when selecting census blocks for this method.

In the figure below, the bottom center red circle shows the location of the first adjustment and top left red circle the second.

<div style="text-align:center"><img src="/assets/img/2016-01-10/city_limits_blowup.png" alt="Exceptions Made When Analyzing Data for Transfort Bus Stops"></div>

## What does this mean?

You can see that the east side of Fort Collins contains both fewer dense areas and fewer routes, especially north-south routes. I have seen a pre-MAX Transfort map (pre-May 2014) that contained a north-south route on Timberline Road, the easternmost arterial in Fort Collins. While it is disappointing that ridership supposedly did not justify keeping this route, the density numbers back up this service change.

The half-mile buffers confirm that the city is broken into a square mile grid. The two east-west routes (Horsetooth and Harmony) in the southeast corner of the map show the half-mile circles bumping against each other, creating a distance of a mile between the two roads.

Depending on the metric, **between 60% and 63% of Fort Collins residents are within a five-minute walk** of a Transfort bus stop. **This is significantly higher than I would have guessed**. However, being near a bus stop is only part of the story; frequency of service and driving disincentives also play a major role in whether a resident will ride the bus or not. Parking is quite easy in most of Fort Collins and the areas where it is harder, mainly Old Town, provide markedly sub-market value parking. The headway on the routes, excluding the MAX, is either 30 or 60 minutes. And there is no Sunday service. All this goes to say living within 5 minutes of a bus stop does not necessarily make for a transit heaven. It should also be noted that the block-level populations may have significantly changed since the 2010 census.

Regardless, having **87% of your population live within a 10-minute walk of a bus stop indicates an overall lack of transit deserts** and a fairly comprehensive bus system. I think Fort Collins is very close to a big shift in transit culture!

For better or worse, I will now scrutinize the density surrounding my Transfort bus stops and routes even more. Here's what I can tell you from my observations thus far: it's not great. Here's what the data says: it's not great. And here's to using data to continue to improve our city and its bus service!

Let me know if there is more I can do with this data! I'd also enjoy seeing analysis of this type in your own city.

Until next time, ride on!

## <a style="text-decoration: none!important;" name="downloads"></a>Downloads

[Transfort Routes Shapefile](/assets/img/2016-01-10/transfort_routes.zip)

[Population Density with Transfort Bus Routes PDF](/assets/img/2016-01-10/routes_with_density.pdf)

[Ten-Minute Walk Radii from Tranfort Bus Routes PDF](/assets/img/2016-01-10/half_mile_buffers.pdf)

[Five-Minute Walk Radii from Transfort Bus Routes PDF](/assets/img/2016-01-10/quarter_mile_buffers.pdf)

[Population Density with Five-Minute Walk Radii from Transfort Bus Routes PDF](/assets/img/2016-01-10/quarter_mile_buffers_blend.pdf)

## <a style="text-decoration: none!important;" name="links"></a>Links

Transfort GTFS Feed
  
<a href="http://www.ridetransfort.com/developers" target="_blank">http://www.ridetransfort.com/developers</a> OR
  
<a href="https://code.google.com/p/googletransitdatafeed/wiki/PublicFeeds" target="_blank">https://code.google.com/p/googletransitdatafeed/wiki/PublicFeeds</a> OR
  
<a href="http://transitfeeds.com/" target="_blank">http://transitfeeds.com/</a>

City of Fort Collins
  
<a href="http://www.fcgov.com/gis/downloadable-data.php" target="_blank">http://www.fcgov.com/gis/downloadable-data.php</a>

Colorado Information Marketplace
  
<a href="https://data.colorado.gov/Demographics/Census-Blocks-2010/xipb-k5bu" target="_blank">https://data.colorado.gov/Demographics/Census-Blocks-2010/xipb-k5bu</a>
