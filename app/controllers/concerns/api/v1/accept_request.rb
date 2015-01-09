module Api::V1::AcceptRequest
  extend ActiveSupport::Concern

private

  def accept_request(request_type, encoded_name, params)
    if encoded_resource = data_encoding.encoded_resource_for(encoded_name, request_type)
      job = data_encoding.jobs.create(
        type: "#{request_type.to_s.capitalize}Job",
        params: params,
        resource_id: encoded_resource.resource.id,
        encoded_resource_id: encoded_resource.id,
        account_id: data_encoding.account_id
      )

      ProcessRequest.perform_later(job)

      render(
        json: { results: { job_id: job.id } },
        status: :accepted,
      )
    else
      raise Exceptions::Unprocessable.new(
        %Q(Can not request #{request_type} for #{installed_api.name}'s #{encoded_name.capitalize}.)
      )
    end
  end
end
