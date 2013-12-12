require 'chef/resource'

class Chef
  class Resource
    class ElasticsearchInstance < Chef::Resource

      def initialize(name, run_context = nil)
        super
        @resource_name = :elasticsearch_instance
        @provider = Chef::Provider::ElasticsearchInstance
        @action = :create
        @allowed_actions = [ :create, :enable, :destroy, :disable ]
      end

      def user(arg = nil)
        set_or_return(:user, arg, kind_of: String, default: 'elasticsearch')
      end

      def group(arg = nil)
        set_or_return(:group, arg, kind_of: String, default: 'elasticsearch')
      end

      def destination_dir(arg = nil)
        set_or_return(:destination_dir, arg, kind_of: String, default: ::File.join('', 'opt', 'elasticsearch'))
      end

      def configuration_dir(arg = nil)
        set_or_return(:configuration_dir, arg, kind_of: String)
      end

      def install_options(arg = nil)
        set_or_return(:install_options, arg, kind_of: Hash)
      end

      def service_options(arg = nil)
        set_or_return(:install_options, arg, kind_of: Hash)
      end

      def install_type(arg = nil)
        set_or_return(:install_type, arg, kind_of: String, equal_to: %w(tgz package), default: 'tgz')
      end

      def service_type(arg = nil)
        if arg == 'runit'
          @run_context.include_recipe('runit')
        end

        set_or_return(:service_type, arg, kind_of: String, equal_to: %w(init runit), default: 'init')
      end

      def open_file_max(arg = nil)
        set_or_return(:open_file_max, arg, kind_of: Fixnum)
      end
    end
  end
end
