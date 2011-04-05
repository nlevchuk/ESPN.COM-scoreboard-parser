require 'rubygems'
require 'nokogiri'
require 'open-uri'

games = []
url = "http://m.espn.go.com/nhl/scoreboard?date=20110403"
doc = Nokogiri::HTML(open(url))

doc.css("div div a").each do |item|          # gametable - html table of current game
  game = item.text
  games << game
end
puts games
