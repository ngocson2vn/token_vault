namespace :token_vault do
  task update_vault: :environment do
    class ApplicationTokenNotFound < StandardError; end

    ([Rails.root.basename.to_s] + Settings.authorized_services).each do |application_name|
      application_token = TokenVault::ParameterStore.get_application_token(application_name, ::Rails.env)
      raise ApplicationTokenNotFound, application_name if application_token.nil?

      service = TokenVault::AuthorizedService.find_or_initialize_by(application_name: application_name)
      service.application_token = application_token
      service.save
    end
  end
end