class Comment < ApplicationRecord
  belongs_to :article
  validates :commneter, presence: true
end
