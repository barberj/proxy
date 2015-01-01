module Token
  extend ActiveSupport::Concern

  included do
    before_create :generate_tokens
  end

private

  def generate_tokens
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(:token => self.token)
  end

end
