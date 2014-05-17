module FavU
  class TextUtil
    def self.make_relative_timestamp(timestamp)
      formatter = NSDateFormatter.st_TwitterDateFormatter
      time = formatter.dateFromString(timestamp)

      now = Time.now
      gap_secs = (now - time).to_i

      if gap_secs < 60
        return "#{gap_secs}秒"
      elsif gap_secs < 60 * 60
        return "#{gap_secs / 60}分"
      elsif gap_secs < 60 * 60 * 24
        return "#{gap_secs / (60 * 60)}時間"
      else
        return "#{gap_secs / (60 * 60 * 24)}日"
      end
    end
  end

end
