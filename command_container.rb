module DapperCommands
  extend Discordrb::Commands::CommandContainer

  command :lewd do |event|
    event << 'You fucking whore.'
    event << 'You think this is funny?'
    event << 'Why do you enjoy oggling anime girls while masking your perversion as a joke?'
    event << "I'm sick of you."
    event << 'You disgust me.'
    mes = event.message
    mes.react('🇨')
    mes.react('🇺')
    mes.react('🇳')
    mes.react('🇹')
  end

  command :prefixes do |event|
    event.bot.prefix.each{|prefix| event << "#{prefix} COMMAND"}
    puts event.bot.prefix
  end

  command :AddPrefix do |event, *args|
   event.bot.prefix << args.first
    nil
  end

  command :SetPlaying do |event, *args|
    event.bot.update_status 'Online', args.join(' '), nil, 0, false
  end

  command :gay do |event|
    $twitter_client.update((event.user.nick || event.user.username) + ' of the server ' + event.server.name + ' would like to inform the world that they are gay.')
    event.user.mention + ' is gay.'
  end

  command :InviteURL do |event|
    event.bot.invite_url
  end

  command :CommandAlias do |event, *args|
    event.bot.commands[args[1].to_sym] = event.bot.commands[args[0].to_sym]
  end

  command :invite do |event, person, *args|
    "Hey #{person} you fucker #{event.user.mention} wants you to get the fuck in here to #{args.join(' ')}."
  end

  command :DeclareGay do |event, *person|
    twitter_message = "#{(event.user.nick || event.user.username)} of the server #{event.server.name} would like to declare #{person.join(' ')} gay."
    the_tweet = tweet(twitter_message)
    event.user.mention + " thinks that " + person.join(' ') + " is gay.\n#{the_tweet.uri}"
  end

  command :RoleCmdLvl, permission_level: 9001, permission_message: 'GIT OUT FAGGOT' do |event, role_name, level|
    roles = event.channel.server.roles
    role = roles.find{|rol| rol.name == role_name}
    event.bot.set_role_permission(role.id,level.to_i)
  end
end