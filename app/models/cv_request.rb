class CvRequest < ActiveRecord::Base
  belongs_to :uploading_organization, class_name: 'Organization'
  belongs_to :image_set
  has_many :cv_results

  after_create :generate_request

  delegate :gender, to: :image_set

  validates :uploading_organization, presence: true
  validates :image_set, presence: true, uniqueness: true
  validates :status, presence: true,
            inclusion: { in: [
                           'created', # In DB but not submitted to CV
                           'submitted', # .. to CV
                           'results_received', # from CV
                           'assigned_to_lion', # .. but not verified
                           'verified' # .. by lion owner
                         ]
                       }

  def self.create_for_image_set(image_set)
    self.create(
      {
        image_set: image_set,
        uploading_organization: image_set.organization,
        status: 'created'
      }
    )
  end

  private

  def generate_request
    ::CvRequestWorker.perform_async(self.id)
  end
end
