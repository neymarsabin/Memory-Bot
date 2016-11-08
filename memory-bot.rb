
#!/usr/bin/env ruby
require 'telegram/bot'

#variables
token='272157126:AAEqB9XXBz3aKR9x3GxRs9yqB1Nx8o1SFqs'

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
    else
      bot.api.send_message(chat_id: message.chat.id, text: "What do you mean? I don't quite understand that:::")
    end
  end
end 

