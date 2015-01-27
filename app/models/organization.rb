class Organization < ActiveRecord::Base
  has_many :image_sets, foreign_key: 'owner_organization_id'
  has_many :lions, dependent: :nullify
  has_many :uploaded_image_sets, class_name: 'ImageSet',
                                 foreign_key: 'uploading_organization_id'
  has_many :users

  validates :name, uniqueness: true
end
