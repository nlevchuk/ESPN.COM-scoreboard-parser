require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'timeout'

page = nil
games = []
url = "http://m.espn.go.com/nhl/scoreboard?date=20110403"
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
  page.css("div div a").each do |item|          # gametable - html table of current game
    game = item.text
    games << game
  end
  puts games
end
