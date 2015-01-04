module FieldDpath
  extend ActiveSupport::Concern

  included do
    before_save {
      self.dpath = Dpaths.add_validator(self.dpath)
      self.name = self.dpath.split('/')[-2] if self.dpath
    }
  end
end
