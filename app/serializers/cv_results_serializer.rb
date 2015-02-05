class CvResultsSerializer < BaseSerializer
  schema do
    type 'cv_results'

    collection :cv_resuilts, item, CvResultSerializer
  end
end
