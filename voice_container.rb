require 'open3'
require 'video_info'
require 'os'
require_relative 'menu_commands'
module DapperVoice
  extend Discordrb::EventContainer
  extend Discordrb::Commands::CommandContainer

  command :join do |event|
    voice_channel = event.user.voice_channel
    next "Hey stupid, you're not in a voice channel." unless voice_channel
    event.bot.voice_connect(voice_channel)
    event.bot.voice(voice_channel).volume = 0.3
    "Connected to voice: #{voice_channel.name}"
  end

  command :play do |event, url|
    # event << 'Yeah attempting to play that shit.'
    if url.end_with? '.mp3'
      event.voice.play_file(url)
    else

      $twitter_client.update("#{event.user.nick || event.user.username} thinks they're a great DJ playing #{VideoInfo.new(url).title} in the server #{event.server.name}")
      if OS.windows?
        stdin,stdout,wt_thr = Open3.popen2("youtube-dl -f 251 #{url} -o -")
        event.voice.play_io(stdout)
      else
        stdin,stdout,wt_thr = Open3.popen2("/usr/local/bin/youtube-dl -f 251 #{url} -o -")
        event.voice.play_io stdout
      end
    end
  end

  command :volume do |event, vol|
    event.voice.volume = vol.to_f / 100.0;
  end

  command :stop do |event|

  end

  command :FastForward do |event, seconds|
    event.voice.skip(seconds.to_i)
  end

  command :Pause do |event|
    event.voice.pause
  end

  command :Resume do |event|
    event.voice.continue
  end

  command :Stop do |event|
    event.voice.stop_playing
  end

  command :play_file do |event, file|
    event << 'Fine.'
    event.voice.play_file(file)
  end

  command :MediaControls do |event|
    commands = {}
    event_mes = event.send_message '**Media Controls**'
    commands['🔉'] = Proc.new{|pr_event| bot.voice.volume -= 0.1; bot.voice.volume = 0.0 if bot.voice.volume < 0.0; pr_event.send_message 'Volume at ' + (bot.voice.volume*100).to_s + '%'}
    commands['🔊'] = Proc.new{|pr_event| bot.voice.volume += 0.1;  bot.voice.volume = 1.0 if bot.voice.volume > 1.0; pr_event.send_message 'Volume at ' + (bot.voice.volume*100).to_s + '%'}
    MenuCommands.create_menu(event_mes,commands)
  end

  command :NANI do |event|
    voice_channel = event.user.voice_channel
    next unless voice_channel
    event.bot.voice_connect(voice_channel)
    event.bot.voice(voice_channel).volume = 0.25

    event.voice.play_file('nani.mp3')
    event.voice.destroy
    'You are already dead.'
  end
end