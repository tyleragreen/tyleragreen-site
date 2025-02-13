---
id: 828
title: 'notetime: Statically-Generated Dynamic Notes'
date: 2019-05-14T01:55:13+00:00
author: Tyler Green
layout: post
guid: https://tyleragreen.com/blog/?p=828
permalink: /blog/2019/05/notetime-statically-generated-dynamic-notes/
categories:
  - Projects
tags:
  - nodejs
  - notes
  - new-york-city
---

I was churning through a lot of sources. In the summer of 2017, I was new to New York and frantically learning everything I could about the MTA. After a few months, I had a better grasp on how the capital program functions and [a blog post on fare increases](/blog/2017/10/alls-fare-diving-into-mta-fares/). Along the way, my process was a rollercoaster.

What I landed on is `notetime`, a Node.js library which accepts a series of Markdown-based notes and outputs the statically-generated notes sorted and tagged. The result is browseable on GitHub or through a docs integration (I used GitBooks).

- Library
  - [Source and Documentation on Github](https://github.com/tyleragreen/notetime)
  - [npm Library](https://www.npmjs.com/package/notetime)
- Example
  - [notetime used on my urban history notes](https://github.com/tyleragreen/history)
  - [urban history notes published on Gitbooks](https://tyleragreen.gitbooks.io/history/)


## What led me to build `notetime`?

I didn't just wake up one day and decide to statically-compile Markdown notes. I was seeking a way to represent information over time. Here are the steps in my journey.

### Paper and Beer
<img src="/assets/img/2019-05-08/note1.jpg" />

During my last week in Colorado, I took some printed sources to a brewery and took notes in pen. This method was satisfying from a spontaneous creativity point-of-view, but has some serious scaling limitations. I was surprised that no one else at New Belgium that day seemed to be interested in `MTA Flow of Funds`.

### Google Doc
<img src="/assets/img/2019-05-08/note2.png" />

About ten minutes after jotting details down on a printed flow charts, I began tossing sources into a Google Doc. This satisfied the goal of being able to say, "Yeah, I have a document," but didn't provide many other advantages. After revamping the note style and layout three times before I had two pages of notes, I knew I wanted something more dynamic.

### `notetime`
<img src="/assets/img/2019-05-08/note3.jpg" />

`notetime` grew out of my desire to be able to write notes in a low-overhead way, and later group and sort them in many ways. I wanted to limit the number of required fields per note, to make minimal note-taking a breeze. I also wanted to provide some richer capabilities, such as sources and timelines.

## What are the design goals of `notetime`?

- **tagging** - the ability to view subsets of a notes set
- **dated** - the ability to sort subsets of notes by date
- **portable** - so many online note tools seem great but don't improve over time or fit your ideal data model; I wanted to be able to take my note output _as is_ at any point in time and stop using `notetime`
- **publishable** - the ability to quickly link to a note I had just written
- **light-weight** - anything but a CMS

## What is a note?

A note is Markdown. It's that simple. In addition to a note body, notes can be annotated with [keywords](https://github.com/tyleragreen/notetime#keywords) that exist on their own line that must begin with a semicolon. Let's see an example!

### Example Note - Pre-Compilation
In this example note, we are providing one line of body text, a title, two tags, and one source. The lines that include `1-source-*` are grouped by their source integer. A second source could use `2-` or `99-` - it doesn't matter as long as it is unique! This is a half-hack, half-decent solution to keep note parsing stateless from line to line.
```
; title Richard Ravitch NYT Op-Ed on Governor's Interference
; 1-source-id nyt
; 1-source-url https://www.nytimes.com/2019/03/29/opinion/new-yorks-subways-mta.html
; 1-source-title New York's Subways Need an Independent M.T.A.
; 1-source-date March 29, 2019
; 1-source-author Richard Ravitch
; tags mta ravitch

- Discourages city take-over because it resembles system that failed pre-MTA and risks losing regional taxes currently provided from state Legislature
```
### Example Note - Post-Compilation
When we compile our notes, we get this even-more-Markdown output! Our title is a title, our tags link to the generated tag Markdown files, and our source has been compiled into a mix of all major citation formats.

### Richard Ravitch NYT Op-Ed on Governor's Interference
- Discourages city take-over because it resembles system that failed pre-MTA and risks losing regional taxes currently provided from state Legislature
- Source: Richard Ravitch, "New York's Subways Need an Independent M.T.A.," *The New York Times*, March 29, 2019. [link](https://www.nytimes.com/2019/03/29/opinion/new-yorks-subways-mta.html)
- Tags: [mta](this-would-be-a-link-to-the-mta-tag.md) [ravitch](this-would-be-a-link-to-the-ravitch-tag.md)

I was initially hestitant to generate full citations, but one of my academic friends nudged me in that direction. I feared that saving only links would make the sources slowly invalidate over time as links broke. By allowing the option for full sources (partial sources are easy too: `; source text link`), we could preserve the ability to rebuild broken links.

## What is the workflow?
You can install `notetime` into your note repo using `npm`.
```bash
npm install --save notetime
```

To initialize your notes repo, you should create a `config.json`. This is where you delcare the title and description of your note repo, but also what timelines to generate and what sources to group.
```json
{
  "title": "Urban History",
  "description": "This document accompanies my urban history studies.",
  "timelines": [
    "fare-increases"
  ],
  "sources": {
    "nyt": "The New York Times"
  }
}
```
The following commands ship with `notetime` to assist in note-taking.
```bash
# open vi to let you write your note
./new_note.js

# open note that matches search string (if and only if there is 1 match)
./open_note.js "search string"

# run notetime to compiles notes, commits and pushes the changes
./deploy.sh
```

In my bash session, I have these three commands aliased to `nn`, `no`, and `nd`. I have found these GREATLY improve my ability to leave the tool for a month or two and still be producive when I return. Another approach could be `make` commands for each.

## How do I make sense of my notes?

Notes in their raw form live in the `notes/` directory by default, are named with a time-stamp, and are generally un-discoverable. Their compiled output populates `README.md` and grows over time, which is great for impressing people with how many notes you take, but not great for consuming information. This is where tagging and timelines come in.

### Tagging

Tagging is exactly like it sounds.
Based on the string fields in your tag keyword (`; tags mta hot-cars`), in addition to being dumped into `README.md`, a note will be added to `tags/mta.md` and `tags/hot-cars.md`.
This simple mechanism can be used to group notes and help you later consume information about specific topics.

### Timelines

Timelines are built on top of tagging and provide a sorted-by-date view into a single tag.
An example is [my notes on fare increases](https://github.com/tyleragreen/history/blob/master/timelines/fare-increases.md).
Notes can be dated with a date keyword (`; date <date>`), or their single source date will be used.
You can tell `notetime` what tags should be turned into timelines under the `timelines` key of your `config.json`.

## What is next?

I'm going to keep taking notes! I don't plan to develop more on `notetime` for the time being.

I have mulled over introducing a `domain` feature. This would be similar to a tag, but intended as a higher-level grouping. The use-case in my notes would be `mta` versus `new-york-city` versus `new-york-state`. For now, I'm just tagging notes with their domain, which is simpler but doesn't allow you to partition. I will solve this another day!

Let me know if you have any questions! This post was basically a brain-dump, but now it is out there.

Happy learning!
