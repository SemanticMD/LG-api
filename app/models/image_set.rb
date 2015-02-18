class ImageSet < ActiveRecord::Base
  belongs_to :lion

  # organization starts same as uploading_organization but then
  # can be assigned to a different one
  belongs_to :organization, foreign_key: 'owner_organization_id'

  belongs_to :uploading_organization, class_name: 'Organization',
                                      foreign_key: 'uploading_organization_id'
  belongs_to :uploading_user, class_name: 'User',
                              foreign_key: 'uploading_user_id'

  has_many :images, ->{ where is_deleted: false }, inverse_of: :image_set
  belongs_to :main_image, ->{ where is_deleted: false }, class_name: 'Image'

  has_one :cv_request
  has_many :cv_results, through: :cv_request

  accepts_nested_attributes_for :images

  validates_associated :images
  validate :main_image_in_image_set
  validate :main_image_is_public

  # make sure lion_id is nil or pointing to a real lion
  validates :lion, presence: true, if: "lion_id.present?"

  before_destroy :hide_images

  def viewable_images(user)
    if owner? user
      images
    else
      images.is_public
    end
  end

  private

  def owner?(user)
    user.present? &&
      (user == uploading_user || user.organization == organization)
  end

  def hide_images
    images.each { |image| image.hide }
  end

  def main_image_in_image_set
    if main_image && !images.include?(main_image)
      errors.add(:main_image, 'must be included in images')
    end
  end

  def main_image_is_public
    if main_image && !main_image.is_public
      errors.add(:main_image, 'must be publicly accessible')
    end
  end
end
