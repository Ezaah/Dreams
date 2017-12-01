class MeasurementsController < ApplicationController
  before_action :set_user
  before_action :set_user_measurement, only: [:show, :update, :destroy]
  def index
    json_response(@user.measurements)
  end

  def show
    json_response(@measurement)
  end

  def last
    @measurement = Measurement.where(user_id: @user.id, active: true).order(:created_at).last
    json_response(@measurement)
  end

  def history
    @measurements = []
    Measurement.where(created_at: (history_params[:from]..history_params[:to]), active: true).find_each do |measurement|
      @measurements.push(measurement)
    end
    json_response(@measurements)
  end

  def create
    attributes = measurement_params.merge!(active: true)
    if attributes.key?(:light)
      light_values = JSON.parse(File.read('../utils/luxvalues.json'))
      attributes[:light] = light_values[attributes[:light]]
    end
    @user.measurements.create!(attributes)
    create_alerts(attributes)
    head :created
  end

  def update
    @measurement.update_attribute(:active, measurement_params[:active])
    head :no_content
  end

  def destroy
    @measurement.destroy
    head :no_content
  end

  private

  def measurement_params
    params.permit(:light, :sound, :temperature, :humidity, :active)
  end

  def history_params
    params.permit(:from, :to)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_measurement
    @measurement = Measurement.find_by!(id: params[:id], active: true) if @user
  end

  def create_alerts(attributes)
    alert_type_light = Ideal.where("range_min <= ? and ? <= range_max and sensor = ? and user_id = ? ",attributes[:light].to_i, attributes[:light].to_i,'Light', @user.id).first
    alert_type_light = { user_id: alert_type_light.user_id, sensor: alert_type_light.sensor, alert_type: alert_type_light.alert_type, active: true }

    alert_type_sound = Ideal.where("range_min <= ? and ? <= range_max and sensor = ? and user_id = ?",attributes[:sound].to_i, attributes[:sound].to_i,'Sound', @user.id).first
    alert_type_sound = { user_id: alert_type_sound.user_id, sensor: alert_type_sound.sensor, alert_type: alert_type_sound.alert_type, active: true }

    alert_type_temperature = Ideal.where("range_min <= ? and ? <= range_max and sensor = ? and user_id = ?",attributes[:temperature].to_i, attributes[:temperature].to_i,'Temperature', @user.id).first
    alert_type_temperature = { user_id: alert_type_temperature.user_id, sensor: alert_type_temperature.sensor, alert_type: alert_type_temperature.alert_type, active: true }

    alert_type_humidity = Ideal.where("range_min <= ? and ? <= range_max and sensor = ? and user_id = ?",attributes[:humidity].to_i, attributes[:humidity].to_i, 'Humidity', @user.id).first
    alert_type_humidity = { user_id: alert_type_humidity.user_id, sensor: alert_type_humidity.sensor, alert_type: alert_type_humidity.alert_type, active: true}
    
    if alert_type_light[:alert_type] != 'Green'
      Alert.create!(alert_type_light)
    end
    if alert_type_sound[:alert_type] != 'Green'
      Alert.create!(alert_type_sound)
    end
    if alert_type_temperature[:alert_type] != 'Green'
      Alert.create!(alert_type_temperature)
    end
    if alert_type_humidity[:alert_type] != 'Green'
      Alert.create!(alert_type_humidity)
    end
  end
end
