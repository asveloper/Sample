class Share < ActiveRecord::Base
  scope :get_shares, ->(date, type) {where('DATE(created_at) >= ? AND shareable_type = ?', date, type).order('created_at asc').uniq.pluck('DATE(created_at)')}
  scope :get_custom_range_shares, ->(startDate, endDate, type) {where('DATE(created_at) >= ? AND DATE(created_at) <= ? AND shareable_type = ?', startDate, endDate, type).order('created_at asc').uniq.pluck('DATE(created_at)')}
  scope :get_member_shares, ->(date, type, shareable_id) {where('DATE(created_at) >= ? AND shareable_type = ? AND shareable_id = ?', date, type, shareable_id).order('created_at asc')}
  scope :get_member_custom_range_shares, ->(startDate, endDate, type, shareable_id) {where('DATE(created_at) >= ? AND DATE(created_at) <= ? AND shareable_type = ? AND shareable_id = ?', startDate, endDate, type, shareable_id).order('created_at asc')}

  def self.total_counts(date, type)
    dates = Share.get_shares(date, type)
    totals = []
    tweets = []
    share_dates = []
    dates.each do |share_date|
      shares = Share.where('DATE(created_at) = ?', share_date)
      share_dates << share_date.strftime("%e %b")
      totals << shares.sum(:total)
      tweets << shares.sum(:twitter)
    end
    return {dates: share_dates, totals: totals, tweets: tweets}
  end

  def self.custom_range_total_counts(startDate, endDate, type)
    dates = Share.get_custom_range_shares(startDate, endDate, type)
    totals = []
    tweets = []
    share_dates = []
    dates.each do |share_date|
      shares = Share.where('DATE(created_at) = ?', share_date)
      share_dates << share_date.strftime("%e %b")
      totals << shares.sum(:total)
      tweets << shares.sum(:twitter)
    end
    return {dates: share_dates, totals: totals, tweets: tweets}
  end
end
