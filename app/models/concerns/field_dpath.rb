module FieldDpath
  extend ActiveSupport::Concern

  included do
    before_save {
      self.dpath = Dpaths.add_validator(self.dpath)
      self.name = self.dpath.split('/')[-2] if self.dpath
    }
  end

  def is_nested_in_a_collection?
    self.dpath.match(%r(//.*\*)).present?
  end

  def collection?
    self.dpath.match(%r(\[\]$)).present?
  end
end
