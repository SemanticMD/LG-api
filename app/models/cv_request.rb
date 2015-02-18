class CvRequest < ActiveRecord::Base
  belongs_to :uploading_organization, class_name: 'Organization'
  belongs_to :image_set
  has_many :cv_results

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

end
