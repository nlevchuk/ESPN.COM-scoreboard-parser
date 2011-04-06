require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'timeout' 
 
page = nil
games = []
url = "http://espn.go.com/nhl/scoreboard"                   # fetch URL
begin
  timeout(60) do                                            # Exit after 60 seconds
    while page.nil? do                                      # and if internet connection not work
      begin                                                 # then loops after every 10 seconds
        page = Nokogiri::HTML(open(url))
      rescue OpenURI::HTTPError,SocketError
        sleep 5                                             # sleep 5 seconds
      end 
    end 
  end 
rescue Timeout::Error
  puts "Internet connection problems"
else  
  page.css("div.game-header").each do |gametable|           # gametable - html table of current game
    unless gametable.at_css("tr td div a").nil?             # if game not started then skip 
      teams = []
      score = []
      gametable.css("tr td div a").each do |team_name|      # Searching two team names (for away and home teams)
        teams << team_name.text
      end
      away, home = teams
      gametable.css("td.team-score").each do |team_score|   # Need to find two scores per game (for away and home teams)
        score << team_score.text
      end
      result = "#{score[1]}:#{score[0]}"                    # Away team - Home team
      game_info = gametable.at_css("ul.game-info li").text.scan(/Final|OT|SO/) 
      game = "#{home}-#{away} #{result} #{game_info}"
      games << game
    end # unless
  end # each

  if games.empty?
    puts "Today no games"
  else
    puts games
  end
end #else
