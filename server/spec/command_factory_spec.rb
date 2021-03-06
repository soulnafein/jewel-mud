require "spec/spec_helper"

describe CommandFactory do
  before :each do
    @game = mock.as_null_object
    @command_factory = CommandFactory.new(@game)
    @character = stub.as_null_object
  end

  it "should build a command from the input's first word" do
    input = "say Hello there!"
    
    command = @command_factory.parse(input, @character)

    command.class.should == SayCommand
    command.message.should == "Hello there!"
  end

  it "should ignore case" do
    input = "lOoK spider"

    command = @command_factory.parse(input, @character)

    command.class.should == LookCommand
  end

  it "should ignore command names appearing in other contexts" do
    input = "say you should LOOK carefully"

    command = @command_factory.parse(input, @character)

    command.class.should == SayCommand
    command.message.should == "you should LOOK carefully"
  end

  it "should check if the command is an alias" do
    @command_factory.aliases = { "e" => "go east", "l" => "look"}
    input = "e"

    command = @command_factory.parse(input, @character)

    command.class.should == GoCommand
    command.exit.should == "east"
  end

  it "should create a NoCommandFound object when passing an invalid comamnd" do
    input = "xyz whatever"

    command = @command_factory.parse(input, @character)

    command.class.should == NoCommandFound
  end

  it "should create a DoNothing object when empty input" do
    input = ""

    command = @command_factory.parse(input, @character)

    command.class.should == DoNothing
  end
end