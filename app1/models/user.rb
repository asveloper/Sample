class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, :first_name, :last_name, :presence => true

  after_create :set_group

  default_scope {order('id ASC')}

  has_many :quizzes, :dependent => :destroy
  has_many :trivia, :dependent => :destroy
  has_many :polls, :dependent => :destroy
  belongs_to :creator, :class_name => "User"

  def superadmin?
    self.status == "superadmin" ? true : false
  end

  def admin?
    self.status == "admin" ? true : false
  end

  def group_admin?
    self.status == "group_admin" ? true : false
  end

  def set_group
    if self.creator_id.blank?
      self.group = self.username + "_" + self.id.to_s
    else
      creator_id = self.creator_id
      creator = User.find_by_id creator_id
      self.group = creator.group if creator.group_admin?
      self.group = self.username + "_" + self.id.to_s if creator.superadmin?
      self.save!
    end
  end

end
