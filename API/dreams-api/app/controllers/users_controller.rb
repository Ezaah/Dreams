# User controller, need to worok mode on this shite
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_user_alerts, only: [:alerts]

  # GET /users
  def index
    @users = User.all
    json_response(@users)
  end

  # POST /users
  def create
    @user = User.create!(user_params.merge!(name: "placeholder", active: true))
    create_ideals(@user.id)
    json_response(@user, :created)
  end

  # GET /users/:id
  def show
    json_response(@user)
  end

  # PUT /users/:id
  def update
    @user.update(user_params)
    head :no_content
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    head :no_content
  end

  # GET /users/:id/alerts
  def alerts
    alerts = []
    Alert.where(user_id: @user.id, active: true).find_each do |alert|
      alerts.push(alert)
    end
    alerts = alerts.sort { |a, b| b.id <=> a.id}
    json_response(alerts)
  end

  private

  def user_params
    params.permit(:name, :email, :password, :artefact, :active)
  end

  def set_user
    @user = User.find_by!(id: params[:id], active: true)
  end

  def set_user_alerts
    @user = User.find_by!(id: params[:user_id], active: true)
  end

  def create_ideals(user_id)
    create_light_ideals(user_id)
    create_sound_ideals(user_id)
    create_temperature_ideals(user_id)
    create_humidity_ideals(user_id)
  end

  def create_light_ideals(user_id)
    ideal_params_light_green = { user_id: user_id, alert_type: 'Green', sensor: 'Light', range_min: 0, range_max: 50, active: true }
    ideal_params_light_yellow = { user_id: user_id, alert_type: 'Yellow', sensor: 'Light', range_min: 51, range_max: 150, active: true }
    ideal_params_light_red = { user_id: user_id, alert_type: 'Red', sensor: 'Light', range_min: 151, range_max: 25563, active: true }
    Ideal.create!(ideal_params_light_green)
    Ideal.create!(ideal_params_light_yellow)
    Ideal.create!(ideal_params_light_red)
  end

  def create_sound_ideals(user_id)
    ideal_params_sound_green = { user_id: user_id, alert_type: 'Green', sensor: 'Sound', range_min: 0, range_max: 0, active: true }
    ideal_params_sound_red = { user_id: user_id, alert_type: 'Red', sensor: 'Sound', range_min: 1, range_max: 1, active: true }
    Ideal.create!(ideal_params_sound_green)
    Ideal.create!(ideal_params_sound_red)
  end

  def create_temperature_ideals(user_id)
    ideal_params_temperature_green = { user_id: user_id, alert_type: 'Green', sensor: 'Temperature', range_min: 18, range_max: 20, active: true }
    ideal_params_temperature_yellow = { user_id: user_id, alert_type: 'Yellow', sensor: 'Temperature', range_min: 14, range_max: 24, active: true }
    ideal_params_temperature_red = { user_id: user_id, alert_type: 'Red', sensor: 'Temperature', range_min: 0, range_max: 60, active: true }
    Ideal.create!(ideal_params_temperature_green)
    Ideal.create!(ideal_params_temperature_yellow)
    Ideal.create!(ideal_params_temperature_red)
  end

  def create_humidity_ideals(user_id)
    ideal_params_humidity_green = { user_id: user_id, alert_type: 'Green', sensor: 'Humidity', range_min: 40, range_max: 50, active: true }
    ideal_params_humidity_yellow = { user_id: user_id, alert_type: 'Yellow', sensor: 'Humidity', range_min: 30, range_max: 60, active: true }
    ideal_params_humidity_red = { user_id: user_id, alert_type: 'Red', sensor: 'Humidity', range_min: 0, range_max: 100, active: true }
    Ideal.create!(ideal_params_humidity_green)
    Ideal.create!(ideal_params_humidity_yellow)
    Ideal.create!(ideal_params_humidity_red)
  end
end
