require 'monitor.rb'

class CommandManager
  def initialize()
    @commands = []
    @commands.extend(MonitorMixin)
    @empty_cond = @commands.new_cond
  end

  def add_command(command)
    @commands.synchronize do
      @commands.push(command)
      @empty_cond.signal
    end
  end

  def get_command
    @commands.synchronize do
      @empty_cond.wait_while { @commands.empty? }
      @commands.shift
    end
  end

  def process_commands
    command = get_command
    command.execute
  end

end
