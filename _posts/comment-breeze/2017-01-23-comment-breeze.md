---
title: Comment Breeze
date: 2017-01-23 00:00:00 +05:00
modified: 2020-06-05 00:00:00 +05:00
tags: [webdev, angular-js]
description: An overview of developing my largest-at-the-time personal project, Comment Breeze
image: "/comment-breeze/comment-breeze.jpg"
---

The first arguably large independent project I created was <a href="http://comment-breeze.xyz/" target="_blank">Comment Breeze</a>. I'll devote this first post to an overview of it. The <a href="https://github.com/tkonya/Comment-Breeze" target="_blank">full source code</a> is available on my GitHub.

<figure>
<img src="/comment-breeze/comment-breeze.jpg" alt="Fig 1. Comment Breeze build tab.">
<figcaption>Fig 1. Comment Breeze build tab.</figcaption>
</figure>

#### Use Case

During a time my girlfriend worked as an ESL teacher in Korea I made a tool to help her and her co-workers write report card comments for their students. They were required to write about 1 paragraph per student every 1.5 - 2 months. This would likely be mostly or all generic statements about the student's performance or progress, and only one or two specific statements if necessary. Some teachers preferred to write highly crafted comments, many didn't really care what they wrote, and the rest were somewhere in between.

<figure>
<img src="/comment-breeze/esl-reports.jpg" alt="Fig 1. ESL Reports.">
<figcaption>Fig 2. ESL Reports.</figcaption>
</figure>

#### Competitors

There were already existing sites that did this. These sites usually included up to 200 or so predefined comments, in the form of complete sentences, that were somehow categorized so that after answering some questions about the student from select boxes or radio buttons it could pull comments out of the bank and build the whole thing. The improvements I felt I could make were more comments, responsive design for mobile use and a much finer degree of granularity in the customization. I didn't 100% succeed at all of these.

#### Stack Overview

I chose Angular JS (1.5) for the front end, Angular Material to style everything, Java as the back end, and MySQL as the database. I simply chose these because I was already familiar with them, minus Angular Material. I chose Angular Material because I didn't want to spend a lot of time styling the site; Google had conveniently already built a ton of elements adhering to their material design philosophy ready to use, so I could mostly ignore the design and focus on the dirty work of coding. This all initially ran on AWS Elastic Beanstalk and RDS. After a while I decided I didn't want to continue paying the cost of those services so with some modification to the site I switched it over to static hosting on S3. The bill went from about $30 a month to under $1. I was very happy with AWS due to the ease of use, but for a site that has to date only generated donation money in the low single digits, it didn't really make sense to keep paying $30 / month.

#### Data

First I had to get data to use. I was given a large number of word documents with past report card comments on them. I wrote a <a href="https://github.com/tkonya/Comment-Breeze/blob/master/src/com/scraping/CommentFileScraper.java" target="_blank">simple scraper</a> in Java to iterate over these files, split the entire text into sentences, discard non-sentences such as headings, and replace the student's name with the a placeholder (in this case the string "STUDENT_NAME"). I made a simple POJO to hold all pertinent info about a comment during processing. I would iterate over a set of these POJOs at the end of scraping to insert them into the database in bulk with a prepared statement. I ended up with over 21,000 mostly raw comments.

At this point the data was very dirty. I wrote a <a href="https://github.com/tkonya/Comment-Breeze/blob/master/src/com/utilities/CommentUtility.java" target="_blank">utility</a> to help me clean the data. I needed to continue to remove names that weren't initially detected, remove class names, which I didn't initially realize were there, and remove duplicate sentences, which there were many of. I also wanted these comments rated as positive, neutral or negative, so I used the utility to bulk rate many of them. For instance if a sentence contained the word "wonderful" I rated that positive. Of course there are edge cases where that isn't true, but generally it is and I just wanted to get a large number of them rated to get things rolling. The site would eventually have functionality to allow users to edit the comments, including the ratings. After removing sentence fragments and duplicates the total number of usable comments came down a bit to about 20k. 

#### REST 

The interaction between the front end and the back end was your basic textbook REST API with simple CRUD operations on the database (<a href="https://github.com/tkonya/Comment-Breeze/blob/master/src/com/rest/CommentResource.java" target="_blank">source</a>). I used the Jersey library for Java to do this. By design the app fetched all 20k comments upfront. To limit the number of database operations I stored the whole comment JSON in the resource instance, it would serve this up and only refresh it either once a day or if a boolean had been set to true indicating that there was an update on the comments since the last read. 

I put a simple password in front of the ability to edit comments, which I only gave to people I knew in person. I didn't want to deal with making accounts for this site, so this was a shortcut to having some access control without all that. I built a <a href="https://github.com/tkonya/Comment-Breeze/blob/master/src/com/utilities/LockoutHandler.java" target="_blank">class</a> for keeping track of password failures and locking out repeated incorrect tries. Generally you should not try to roll your own security, but I felt the risks were extremely low, and since I didn't store any user data I felt comfortable making that executive decision. Worst case scenario somebody could maliciously edit the comments, but there was always a backup of them.

I should mention that the comment editing password and the RDS credentials were stored in a properties file that was not uploaded to GitHub. For an anecdote on how this could be really bad <a href="http://www.theregister.co.uk/2015/01/06/dev_blunder_shows_github_crawling_with_keyslurping_bots/" target="_blank">see this story</a>.


#### Feature Creep and Overhaul

The app started as a simple SPA (really it was a single page with no tabs, modals or any kind of navigation). It had inputs for student name, student gender and class name. There was an input to search for comments and a button to just produce a totally random set of comments, which proved to be a very popular feature of the site. 

Eventually I added features like working on multiple students at once, building a way to search for comments based on a set pattern, and a variation on the former that is like grading students on specific subjects. After this initial burst of features I realized that the site UI and UX were wack. I had added features organically, but I hadn't anticipated or planned for these upfront so they kind of just grew wherever. Picture taking a motorcycle and adding parts until it was a 4 seat sedan, imagine the different colored panels, the duct tape and the unfinished bondo.  

Luckily one of my girlfriend's co-workers was a UX student. We got together over coffee and talked about what was wrong with the site. In the end there was a major overhaul on the front end, but luckily most of the <a href="https://github.com/tkonya/Comment-Breeze/blob/master/web/js/main.js" target="_blank">business logic</a> that was the real guts of the site could remain. After this point the site looked a lot better, and it was much more intuitive for people to use. 

#### Business Logic

I went back to adding features to make the site more useful. The browser can store data in local storage, so I used that to save people's work in case they accidentally closed the tab. When opening the site it would look for this in storage and ask the user if they wanted to restore their last work. There is a way to export work to finish or modify later. 

One of the hardest parts of the logic was working with the English language. The site includes a way to switch between genders, so it needs to be able to modify pronouns. Say we have a sentence with "her" in it. The male form of "her" can be either "him" or "his". The female form of "his" can be either "hers" or "her". I initially had a neutral gender setting, but it proved to be too hard to implement since the neutral pronouns I was using (they, them, their) require you to sometimes change the verb tense. This is why I like programming languages: they have rules that they adhere to and they make sense. The English language is like that motorcycle-car I talked about up above except x100.

One of my favorite feature of the site is that it has multiple color themes. Angular Material made it really easy to theme the site with a custom color palette. With a moderate amount of work it's also possible to make multiple palettes and have them be user-switchable. This allowed me to keep my beloved dark theme that I liked, which was based off of the Darkula color scheme for IntelliJ, while making the default theme for the site dark on light, which I think is more popular with the general public. I also think that the ability to customize the theme forges a better relationship with the user. This and many of the other settings were held in the url, so if the user bookmarked the site with their preferred settings they could return with their settings and colors the way they had them. 

#### Mobile Performance

There's a lot of Javascript on Comment Breeze. It's by design so that after the initial page load you really don't need to communicate with the server at all anymore. This was by design, but my assumption that this would lead to better performance was incorrect, mainly due to this one thing: mobile. Turns out that running a ton of Javascript in a mobile browser on a handheld device is not that performant. I built the site to be 100% responsive; elements rearranged themselves, buttons collapsed into menus and there's even touch controls to swipe between tabs. All of this is pretty much moot since holding a JSON Array with 20k items in it and doing operations on it is relatively CPU heavy. I blame two things: the performance hit that comes with JS frameworks, and the poor performance of JS on a mobile browser. I actually don't think Comment Breeze is too complicated for a phone, I think it just is too complicated for a phone with how many layers of stuff is in between the code and the bare metal. I think a Comment Breeze native app would work just fine, but that is a project for another time. At one point I went over the whole controller and streamlined the code as much as I could. I was able to condense it and remove quite a bit of cruft, but in the end it still didn't make mobile use performant enough to satisfy me. Another option to address mobile performance would be some server-side processing, but since the site is static now that's not an option. 

#### Angular

Angular JS included a lot of magic that made this project work great, primarily the live updating of the DOM and the baked-in search and filter functionality. I love how easy it is to get started with Angular 1, just include Angular, make your controller and start writing; much easier than the way they have gone with Angular 2 requiring node. 

Angular Material was mostly pleasant to work with. It was super easy to take prebuilt
components and just stick them on the page. The documentation is great and it's very easy to make it all responsive. The site looked 95% great just with the components they made, but to get it to look exactly how I wanted I still did have to get into the weeds and hand write some CSS myself. I would definitely use Angular Material again as long as the task doesn't require it's own specific styling that contradicts material design. 

#### Misc

I used <a href="http://realfavicongenerator.net/" target="_blank">Real Favicon Generator</a> to make all the files for the site icon. It was really easy, and they show up great on the different devices I've tried the site on.

There were a couple of secret features I made that I have since disabled. One of them was seizure mode, which rapidly switched between themes. The other one was a function that would replace all characters on screen with the poop emoji. If there is enough popular demand maybe I'll bring those back. 