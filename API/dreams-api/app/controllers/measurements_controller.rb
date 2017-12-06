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
    @alert = Alert.find_by(measurement_id: @measurement.id, active: true)
    response = {measurement: @measurement, alert: @alert }
    json_response(response)
  end

  def history
    @measurements = []
    Measurement.where(created_at: (history_params[:from]..history_params[:to]), active: true, user_id: history_params[:user_id]).find_each do |measurement|
      @measurements.push(measurement)
    end
    json_response(@measurements)
  end

  def create
    attributes = measurement_params.merge!(active: true)
    if attributes.key?(:light) && attributes.key?(:sound)
      attributes[:light] = luxvalues[attributes[:light]]
      attributes[:sound] = soundvalues[attributes[:sound]]
    end
    measurement = @user.measurements.create!(attributes)
    create_alert(measurement)
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

  def luxvalues
    @@luxvalues ||= JSON.parse(File.read('utils/luxvalues.json'))
  end

  def soundvalues
    @@soundvalues ||= JSON.parse(File.read('utils/soundvalues.json'))
  end

  def measurement_params
    params.permit(:light, :sound, :temperature, :humidity, :active)
  end

  def history_params
    params.permit(:from, :to, :user_id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_measurement
    @measurement = Measurement.find_by!(id: params[:id], active: true) if @user
  end

  def create_alert(measurement)

    light_type = Ideal.where("user_id = ? AND sensor = ? AND range_min <= ? AND range_max >= ?", measurement.user_id, 'Light', measurement.light, measurement.light).pluck(:alert_type).first
    sound_type = Ideal.where("user_id = ? AND sensor = ? AND range_min <= ? AND range_max >= ?", measurement.user_id, 'Sound', measurement.sound, measurement.sound).pluck(:alert_type).first
    temperature_type = Ideal.where("user_id = ? AND sensor = ? AND range_min <= ? AND range_max >= ?", measurement.user_id, 'Temperature', measurement.temperature, measurement.temperature).pluck(:alert_type).first
    humidity_type = Ideal.where("user_id = ? AND sensor = ? AND range_min <= ? AND range_max >= ?", measurement.user_id, 'Humidity', measurement.humidity, measurement.humidity).pluck(:alert_type).first

    parameters = { user_id: measurement.user_id, measurement_id: measurement.id, light_alert: light_type, sound_alert: sound_type, temperature_alert: temperature_type, humidity_alert: humidity_type, active: true}
    Alert.create!(parameters)
  end
end
