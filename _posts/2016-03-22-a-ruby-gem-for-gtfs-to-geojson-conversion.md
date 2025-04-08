---
title: A Ruby Gem for GTFS to GeoJSON Conversion
date: 2016-03-22T22:37:42+00:00
author: Tyler Green
layout: post
permalink: /blog/2016/03/a-ruby-gem-for-gtfs-to-geojson-conversion/
---
I published my first Ruby gem: gtfs-geojson! You can view the [source on GitHub](https://github.com/tyleragreen/gtfs-geojson). gtfs-geojson is a Ruby utility to convert a GTFS feed to a GeoJSON file. It's a simple endeavor, for sure, but I&#8217;m pleased with what I learned along the way.

Let's start out with some before-and-after views of the data. These images were created using QGIS, OpenStreetMap, Transfort&#8217;s GTFS feed, and the gtfs-geojson library.

<div style="text-align:center">
  <img src="/assets/img/2016-03-22/gtfs.png" alt="The Transfort GTFS data loaded in QGIS before applying the Ruby gem for GTFS to GeoJSON conversion." />
  
  <p class="caption-text">
    This map displays the shapes.txt file from Transfort's GTFS feed loaded into QGIS. The seemingly-inconsistent shading on the lines is because there are no lines at all; each "line" is made up of a sequence of points. Each point contains a route ID and is ordered relative to the other points in its route by a point sequence value.
  </p>
</div>

<div style="text-align:center">
  <img src="/assets/img/2016-03-22/geojson.png" alt="The Transfort GTFS data loaded in QGIS after applying the Ruby gem for GTFS to GeoJSON conversion." />
  
  <p class="caption-text">
    After running the GTFS feed through gtfs-geojson, you now have a GeoJSON file whose features are each route from the original feed. I used "Categorized" styles in QGIS to quickly apply a unique color to each route.
  </p>
</div>

As with most transit projects, the input to gtfs-geojson is a GTFS feed. GTFS is the standard format published by transit agencies worldwide to make their routes, stops, and even fares usable by developers. The data is a series of comma-separated text files. To validate a GTFS feed, I used an existing gem. [gtfs](https://github.com/nerdEd/gtfs) will fail gracefully if the shapes.txt file is not present, which is the only file I actually need for the conversion to GeoJSON.

gtfs-geojson implements the same algorithm as the "Points to path" QGIS tool I used when [looking at Transfort bus data](/blog/2016/01/transfort-bus-stops-through-the-lens-of-gis/). The main trick is that the points within each route ID must be sorted by their point sequence value. Several other QGIS plugins I tried did not do this correctly, so don't forget this if implementing this yourself!

While QGIS tools output shapefiles, gtfs-geojson produces a GeoJSON file, which is a JSON stream with geospatial points and polylines data served up in a standard format. I have previously <a href="/blog/2016/02/new-york-city-transit-frequency-visualization/">loaded GeoJSON files in Mapbox</a> applications, and they are also useful in a GIS context. The following three lines will load the library, validate the GTFS feed, convert its shapes.txt file to GeoJSON format, and write the GeoJSON to a file.

```ruby
require 'gtfs-geojson'
geojson = GTFS::GeoJSON.generate("gtfs.zip")
File.open("gtfs.geojson",'w') do { |f| f.write(geojson) }
```

That's it! Let me know if you have any suggestions! The `README` on [the GitHub repo](https://github.com/tyleragreen/gtfs-geojson) gives installation instructions.

The most valuable tip I learned while creating this gem was the use of the `$RUBYLIB` environment variable. This isn't necessary when installing a gem onto your system using bundler, but it is extremely helpful during development. `$RUBYLIB` lets you specify the path searched when the `require` keyword is used. To add paths dynamically to `$RUBYLIB`, you can push items to the `$:` array. `$:` is shorthand for `$LOAD_PATH` within a Ruby program. My `require_relative` days are over!

If you are considering writing your own gem, I highly recommend RubyGems.org's "[Make Your Own Gem](http://guides.rubygems.org/make-your-own-gem/)" guide. It is comprehensive and just generally fantastic.

I plan to use gtfs-geojson in a Rails project in the future. And speaking of gems, I've also been dabbling on a Ruby API client for [Transitland](http://transit.land/). I hope to have more to share on both fronts soon!

Until then, **ride on**!
