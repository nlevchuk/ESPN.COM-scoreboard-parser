require 'rubygems'
require 'nokogiri'
require 'open-uri'

games = []
url = "http://espn.go.com/nhl/scoreboard"
doc = Nokogiri::HTML(open(url))
doc.css("div.game-header").each do |gametable|
   loser = gametable.at_css("tr.loser a").text
   winner = gametable.at_css("tr.winner a").text
   winner_place = gametable.at_css("tr.winner")[:id].scan(/home|away/)
   score = []
   gametable.css("td.team-score").each do |team_score|
     score << team_score.text
   end  
   score_of_game = score[1] + ':' + score[0]
   if winner_place.to_s == "home"
     game = "#{winner}-#{loser} #{score_of_game}"
   else
     game = "#{loser}-#{winner} #{score_of_game}"
   end
   games << game
end

puts games
