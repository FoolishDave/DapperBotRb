module DapperPoints
  extend Discordrb::Commands::CommandContainer
  
  command :pointshelp do |event|
    event << 'Measure up to your friends with Dapper Bot Points!'
  end
  
  command :awardpoints, permission_level: 5 do |event, *args|
    servid = event.channel.server.id
    user = event.server.member args[0][/\d+/]
    amt = Integer(args[1])
    modify_points(servid.to_s,user.id.to_s,amt)
    "#{user.mention} has been awarded with #{amt} #{pointname servid.to_s}"
  end
  
  command :givepoints do |event, *args|
    servid = event.channel.server.id
    sendinguser = event.user
    receivinguser = event.server.member(args[0][/\d+/])
    amt = Integer(args[1])
    if (sendinguser.id == receivinguser.id)
      event << "Ok.. but why?"
    end
    puts "#{sendinguser.mention} sending #{amt} points to #{receivinguser.mention}"
    if get_points(servid.to_s, sendinguser.id.to_s) < amt
      event << "Sorry #{sendinguser.mention}, you don't have that many points to give!"
    else
      if amt < 0
        event << "Stealing is wrong #{sendinguser.mention}."
      else
        modify_points(servid.to_s,receivinguser.id.to_s,amt)
        modify_points(servid.to_s,sendinguser.id.to_s,amt*-1)
        "#{sendinguser.mention} has given #{receivinguser.mention} #{amt} #{pointname servid.to_s}"
      end
    end
  end
  
  command :points do |event, *args|
    servid = event.channel.server.id
    args.empty? ? user = event.user : user = event.server.member(args[0][/\d+/])
    points = get_points(servid.to_s, user.id.to_s)
    "#{user.mention} has #{points} #{pointname servid.to_s}."
  end
  
  command :setpointname do |event, *name|
    set_pointname(event.channel.server.id.to_s,name.join(' '))
    "Point name set to #{name.join(' ')}"
  end
  
  command :buygems do |event|
    event.channel.send_embed do |embed|
      embed.title = 'Buy Gems!'
      embed.description = "Want to up your discord game? Buy Dapper Gems to earn more points and show you're clearly superior to your plebian friends."
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url:"http://stemgemsbook.com/wp-content/uploads/2016/03/pink-gem.png")
      embed.add_field(name: 'Game Changer (1 Gem)', value: '$1 [Click Here](https://paypal.me/FoolishDave/1)')
      embed.add_field(name: 'Power Play (5 Gems)', value: '$4 [Click Here](https://paypal.me/FoolishDave/4) ($1 OFF!)')
      embed.add_field(name: 'Insane in the Membrane (25 Gems)', value: '$19.99 [Click Here](https://paypal.me/FoolishDave/20) ($5 OFF!)')
      embed.add_field(name: 'Ludicrous Mode (100 Gems)', value: '$90 [Click Here](https://paypal.me/FoolishDave/90) ($10 OFF!)')
      embed.add_field(name: 'PUSSY DESTROYER (10k Gems)', value: '$9000 [Click Here](https://paypal.me/FoolishDave/9000) ($1000 OFF! BEST DEAL!)')
    end
  end
  
  command :pointsleaderboard do |event|
    points = get_sorted_server_points(event.channel.server.id.to_s)
    if points.empty?
      event << 'Nobody on your server has any points! Start earnin!'
    else
      desc = ''
      event.channel.send_embed do |embed|
        embed.title = "#{pointname event.channel.server.id.to_s} Leaderboard"
        i = 1
        points.each do |userid, value|
          desc += "**#{i}. #{event.channel.server.member(userid).display_name}: #{value}**\n"
          i+=1
        end
        embed.description = desc
        imageurl = event.channel.server.member(points.first[0]).avatar_url
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: imageurl)
        embed.color = '0xff0000'
      end
    end
  end
end
