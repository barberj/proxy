class CreateJob < Job
  def process
    set_data
    encode_data
  end

private

  def set_data
  end
end
