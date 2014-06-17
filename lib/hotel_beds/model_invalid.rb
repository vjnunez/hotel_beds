module HotelBeds
  class ModelInvalid < StandardError
    attr_accessor :model
    private :model=

    def initialize(model)
      super("This #{model.class.name} model is invalid")
      self.model = model
      freeze
    end
  end
end
