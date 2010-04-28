require "spec/spec_helper"

describe EventManager do
  it "should dispatch events to subscribers" do
    em = EventManager.new

    subscriber_to_look_events = mock(:look_handler)
    em.subscribe(subscriber_to_look_events, :look)

    subscriber_to_talk_events = mock(:talk_handler)
    em.subscribe(subscriber_to_talk_events, :talk)

    talk_event = Event.new(nil, nil, :talk, {})
    em.add_event(talk_event)
    
    look_event = Event.new(nil, nil, :look, {})
    em.add_event(look_event)

    subscriber_to_talk_events.should_receive(:handle_talk).with(talk_event)
    subscriber_to_look_events.should_receive(:handle_look).with(look_event)

    em.process_events
    em.process_events
  end
end
