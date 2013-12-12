require 'chef/resource'

module Helpers
  module Elasticsearch

    def elasticsearch_service(instance)
      "elasticsearch-#{ instance.name }"
    end

    def elasticsearch_destination_dir(instance)
      ::File.join('', instance.destination_dir, instance.name)
    end

    def elasticsearch_installation_dir(instance)
      ::File.join('', elasticsearch_destination_dir(instance), instance.install_options[:version])
    end

    def elasticsearch_conf_dir(instance)
      if instance.configuration_dir.nil?
        ::File.join('', elasticsearch_destination_dir(instance), 'conf' )
      else
        instance.configuration_dir
      end
    end

    def elasticsearch_conf_file(instance)
      ::File.join('', elasticsearch_conf_dir(instance), "elasticsearch.json")
    end

    def elasticsearch_binary(instance)
      ::File.join('', elasticsearch_installation_dir(instance), 'bin', 'elasticsearch')
    end

    def elasticsearch_env_vars_file(instance)
      ::File.join('', elasticsearch_conf_dir(instance), 'elasticsearch.in.sh')
    end

    # FIXME. ? methods should return boolean.
    # FIXME. Should have another method to provide the Array.
    # @param dir [String] The elasticsearch configuration directory.
    # @return [Array] configuration files in the directory.
    def elasticsearch_has_configs?(dir)
      ::Dir.glob(::File.join('', dir, '*.conf'))
    end

    # Finds a resource if it exists in the collection.
    # @param type [String] The resources proper name, eg ElasticsearchInstance or ElasticsearchConfig
    # @param name [String] The unique name of that resource.
    # @return [Resource] Hopefully the resource object you were looking for.
    #
    def lookup_resource(type, name, run_context)
      begin
        run_context.resource_collection.find("#{ type }[#{ name }]")
      rescue ArgumentError => e
        puts "You provided invalid arugments to resource_collection.find: #{ e }"
      rescue RuntimeError => e
        puts "The resources you searched for were not found: #{ e }"
      end
    end

    def lookup_instance(name, run_context)
      lookup_resource(:elasticsearch_instance, name, run_context)
    end

  end
end
