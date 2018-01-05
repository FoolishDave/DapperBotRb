require_relative 'menu_commands'
module DapperCommands
  extend Discordrb::Commands::CommandContainer

  command :methodtest do |event|
    DapperCommands.testing
  end

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

  command :SaveChannelData do |event,*args|
    data_file = "C:\\Users\\ddogc\\AppData\\Local\\lxss\\home\\dgrougan\\rnn\\data\\train_data.txt"
    past_mes = event.channel.history(100)
    oldest = past_mes.last
    past_mes.map! {|mes| "#{mes.author.username}: #{mes.content}"}
    File.open("C:\\Users\\ddogc\\AppData\\Local\\lxss\\home\\dgrougan\\rnn\\data\\train_data.txt",'a') {|file| file.write(past_mes.to_s)}
    while File.size(data_file).to_f / 1024000 < (args[0].to_f || 1.5)
      past_mes = event.channel.history(100,oldest.id)
      oldest = past_mes.last
      past_mes.map! {|mes| "#{mes.author.username}: #{mes.content}"}
      File.open("C:\\Users\\ddogc\\AppData\\Local\\lxss\\home\\dgrougan\\rnn\\data\\train_data.txt",'a') {|file| file.write(past_mes.to_s)}
    end
    'Done'
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
    member = event.server.member(person.join(' ')[/\d+/].to_i)
    if member
      callout = member.nick || member.username
    else
      callout = person.join(' ')
    end

    twitter_message = "#{(event.user.nick || event.user.username)} of the server #{event.server.name} would like to declare #{callout} gay."
    the_tweet = tweet(twitter_message)
    event.user.mention + " thinks that " + person.join(' ') + " is gay.\n#{the_tweet.uri}"
  end

  command :RoleCmdLvl, permission_level: 9001, permission_message: 'GIT OUT FAGGOT' do |event, role_name, level|
    roles = event.channel.server.roles
    role = roles.find{|rol| rol.name == role_name}
    event.bot.set_role_permission(role.id,level.to_i)
  end

  command :eval, permission_level: 9001, permission_messasge: "Don't use this please." do |event, evaluate_me|
    eval evaluate_me
  end

  command :TestMenu do |event|
    commands = {}
    event_mes = event.send_message '*Test Menu*'
    commands['😀'] = Proc.new{|pr_message| puts '😀'; pr_message.message.edit("*Test Menu*\n😀")}
    commands['😐'] = Proc.new{|pr_message| puts '😐'; pr_message.message.edit("*Test Menu*\n😐")}
    MenuCommands.create_menu(event_mes,commands)
  end
  
  command :exit do |event|
    save_points
    exit
  end
end