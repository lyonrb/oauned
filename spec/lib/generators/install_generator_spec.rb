require 'spec_helper'
require 'generators/oauned/install_generator'

describe Oauned::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../../../tmp", __FILE__)

  before(:all) do
    prepare_destination
    copy_routes
    run_generator ['foo', 'bar', 'doe']
  end

  specify do
    destination_root.should have_structure {
      directory "app" do
        directory "models" do
          file "foo.rb" do
            contains "include Oauned::Models::Application"
            contains "has_many   :authorizations"
            contains "has_many   :connections"
          end

          file "bar.rb" do
            contains "include Oauned::Models::Authorization"
            contains "belongs_to       :user"
            contains "belongs_to       :application"
          end

          file "doe.rb" do
            contains "include Oauned::Models::Connection"
            contains "belongs_to       :user"
            contains "belongs_to       :application"
          end
        end
      end

      directory "config" do
        file "routes.rb" do
          contains "scope '/scoped' { oauned_routing }"
        end
      end

      directory "db" do
        directory "migrate" do
          migration "oauned_create_foo" do
            contains "create_table(:foos) do |t|"
          end

          migration "oauned_create_bar" do
            contains "create_table(:bars) do |t|"
          end

          migration "oauned_create_doe" do
            contains "create_table(:does) do |t|"
          end
        end
      end
    }
  end


  private
  def copy_routes
    routes = Rails.root.join('config', 'empty_routes.rb')
    destination = ::File.join(destination_root, "config")

    FileUtils.mkdir_p(destination)
    FileUtils.cp routes, destination + "/routes.rb"
  end
end
