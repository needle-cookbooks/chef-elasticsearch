package 'openjdk-7-jre-headless'

elasticsearch_instance 'es_test' do
  destination_dir '/opt/es'
  user 'elastic'
  group 'elastic'
  install_options({
    version: '0.90.2',
    url: 'https://download.elasticsearch.org/elasticsearch/elasticsearch'
  })
  service_type 'runit'
end
