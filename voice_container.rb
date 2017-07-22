require 'open3'
require 'video_info'
require 'os'
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
    event << 'Yeah attempting to play that shit.'
    if url.end_with? '.mp3'
      event.voice.play_file(url)
    else

      $twitter_client.update("#{event.user.nick || event.user.username} thinks they're a great DJ playing #{VideoInfo.new(url).title} in the server #{event.server.name}")
      if OS.windows?
        stdin,stdout,wt_thr = Open3.popen2("youtube-dl -f 251 #{url} -o -")
        event.voice.play_io(stdout)
      else
        stdin,stdout,wt_thr = Open3.popen2("/usr/local/bin/youtube-dl -f 251 #{url} -o -")
        command = "ffmpeg -loglevel 0 -i - -f s161e -ar 48000 -ac 2 #{event.voice.encoder.filter_volume_argument} pipe:1"
        ret_io, writer = IO.pipe
        spawn(command, in: stdout, out:writer)
        event.voice.play ret_io
      end
    end
  end

  command :volume do |event, vol|
    event.voice.volume = vol.to_f / 100.0;
  end

  command :play_file do |event, file|
    event << 'Fine.'
    event.voice.play_file(file)
  end

end
