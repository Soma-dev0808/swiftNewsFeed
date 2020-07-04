# swiftNewsFeed

<img src="https://user-images.githubusercontent.com/55787141/86504514-d6fb9e80-bdeb-11ea-9bab-fc206ff0531d.png" width="80" height="80"> News feed for iOS application

This application provides cuurent trending news and allows take a look at them.

## Why created this app

This app was mainly created to show my skill in mobile development, and acquire great opportunity to work in iOS development industry.

I've been working as web developer for 1yr anf half, and as mobile developer for half year. After some of experience with mobile development, I noticed that I'm more interested in mobile, therefore decided to focus working on it especially Swift. 

This app was developed after watching of some tutorials to have fundamental skills for Swift. 

The duration of developing this application is 3days(7 hrs of work per day)

I have also created a map [applications](https://github.com/Soma-dev0808/swiftNewsFeed)
, so if you are interested, please check it.

 

## UI Design

<img src="https://user-images.githubusercontent.com/55787141/86504575-728d0f00-bdec-11ea-8033-c0bd75d75f27.png" width="700" height="600"> 

In this app, since the purpose of creating this app is showing my mobile developing skill, so UI wasn't prioritized this time.

## What technology I used

* Swift
* News Fetch API(Algolia.com Api, Yahoo News Api, Newsapi.org)
* Realm (Save New List)

## Structure of this app

<img src="https://user-images.githubusercontent.com/55787141/86504588-baac3180-bdec-11ea-8bea-b41fcc4f06b1.png" width="950" height="600"> 

This app was developed based on MVC. View will show UI, and Controller handle actions such as user input and page navigation. Model will fetch data and provide some methods to handle converting data.

For the navigation of app is using Navigation Controller to make it smooth to navigate pages.

## Features

* Choose New Category
* Search New by Keyword
* Display News List
* Display Selected News
* Save News
* Display Saved News

## To test this application

Please clone this application, and try to run

*pod deintegrate
*pod install

then you can already build it

## License
[MIT](https://github.com/Soma-dev0808/swiftNewsFeed/blob/master/LICENSE)
