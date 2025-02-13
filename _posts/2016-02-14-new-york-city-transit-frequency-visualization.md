---
id: 488
title: New York City Transit Depicted With (A New Set Of) Colorful Lines
date: 2016-02-14T21:28:49+00:00
author: Tyler Green
layout: post
guid: https://tyleragreen.com/blog/?p=488
permalink: /blog/2016/02/new-york-city-transit-frequency-visualization/
categories:
  - Projects
tags:
  - mapbox
  - new york city
  - ruby
  - transitland
---
_Update 3/29/16: The transit visualization has been updated! The technical details in this post are still relevant, but some of the conclusions are no longer valid. [Read about the updates here](/blog/2016/03/updated-new-york-city-transit-frequency-visualization/)!_

Stop the buses! Hold the phone! I now have visual proof that buses and subways in the Big Apple run more often on Fridays than Saturdays. How insightful, right? Okay, so maybe not, but I still enjoyed making a New York City transit frequency visualization using <a href="https://transit.land/" target="_blank">Transitland</a> and <a href="https://www.mapbox.com/" target="_blank">Mapbox</a>.

[You can view the map here](/maps/new_york)! Try hovering over each route and turning on different days and modes (subway versus bus) of service.

Below are a few images showing the difference in frequency of transit service on Friday and Saturday, followed by a discussion of each component of the project.

<div style="text-align:center">
  <img src="/assets/img/2016-02-14/friday.png" alt="Friday service in a New York City Transit Visualization" />
  
  <p class="wp-caption-text">
    Friday morning subway and bus frequency. The coverage and frequencies are impressive!
  </p>
</div>

<div style="text-align:center">
  <img src="/assets/img/2016-02-14/saturday.png" alt="Saturday service in a New York City Transit Visualization" />
  
  <p class="wp-caption-text">
    Saturday morning bus and subway service. As to be expected, the coverage is similar to on Friday, but the frequencies drop significantly.
  </p>
</div>

## What can we learn from this frequency visualization of New York City transit?

Some items this visualization illustrates are to be expected:

  * Transit runs with higher frequencies during the week.
  * Transit runs with higher frequencies in denser areas (Manhattan, Brooklyn) than less dense areas (Staten Island).

A few things made sense after seeing them, but were ideas I had not anticipated:

  * Even in dense areas, bus frequencies are higher in areas that have less subway service, and vice versa. While this is true in Manhattan (more subways and subway frequency) and Brooklyn (more buses and bus frequency), it is quite noticeable in Queens. When you turn the subway layer off, western Queens appears almost devoid of transit. While its subway connections do not reach to the eastern edge of Queens, they do begin to make up for a lack of bus routes in western Queens. A few images below show this.
  * The inter-borough connections between Queens and Brooklyn that are [notoriously absent](http://www.citylab.com/commute/2013/05/very-brief-history-why-its-so-hard-get-brooklyn-queens/5738/) in all heavy rail maps of the area are almost as weak even when viewing bus data. It just isn't easy to travel between Long Island's two boroughs. Maybe <a href="http://www.citylab.com/commute/2016/02/new-york-brooklyn-queens-waterfront-streetcar/459984/" target="_blank">the planned streetcar</a> will finally help this.

One thing to keep in mind: the trips per hour numbers that appear when you hover over lines on the map are not specific to a transit route. They encompass all transit services, potentially multiple routes and even modes, between the two stops that create an edge.

<div style="text-align:center">
  <img src="/assets/img/2016-02-14/queens_buses.png" alt="Queens bus routes in a New York City Transit Visualization" />
  
  <p class="wp-caption-text">
    Bus routes in western Queens. Doesn't this seem like it's missing something?
  </p>
</div>

<div style="text-align:center">
  <img src="/assets/img/2016-02-14/queens_subway.png" alt="Queens subway routes in a New York City Transit Visualization" />
  
  <p class="wp-caption-text">
    Bus and subway routes in western Queens. That's a bit better.
  </p>
</div>

## The Data

Transitland is an open source project that aggregates transit feeds from across the world. You can query its JSON API to create apps and visualizations easier than directly crunching the underlying GTFS data.

I was inspired to dig into Transitland by this <a href="https://gist.github.com/irees/272e5dc57614cab595a0" target="_blank">similar frequency visualization for San Francisco</a>. We both use the stops and schedule\_stop\_pairs API endpoints to calculate how often the "edge" between any two consecutive transit stops is visited in a given time frame.

I chose an appropriate bounding box to encompass all the transit stops operated by MTA and picked a window of 7:30am to 8:00am on the mornings of Friday, January 22, 2016, and Saturday, January 23, 2016. In addition to buses and subways, ferry service is also returned by Transitland in this bounding box, which explains the trips to Staten Island and oddly-direct routes to New Jersey.

The data returned by Transitland is not real-time data of actual transit performance, only the scheduled service times on those dates. I was able to extrapolate a "trips per hour" frequency metric by dividing the edge weight by the length of my query's time frame.

## The Map

I considered publishing a map using QGIS, but I was fortunate enough to stumble upon Mapbox. Mapbox does not have the analytical tools that QGIS does, but its ease of creating interactive web-based maps is impressive.

GeoJSON is a standard JSON variant that holds geographical information, such as points and line segments. In addition to its required fields, I loaded the GeoJSON output files with styling from Mapbox's <a href="https://github.com/mapbox/simplestyle-spec/tree/master/1.1.0" target="_blank">simplestyle-spec</a> based on the frequency for that line segment. Mapbox interprets these "properties" fields when displays the data on a map.

A good tool should be simple enough to let you spend time solving real problems and I found Mapbox to reach this goal swimmingly (is there a similar term for transit??). The small amount of code needed to plot four GeoJSON files, toggle between them, show a map legend, and allow zooming and a loading screen all on top of a satisfactory OpenStreetsMap was remarkable. I will most definitely be using Mapbox for future transit projects!

## The Code

As the JSON Transitland interface language-agnostic, any scripting language could be used. Ruby is by far my favorite, so I stuck with what I know. You can view the visualization in <a href="https://github.com/tyleragreen/frequency-visualization" target="_blank">my GitHub repository</a>.  The code is divided into an HTML front-end and Ruby back-end, though they do not connect directly. A few ideas I have for the future of this project:

  * The TransitlandAPIReader class could be generalized into a gem with a decent test suite, similar to <a href="https://github.com/transitland/transitland-ruby-client" target="_blank">one Transitland used to maintain and intends to bring back</a>.
  * The run.rb script could take a job spec input to produce GeoJSON files for multiple days and cities in a single run.
  * The Mapbox front-end could be used to visualize any arbitrary transit system's GTFS shape data. This would likely be done using a Rails back-end, rather than the offline Ruby script I am currently using.

## Other News

I spent another few hours this week getting lost reading about <a href="http://flavorwire.com/311780/9-of-the-coolest-secret-subway-stations-in-the-world/6" target="_blank">the Cincinnati subway</a>. If you haven't dove into that tunnel of information before, I'd highly recommend it. Something about using an old canal which had become economically unfeasible due to competition from railroads to build a tunnel system that was halted due to a moratorium on capital bonds during World War I and never successfully revived just fascinates me. Seriously, any single part of that last sentence would make for a good story, but all those together create a sort transit tragedy worthy of a Shakespearean drama.

> In the bed of the canal née Erie
> 
> doth thou venture to lay parallel rails.
> 
> To endure and inspire they began,
> 
> ere citizens above were admonished
> 
> their Sisyphean ambitions would fail.

I'm getting cold shivers just imagining a chorus reciting that at the opening of a transit conference. Please let me know of any other examples of transit stories told in iambic pentameter.

Until next time, **ride on!**
