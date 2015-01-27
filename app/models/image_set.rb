class ImageSet < ActiveRecord::Base
  belongs_to :lion
  belongs_to :organization, -> { where is_verified: true },
                            foreign_key: 'owner_organization_id'

  belongs_to :uploading_organization, class: 'Organization',
                                      foreign_key: 'uploading_organization_id'
  belongs_to :uploading_user, class: 'User',
                              foreign_key: 'uploading_user_id'

  has_many :images
end
