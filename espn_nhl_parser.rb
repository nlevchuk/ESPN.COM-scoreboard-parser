require 'rubygems'
require 'nokogiri'
require 'open-uri'

games = []
url = "http://espn.go.com/nhl/scoreboard"
doc = Nokogiri::HTML(open(url))

doc.css("div.game-header").each do |gametable|          # gametable - html table of current game
   unless gametable.at_css("tr td div a").nil?           # if game not started then skip 
     teams = []
     score = []
     gametable.css("tr td div a").each do |team_name|     # Searching two team names (for away and home teams)
       teams << team_name.text
     end
     away, home = teams
     gametable.css("td.team-score").each do |team_score|  # Need to find two scores per game (for away and home teams)
       score << team_score.text
     end
     result = "#{score[1]}:#{score[0]}"                   # Away team - Home team
     game_info = gametable.at_css("ul.game-info li").text 
     game = "#{home}-#{away} #{result} #{game_info}"
     games << game
   end # unless
end # each

if games.empty?
  puts "Today no games"
else
  puts games
end  
