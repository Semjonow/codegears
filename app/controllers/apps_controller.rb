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
    @application = Application.by_id(params[:id]).first
    if @application
      render :json => { :active => @application.active }
    else
      render :json => { :success => false }
    end
  end
end