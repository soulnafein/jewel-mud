class CommandManager
  def initialize()
    @commands = []
    @mutex = Mutex.new
  end

  def add_command(command)
    @mutex.synchronize do
      @commands.push(command)
    end
  end

  def get_command
    @mutex.synchronize do
      @commands.shift
    end
  end

  def process_commands
    command = get_command
    return if command.nil?
    command.execute
  end

end
