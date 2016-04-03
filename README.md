# Twitter spelling script
### How to run the script
The script is written in ruby and I tested it with ruby version 2.0.0
It uses the following API and libraries
- API: Twitter search/tweets API
- Libraries:
     - OAuth
     - JSON
     - FFI-Aspell (wrapper for Aspell)
     
To run the script you need to install the spell checking program Aspell:
 - On Mac OS X just install with brew `$ brew install aspell`
 - On Linux see [aspell.net](www.aspell.net) 
 - Unfortunately, it does not seem to work on Windows
 
Use bundler to install the dependencies and execute the script with `$ ruby twitter_spelling.rb`
### Result and analysis
The script gives the following result:

_Twitter users in Exeter have a score of 90.18345728345729 while Twitter users in London only have a score of 87.16818669484108._

This shows that the Twitter users in Exeter have a slightly better score than the Twitter users in London.
The location is set by longitute and letidude of the city centers with a radius of 3km for Exeter and a radius of 10km for London. For simplicity reasons the amount of tweets for the calculation is set to 100 tweets.

I assume that there are four kind of words in a tweet: 
 - _correctly spelled words_: words which are spelled correctly according to the spelling program I use
 - _incorrectly spelled words_: words which are spelled incorrectly according to the spelling program I use
 - _invalid words_: words which contain the Twitter specific characters and strings #, @ and http
 - _valid words_: all words in a tweet which don't contain # or @ characters or the http string
 
The score of one single tweet is calculated by the sum of correctly spelled words devided by valid words.
The overall score is calculated by the sum of all single tweet scores devided by the number of tweets.

To get a more signifnicant result the amount of tweets would need to be increased .