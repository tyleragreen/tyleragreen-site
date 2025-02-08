---
id: 595
title: 'Updated: New York City Transit Frequency Visualization'
date: 2016-03-29T07:25:24+00:00
author: Tyler Green
layout: post
guid: https://tyleragreen.com/blog/?p=595
permalink: /blog/2016/03/updated-new-york-city-transit-frequency-visualization/
categories:
  - Projects
tags:
  - mapbox
  - new york city
  - ruby
  - transitland
---
Since I detailed my New York City transit frequency visualization project <a href="/blog/2016/02/new-york-city-transit-frequency-visualization/">last month</a>, there have been a few updates. <a href="/maps/new_york" target="_blank">Check out the web tool</a> to view the changes!

## What's new?

  * The frequency buckets have been realigned to better parallel the psychology of how we use transit. The bins now group trips of less than 4 trips per hour, 4 to 8 trips per hour, and more than 8 trips per hour. <span style="font-weight: 400;">Less than 4 trips per hour is generally the threshold where riders should consult a schedule before waiting on a curb, so it was important to separate these visually. </span>The thickness of each edge now also increases with frequency.
  * There is now much more coverage in Queens bus data. No, MTA did not see my first update and decide to expand Queens service, though that would be awesome! I communicated with the Transitland team and my tool helped them discover they were previously missing the feed for the MTA Bus Company. It was historically a separate company and still has its own <a href="http://transitfeeds.com/p/mta/85" target="_blank">GTFS feed</a>. I came up with some wild conclusions in <a href="/blog/2016/02/new-york-city-transit-frequency-visualization/">my previous post on this project</a>, several of which were rendered invalid by the completion of the data set.

## What's up next?

I'd still like to filter the express bus routes, provide finer-grained sorting by mode, and increase the dynamic nature of the tool in general. I&#8217;ve been working on an <a href="https://github.com/transitland/transitland-ruby-client" target="_blank">updated Ruby client</a> to pair with the Transitland datastore, and have already <a href="https://github.com/tyleragreen/frequency-visualization/" target="_blank">updated my project source</a> with the new interface. I&#8217;ve also begun dabbling with GTFS-realtime and plan to build a project with this specification soon.

We're all #InTransit everyday and I hope to have many more updates soon!

_What kind of things are you working on? Let me know in the comments below!_

<div style="text-align:center">
  <a href="/maps/new_york/" target="_blank"><img src="/assets/img/2016-03-29/friday_subway.png" alt="The frequency data for subway routes on a Friday morning for New York City transit. The darker the color, the higher the frequency!" /></a>
  
  <p class="wp-caption-text">
    The frequency data for subway routes on a Friday morning in New York City. The darker the color, the higher the frequency!
  </p>
</div>
