class AppsController < ApplicationController
  def create
    @application = Application.new(params[:application])

    if @application.save
      render :json => @application, :serializer => ApplicationSerializer
    else
      render :json => { :success => false, :errors => @application.errors }
    end
  end

  def show
    if params[:secret_id].present? && params[:secret_token].present?
      @application = Application.find_by_auth(params[:secret_id], params[:secret_token])
      render :json => { :remaining_requests => @application.remaining.requests,:active => @application.active } and return if @application
    else
      @application = Application.by_id(params[:id]).first
      render :json => { :active => @application.active } and return if @application
    end

    render :json => { :success => false }
  end
end