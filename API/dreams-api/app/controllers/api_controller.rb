class ApiController < ApplicationController

  def sync
    user = User.find_by!(artefact: sync_params[:artefact])
    p user.id
    plain_response(user.id.to_s)
  end

  def login
    user = User.find_by(email: login_params[:email])
    return user if user && user.authenticate(login_params[:password])
  end


  private

  def login_params
    params.permit(:email, :password)
  end

  def sync_params
    params.permit(:artefact)
  end
end
