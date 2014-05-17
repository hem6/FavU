class TimelinesManager
  def self.sharedManager
    @shared_manager ||= TimelinesManager.new
  end

  def initialize
    @timelines = {}
  end

  def timelineForUser(user)
    @timelines[user["screen_name"]] ||= Timeline.new(user)
  end
end
