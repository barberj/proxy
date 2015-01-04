class SearchJob < GetJob
  def data_url
    resource.search_url
  end

private

  def query_params
    qp = super
    decoded_criteria = {}
    encoded_criteria = qp['search_by']
    encoded_criteria.each do |name, value|
      decoded = encoded_resource.encoded_fields.find_by(name: name).field.name
      decoded_criteria[decoded] = value
    end

    qp['search_by'] = decoded_criteria
    qp
  end
end
