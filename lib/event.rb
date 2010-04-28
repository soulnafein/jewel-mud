class Event
  attr_accessor :from, :to, :kind, :args

  def initialize(from, to, kind, args={})
    @from, @to, @kind, @args = from, to, kind, args
  end

  def ==(other)
    return false if other.nil?
    @from == other.from &&
    @to == other.to &&
    @kind == other.kind &&
    @args == other.args
  end
end
