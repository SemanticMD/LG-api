class CvResultsSerializer < BaseSerializer
  schema do
    type 'cv_results'

    collection :cv_results, item, CvResultSerializer
  end
end
