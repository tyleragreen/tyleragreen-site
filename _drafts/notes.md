---
id: 828
title: 'Statically-Generated Notes'
date: 2019-02-18T21:46:13+00:00
author: Tyler Green
layout: post
guid: http://www.tyleragreen.com/blog/?p=828
permalink: /blog/2019/05/notetime/
categories:
  - Projects
tags:
  - nodejs
  - notes
  - new-york-city
---

I was churning through a lot of sources. In the summer of 2017, I was new to New York and frantically learning everything I could about the MTA. After a few months, I had a better grasp on how the capital program functions and [a blog post on fare increases](/blog/2017/10/alls-fare-diving-into-mta-fares/). Along the way, my process was a rollercoaster.

What I landed on is `notetime`, a Node.js library which accepts a series of Markdown-based notes and outputs the statically-generated notes sorted and tagged. The result is browseable on GitHub or through a docs integration (I used GitBooks).

- [Source on Github](https://github.com/tyleragreen/notetime)
- [npm Library](https://www.npmjs.com/package/notetime)
- [notetime used on my urban history notes](https://tyleragreen.gitbooks.io/history/)

How did I end up there? And what are the design goals of `notetime`?

### Paper and Beer
<img src="/assets/img/2019-05-08/note1.jpg" />

### Google Doc
<img src="/assets/img/2019-05-08/note2.png" />

The Google Doc I was using to collect some links was quickly becoming unweildy.

### `notetime`
<img src="/assets/img/2019-05-08/note3.jpg" />

## Goals

- **tagging** - the ability to view subsets of a notes set
- **dated** - the ability to sort subsets of notes
- **portable** - so many online note tools seem great but don't improve or fit your ideal data model; I didn't want to get locked in
- **publishable** - the ability to quickly share a note I had just written
- **light-weight** - not a full CMS

## Tooling

- `NTSourceAdd`
- `nn` and `nd` and `no` aliases
