module HotelBeds
  module CoreExt
    module Array
      refine ::Array do
        def sum
          inject(0, :+)
        end

        def flatten_children
          inject(self.class.new, :+)
        end
      end
    end
  end
end
