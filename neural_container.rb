require_relative 'menu_commands'
module DapperNeural
  extend Discordrb::Commands::CommandContainer

  command :SaveChannelData do |event|
    past_mes = event.channel.history(100)
    past_mes.map {|mes| "#{mes.author.username}: #{mes.content}"}
    puts past_mes
  end

end
