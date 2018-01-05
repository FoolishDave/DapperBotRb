require_relative 'menu_commands'
module DapperEvents
  extend Discordrb::EventContainer

  ready do |event|
    load_points
    event.bot.update_status('online','twitter.com/TheDapperBot','https://twitter.com/TheDapperBot')
    event.bot.set_user_permission(130151971431776256,9001)
    point_thread = Thread.new {
      while true do
        distribute_points event.bot
        sleep 3600
      end
    }
    
    point_save_thread = Thread.new {
      while true do
        save_points
        sleep 1800
      end
    }
  end

  reaction_add do |reaction_event|
    MenuCommands.execute_command(reaction_event,reaction_event.emoji.name) unless reaction_event.user.id == 172421632223084545
  end

  message do |message_event|

    mes = message_event.message.content
    if mes == 'what' || mes == 'What' || mes == 'what?' || mes == 'What?'
      message_event.channel.send_message('Chicken Butt')
    elsif mes == 'wat' || mes == 'Wat' || mes == 'wat?' || mes == 'Wat?'
      message_event.channel.send_message('Chicken Bat')
    elsif mes == 'when' || mes == 'When' || mes == 'when?' || mes == 'When?'
      message_event.channel.send_message('Chicken Pen')
    elsif mes == 'where' || mes == 'Where' || mes == 'where?' || mes == 'Where?'
      message_event.channel.send_message('Chicken Hair')
    elsif mes == 'why' || mes == 'Why' || mes == 'why?' || mes == 'Why?'
      message_event.channel.send_message('Chicken Thigh')
    elsif mes == 'WHAT' || mes == 'WHAT?'
      message_event.channel.send_message('CHICKEN BUTT')
    elsif mes == 'WAT' || mes == 'WAT?'
      message_event.channel.send_message('CHICKEN BAT')
    elsif mes == 'WHEN' || mes == 'WHEN?'
      message_event.channel.send_message('CHICKEN PEN')
    elsif mes == 'WHERE' || mes == 'WHERE?'
      message_event.channel.send_message('CHICKEN HAIR')
    elsif mes == 'WHY' || mes == 'WHY?'
      message_event.channel.send_message('CHICKEN THIGH')
    end

    #if message_event.author.username == 'astrocaye5' && Time.now.hour < 6
    #  unless $delay && Time.now.to_i - $delay.to_i < 120
    #    puts Time.now.to_i - $delay.to_i if $delay
    #    message_event.channel.send_message("#{message_event.author.mention} GO TO BED.")
    #    $delay = Time.now
    #  end
    #  message_event.author.pm 'GO TO BED.'
    #end
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
