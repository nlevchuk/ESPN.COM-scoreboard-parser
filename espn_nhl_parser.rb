require 'rubygems'
require 'nokogiri'
require 'open-uri'

games = []
url = "http://espn.go.com/nhl/scoreboard"
doc = Nokogiri::HTML(open(url))

doc.css("div.game-header").each do |gametable|          # gametable - html table of current game
   unless gametable.at_css("tr.loser a").nil?           # if game not started
     game_info = gametable.at_css("ul.game-info li").text.scan(/OT|SO/).to_s
     loser = gametable.at_css("tr.loser a").text
     winner = gametable.at_css("tr.winner a").text
     winner_place = gametable.at_css("tr.winner")[:id].scan(/home|away/)
     score = []
     gametable.css("td.team-score").each do |team_score|  # Need to find two scores per game (for away and home teams)
       score << team_score.text
     end  
     result = "#{score[1]}:#{score[0]}"                   # Away team - Home team
     if winner_place.to_s == "home"
       game = "#{winner}-#{loser} #{result} #{game_info}"
     else
       game = "#{loser}-#{winner} #{result} #{game_info}"
     end
     games << game
   end # unless`  
end # each

if games.empty?
  puts "Today no played games"
else
  puts games
end  
