require 'os'
::RBNACL_LIBSODIUM_GEM_LIB_PATH = "c:/libsodium/libsodium.dll" if OS.windows?
require 'discordrb'
require 'twitter'
require 'configatron'
require_relative 'config'
require_relative 'command_container'
require_relative 'event_container'
require_relative 'voice_container'
require_relative 'imprisonment_container'
def tweet(mes)
  if mes.length > 140
    puts 'could not tweet, too many characters in: ' + mes
    return nil
  else
    return $twitter_client.update(mes)
  end
end

def jail_times
  unless @jail_times
    File.open('jail.json','a+') do |file|
      file_content = file.read
      file_content = '{}' and file << '{}' if file_content.empty?
      @jail_times = JSON.parse file_content

    end
  end
  @jail_times
end

def jail_times=(jail_times)
  @jail_times = jail_times
  File.open('jail.json','w') do |file|
    file.write @jail_times.to_json
  end
end

def save_jail_times
  File.open('jail.json','w') do |file|
    file.write jail_times.to_json
  end
end

def secs_to_countdown(secs)
  seconds = (secs).floor
  minutes = (seconds / 60).floor
  hours = (minutes / 60).floor
  days = (hours / 24).floor
  time = ''
  time += " #{days} days," if days >= 1
  time += " #{hours - days*24} hours," if hours >= 1
  time += " #{minutes - hours*60} minutes," if minutes >= 1
  time += " #{seconds - minutes*60} seconds"
end

def countdown_to_voting(end_time,message,accused)
  last_edit = Time.now.to_i - 300000
  until Time.now > end_time
    message.edit(message.content.sub(/Voting ends in [\w\s]*/, "Voting ends in#{secs_to_countdown((end_time - Time.now).to_i)}"))
    last_edit = Time.now.to_i
    sleep(2)
  end
  reactions = message.channel.load_message(message.id).reactions

  yes_votes = reactions['✔'].count
  no_votes = reactions['✖'].count
  message.edit("Voting ended with #{yes_votes} yes votes and #{no_votes} no votes.")
  do_punishment(accused,message)
end

def do_punishment(accused,message)
  if jail_times.key? accused.username
    message.channel.send_message("#{accused.mention}, your stay in the gulag has been increased by 1 hour. You monster.") if jail_times.key? accused.username
    jail_times[accused.username] = (Time.parse(jail_times[accused.username]) + 3600).to_s
  else
    message.channel.send_message("#{accused.mention}, you have been sentenced to 1 hour in the gulag. May god have mercy on your soul.")
    accused.add_role (configatron.jail_role)
    accused.remove_role (message.channel.server.role configatron.normal_role)
    jail_times[accused.username] = (Time.now + 3600).to_s
  end
  save_jail_times
end


$jordan_channel = false
$twitter_client = Twitter::REST::Client.new({:consumer_key => configatron.twitter_cons_key, :consumer_secret => configatron.twitter_cons_sec, :access_token => configatron.twitter_token, :access_token_secret => configatron.twitter_token_sec})

bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: 172421632223084545, :prefix => configatron.prefixes, :spaces_allowed => true
bot.include! DapperEvents
bot.include! DapperCommands
bot.include! DapperVoice
bot.include! ImprisonmentContainer
bot.run
