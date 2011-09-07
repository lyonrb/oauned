module Oauned
  module Generators
    module Helpers

      private
      def model_exists?(model)
        File.exists?(File.join(destination_root, model_path(model)))
      end

      def model_path(model)
        File.join("app", "models", "#{model}.rb")
      end
    end
  end
end
