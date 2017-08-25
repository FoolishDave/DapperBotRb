require_relative 'menu_commands'
module DapperEvents
  extend Discordrb::EventContainer

  ready do |event|
    event.bot.update_status('online','twitter.com/TheDapperBot','https://twitter.com/TheDapperBot')
    event.bot.set_user_permission(130151971431776256,9001)
  end

  reaction_add do |reaction_event|
    MenuCommands.execute_command(reaction_event,reaction_event.emoji.name) unless reaction_event.user.id == 172421632223084545
  end

  message do |message_event|
    #bot.update_status 'Online', '🇹 🇴 🇵   🇰 🇪 🇰', nil, 0, false
    unless message_event.message.embeds.empty?
      repost_count = 0
      history = message_event.channel.history(100)
      message_event.message.embeds.each do |embed|
        history.each do |message|
          repost_count += 1 if message.embeds.any?{|mes_embed| mes_embed.url == embed.url}
        end
      end
      spam_mes = message_event.channel.send_message("#{message_event.message.author.mention} is a reposting whore. That link was already posted #{repost_count} times within the last 100 posts.") if repost_count > 1
      $twitter_client.update("#{message_event.user.nick} of the #{message_event.server.name} server is a dirty reposter. Shame.") if repost_count > 1
      if spam_mes
        message = rand(3)
        case message
          when 0
            spam_mes.react('🇬')
            spam_mes.react('🇦')
            spam_mes.react('🇾')
          when 1
            spam_mes.react('🇫')
            spam_mes.react('🇦')
            spam_mes.react('🇬')
          when 2
            spam_mes.react('🇨')
            spam_mes.react('🇺')
            spam_mes.react('🇳')
            spam_mes.react('🇹')
        end


      end
    end
  end

end