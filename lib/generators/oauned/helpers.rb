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

      def migration_exists?(model_name)
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_add_oauned_to_#{model_name}.rb$/).first
      end
    end
  end
end
