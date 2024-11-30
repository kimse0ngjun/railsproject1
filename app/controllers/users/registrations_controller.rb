class Users::RegistrationsController < Devise::RegistrationsController
  def create
    Rails.logger.debug "User Params: #{params[:user]}"
    super do |resource|
      if resource.valid?
        resource.full_name = params[:user][:full_name]
        resource.save
      end
    end
  end
end
