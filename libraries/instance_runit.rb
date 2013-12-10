require 'chef/resource/service'
require File.expand_path('../helpers', __FILE__)

class Elasticsearch
  class Instance
    class Runit

      include Helpers::Elasticsearch

      def initialize(new_resource, run_context = nil)
        @new_resource = new_resource
        @run_context = run_context
        @run_context.include_recipe('runit')
      end

      def create
        create_service_script
      end

      def enable
        enable_service
      end

      def disable
        disable_service
      end

    private

      def create_service_script
        r = Chef::Resource::RunitService.new(elasticsearch_service(@new_resource.name), @run_context)
        r.cookbook          'elasticsearch'
        r.run_template_name 'elasticsearch'
        r.log_template_name 'elasticsearch'
        r.options({
            :conf_dir => @new_resource.configuration_dir,
            :name     => @new_resource.name,
            :user     => @new_resource.user,
          })
        r.run_action(:enable)
      end

      def enable_service
        es_dir = elasticsearch_conf_dir(@new_resource.configuration_dir, @new_resource.name)
        es_svc = elasticsearch_service(@new_resource.name)

        if ::File.directory?(es_dir)
          if elasticsearch_has_configs?(es_dir)
            s = Chef::Resource::Service.new(es_svc, @run_context)
            s.run_action([:enable, :start])
          else
            Chef::Log.info("#{ es_dir } has no configs. Not enabling #{ es_svc }.")
          end
        else
          Chef::Log.info("#{ es_dir } does not exist. Not enabling #{ es_svc }.")
        end
      end

      def disable_service
        s = Chef::Resource::Service.new(elasticsearch_service(@new_resource.name), @run_context)
        s.run_action([:disable, :stop])
      end

      def version
        @new_resource.install_options.fetch(:version) { :version_not_set }
      end

    end
  end
end
