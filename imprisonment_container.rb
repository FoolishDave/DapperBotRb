require 'configatron'
require_relative 'config'
module ImprisonmentContainer
  extend Discordrb::Commands::CommandContainer

  
  
  command :test do |event|
    wat
  end

  command :VoteImprison, description: 'Starts a vote to send someone to the gulag.', permission_level: 5 do |event, person|
    accused = event.server.member person[/\d+/]
    if jail_times.key? person
      response = event.send_message "Think #{person} said something stupid? They're currently in the gulag for#{secs_to_countdown(Time.parse(jail_times[accused.username]) - Time.now)}. Should they be in there for longer? Voting ends in 5 minutes!"
    else
      response = event.send_message "Think #{person} said something stupid? They're not currently in the gulag. Should they be imprisoned? Voting ends in 5 minutes!"
    end
    response.create_reaction('✔')
    response.create_reaction('✖')
    voting_thread = Thread.new{countdown_to_voting(Time.now+2,response,accused)}
    ''
  end

  command :RemainingImprisonment do |event, *args|
    if args.empty?
      if jail_times[event.user.username]
        "#{event.user.mention}, you have#{secs_to_countdown(Time.parse(jail_times[event.user.username]) - Time.now)} left on your sentence."
      else
        "#{event.user.mention}, you are not currently sentenced to the gulag. Keep it that way."
      end
    else
      accused = event.server.member args.first[/\d+/]
      puts accused.username
      if jail_times[accused.username]
        "#{accused.mention}, has#{secs_to_countdown(Time.parse(jail_times[accused.username]). - Time.now)} left on their sentence."
      else
        "#{accused.mention}, is not currently sentenced to the gulag."
      end
    end
  end

  command :Release, permission_level: 10 do |event, person|
    released = event.server.member person[/\d+/]
    if jail_times[released.username]
      released.remove_role(event.channel.server.role configatron.jail_role)
      puts normal_role = configatron.normal_role
      released.add_role(normal_role)
      old_sentence = secs_to_countdown(Time.parse(jail_times[released.username]) - Time.now)
      jail_times.delete(released.username)
      save_jail_times
      "#{released.mention} has been released from the gulag#{old_sentence} early."
    else
      "#{released.mention} is not imprisoned. If you want them to be, use !StartImprison"
    end
  end
end
