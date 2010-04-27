class Event
  attr_accessor :from, :to, :kind, :args

  def initialize(from, to, kind, args={})
    @from, @to, @kind, @args = from, to, kind, args
  end

  def ==(other)
    @from == other.from &&
    @to == other.to &&
    @kind == other.kind &&
    @args == other.args
  end
end
