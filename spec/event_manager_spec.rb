require "spec/spec_helper"

describe EventManager do
  it "should dispatch events" do
    em = EventManager.new
    origin = stub(:origin).as_null_object
    destination = mock(:destination)
    args = {:something => "Yeah"}

    event = Event.new(origin, destination, :explosion, args)
    em.add_event(event)

    destination.should_receive(:on_explosion).with(event)

    em.process_events
  end
end
