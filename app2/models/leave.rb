class Leave < ActiveRecord::Base
  belongs_to :employee

  def self.save_leaves(start_date,end_date,employee,comments)
    start_date = Date.strptime(start_date, "%m/%d/%Y")
    end_date = Date.strptime(end_date, "%m/%d/%Y")
    return false if start_date > end_date
    (start_date..end_date).each do |d|
      if d.wday != 0 and d.wday != 6
        @leave = employee.e_leaves.build
        @leave.date = d
        @leave.comments = comments
        @leave.save
      end
    end
  end
end
