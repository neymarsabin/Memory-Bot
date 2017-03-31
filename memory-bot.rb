#!/usr/bin/env ruby
require 'telegram/bot'
require './token_module.rb'
require 'mongo'

# the movie database connection
# Tmdb::Api.key(TokenValue::TOKENTMDB)

# starting a connection
#db = Mongo::Client.new(['127.0.0.1:27017'], :database => 'movies')
#client = Mongo::Client.new('mongodb://127.0.0.1:27017/movies')
# connecting to mlab.com's mongodb database 
client = Mongo::Client.new('mongodb://neymar:neymar@ds153657.mlab.com:53657/movies')
# accessing client database 
db = client.database

# db.collections
# db.collection_names
# connecting to movies collection 
collection=client[:movies]
# first_name = collection.find({:title => "Seven Samurai"}, { :projection => {:_id => 0,:title => 1} })
# first_name.each do |title|
#   MOVIE_NAME = title
#   puts movie_name
# end 
#variables
token=TokenValue::TOKEN

# getting ip address from regex
def get_ip(message)
  message[/([\d.]+|(?:https?:\/\/)?(?:[\w]+\.)?[\w]+\.[\w]+)/]
end 

# calling the make connection function
make_connection_with_ipinfodb

def get_info(address,type)
  return 'Error cannot find, Address is invalid' unless address
  data = ''
  make_connection_with_ipinfodb.lookup(address, type: type).map do |e|
    data << e.first.to_s.gsub('/_/',' ').capitalize + ': ' + e.last + "\n"
  end
  data
end 


Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello,welcome  #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye take care, #{message.from.first_name}")
    when '/memory'
      memory = %x(free).split(" ")[8].to_i / 1024
      bot.api.send_message(chat_id: message.chat.id, text: " Total Memory Usage: , #{memory} Mb, #{message.from.first_name}")
    # when '/movie'
    #   # mongodb query to get the hashes
    #   first_name = collection.find({:title => "Seven Samurai"}, { :projection => {:_id => 0,:title => 1,:release_year => 1, :description => 1}})
    #   first_name.each do |title|
    #     bot.api.send_message(chat_id: message.chat.id, text: "movie: #{title['title']} :::::: release date: #{title['release_year']} ::::description: #{title['description']}")
    #   end
    when /\/city [\w\W]+/
      bot.api.send_message(chat_id: message.chat.id, text: get_info(get_ip(message.text),'city'))
    else
      bot.api.send_message(chat_id: message.chat.id, text: "What do you mean? I don't quite understand that:::")
    end
  end
end 







