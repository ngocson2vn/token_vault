require "token_vault/version"
require "token_vault/authorized_service"
require "token_vault/parameter_store"
require "token_vault/task_loader" if defined?(Rails)

module TokenVault
  def get_application_token(service_name)
    application_token = nil

    service = ::AuthorizedService.find_by(service_name: service_name)
    unless service.nil?
      application_token = service.application_token
    end

    application_token
  end

  def valid?(service_name, application_token)
    is_valid = false
    service = ::AuthorizedService.find_by(service_name: service_name, application_token: application_token)

    unless service.nil?
      is_valid = true
    else
      latest_token = ::ParameterStore.get_application_token(service_name, ::Rails.env)
      if application_token == latest_token
        is_valid = true

        ::AuthorizedService.transaction do
          service = ::AuthorizedService.lock.find_by(service_name: service_name)
          unless service.nil?
            service.application_token = latest_token
            service.save
          end
        end
      end
    end

    is_valid
  end
end
