class ActivitiesController < ApplicationController
  def index
    @activities = current_user.activities.includes(:user, :appointment)
  end

  def create
    @activity = MessageActivity.create(message_params)
    PusherActivityNotificationJob.perform_later(appointment.guider, @activity)
    respond_to do |format|
      format.js { render @activity }
    end
  end

  private

  def message_params
    params
      .require(:message_activity)
      .permit(:message)
      .merge(
        user: current_user,
        owner: appointment.guider,
        appointment: appointment
      )
  end

  def appointment
    Appointment.find(params[:appointment_id])
  end
end
