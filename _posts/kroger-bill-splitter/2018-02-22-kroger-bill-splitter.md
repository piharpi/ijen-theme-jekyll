---
title: Kroger Bill Splitter
date: 2018-02-22 00:00:00 +05:00
modified: 2020-06-05 00:00:00 +05:00
tags: [javascript]
description: A simple tampermonkey script to split bills on Kroger.com
image: "/kroger-bill-splitter/bill-splitter-2.PNG"
---

##### The Problem 

My girlfriend and I have been going grocery shopping together for a long time now, and it's always been a minor hassle to figure out which one of us is responsible for what part of the bill. Maybe we should just split it down the middle? The problem with that is the portion each of us is responsible for can vary quite a bit.

I first signed up for an online Kroger account because their paper receipts are sometimes very difficult to decipher. Kroger's site links up with your Kroger plus card and (after you have signed up online) you can view your detailed purchase history online, with nice long descriptions and even images for most items. 

Of course this got me thinking, since all the data is already in a computer, it is probably pretty easy for me to write something that would help split the bill.

##### The Tool: Tampermonkey

<a href="https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo" target="_blank">Tampermonkey</a> is a great Chrome extension (For Firefox see <a href="https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/" target="_blank">Greasemonkey</a>) that allows you to write Javascript that will execute on a webpage. I've written several Tampermonkey scripts to make slight modifications to websites I use a lot. I have one that helps calculate my expected pay on the time tracking software I use for my job. I've only used it for relatively simple things, but it is quite powerful. 

##### The Solution

Kroger Bill Splitter (<a href="https://github.com/tkonya/Kroger-Bill-Splitter" target="_blank">see GitHub for the code</a>) is my current bare-bones, but sufficient, way of splitting the bill. The script adds a slider to each item, it moves in 5% increments and allows you to allot a different percent financial responsibility to each item. It distributes the price of the item between each person, proportional to the percent you enter, and totals each person's portion up at the end.

<figure>
<img src="/assets/img/bill-splitter-1PNG.PNG" alt="Fig 1. Kroger bill line item, with slider.">
<figcaption>Fig 1. Kroger bill line item, with slider.</figcaption>
</figure>

Above you can see what a single line item looks like. The boxed portion at the lower right is what the script adds. Clicking on the percentage on either side moves the slider all the way to one side or another, since most of the time we are either splitting something 50/50 or one of us is fully paying for it. It is uncommon that we do anything other than that, but sometimes (like with this single microwavable burrito) we may be splitting it asymmetrically. 

<figure>
<img src="/assets/img/bill-splitter-2.PNG" alt="Fig 2. Kroger bill splitter totals">
<figcaption>Fig 2. Kroger bill splitter totals</figcaption>
</figure>

In the above image you can see what the end of the receipt looks like. The totals are shown as "Left Total" and "Right Total", this aligns with whichever way you moved the sliders for each line item. The tax is split proportionally, according to the subtotal amounts that each person is responsible for. This is the best I can do at this time because Kroger does not indicate which items were taxed on these receipts. 

##### Possible Future Improvements

A great way to improve this would be to make a standardized website or extension that could split bills. It would allow the user to enter in items manually, or have the ability to import bills from various sources. So for instance there would be a module that could export the Kroger bill to some standardized JSON, and then the site/extension would be able to read that and do all the bill splitting. Of course this would all be done behind the scenes, the user shouldn't have to know, nor care what JSON is. 

Chrome currently has the ability to take a full-size screenshot, but adding some other way to export the bill for record keeping may be beneficial to some people. Just a nice concise email summary or something like that. 

The ability to split the bill more than two ways would be complicated. I think at that point I would need to add the ability to store the names of the people splitting the bill.