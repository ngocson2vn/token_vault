require 'aws-sdk-core'

module TokenVault
  class ParameterStore
    @client = Aws::SSM::Client.new

    class << self
      def get_application_token(service_name, stage)
        parameter_name = stage.upcase
        parameter_name.concat('_APPLICATION_TOKEN_').concat(service_name.upcase)
        p = get_parameters([parameter_name]).first
        application_token = nil
        application_token = p.value unless p.nil?
        application_token
      end

      private

        def get_parameters(names, with_decryption = false)
          resp = @client.get_parameters({
            names: names,
            with_decryption: with_decryption,
          })

          resp.parameters
        end
    end
  end
end