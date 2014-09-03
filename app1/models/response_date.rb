class ResponseDate < ActiveRecord::Base
  TYPES = %w[last_24_hours past_week past_two_weeks past_month past_three_months past_six_months past_year custom_range]
  belongs_to :datable, :polymorphic => true

  def self.get_response(type)
    if type == self::TYPES[0]
      24.hours.ago.to_date
    elsif type == self::TYPES[1]
      1.week.ago.to_date
    elsif type == self::TYPES[2]
      2.weeks.ago.to_date
    elsif type == self::TYPES[3]
      1.month.ago.to_date
    elsif type == self::TYPES[4]
      3.months.ago.to_date
    elsif type == self::TYPES[5]
      6.months.ago.to_date
    elsif type == self::TYPES[6]
      1.year.ago.to_date
    end
  end

end
