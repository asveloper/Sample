class ParentUrl < ActiveRecord::Base
  belongs_to :parentable, :polymorphic => true
end
