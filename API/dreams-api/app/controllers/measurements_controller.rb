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

  def create
    @user.measurements.create!(measurement_params.merge!(active: true))
    json_response(@user, :created)
  end

  def update
    @measurement.update(measurement_params)
    head :no_content
  end

  def destroy
    @measurement.destroy
    head :no_content
  end

  private

  def measurement_params
    params.permit(:light, :sound, :temperature, :humidity, :active, :user_id, :id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_measurement
    @measurement = Measurement.find_by!(id: params[:id], active: true) if @user
  end
end
