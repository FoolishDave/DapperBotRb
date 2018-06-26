require 'discordrb'
class MenuCommands
  @@open_menus = Hash.new

  def self.create_menu(message,menu_options)
    menu_options.keys.each{|key| message.create_reaction key}
    @@open_menus[message.id] = menu_options
  end

  def self.execute_command(event, option)
    puts 'executing command for ' + option
    puts event.message.id
    puts @@open_menus[event.message.id]
    if @@open_menus[event.message.id]
      if @@open_menus[event.message.id][option]
        @@open_menus[event.message.id][option].call(event)
        event.message.delete_reaction(event.user,event.emoji.name)
      end
    end
  end
end