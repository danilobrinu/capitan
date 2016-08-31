class Sprint < ActiveRecord::Base
  has_and_belongs_to_many :lessons
  belongs_to :group

  validates :group_id, presence: true
end
