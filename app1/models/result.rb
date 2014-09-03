class Result < ActiveRecord::Base

  include Imageable::Base

  default_scope {order('id ASC')}

  belongs_to :resultable, :polymorphic => true
  has_many :answer_results, :dependent => :destroy
  has_many :answers, through: :answer_results
  has_many :parent_urls, as: :parentable, :dependent => :destroy

end
