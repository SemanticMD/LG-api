class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable

  belongs_to :organization
  has_many :image_sets, foreign_key: 'uploading_user_id'
  validates :email, uniqueness: true
  validates :organization, presence: true
end
