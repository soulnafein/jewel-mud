class Event
  attr_accessor :from, :to, :kind, :args

  def initialize(from, to, kind, args)
    @from, @to, @kind, @args = from, to, kind, args
  end
end
