module ForemanUpman
  module RepositoryLib
    class Wizard
      def create(wizard_params)
        data = wizard_params['wizard']

        p data
        data['architectures'].each do |architecture|
          next if architecture.empty?

          channel = ForemanUpman::Channel.new
          channel.name = "#{data['origin']} #{data['codename'].titleize} - #{data['version']}"
          channel.label = "#{data['codename']} - #{data['suite']}"
          channel.base_url = data['base_url']
          channel.architecture = architecture
          channel.repository_checksum_type = 'SHA-256'

          channel.save!

          data['components'].each do |component|
            next if component.empty?

            repository = ForemanUpman::Repository.new
            repository.channel = channel
            repository.label = "#{data['origin']} #{data['codename'].titleize} [#{architecture}] (#{component})"
            repository.dist = data['codename']
            repository.component = component
            repository.save!
          end
        end
      end
    end
  end
end
