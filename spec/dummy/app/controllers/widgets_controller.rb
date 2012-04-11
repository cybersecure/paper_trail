class WidgetsController < ApplicationController

  def paper_trail_enabled_for_controller
    request.user_agent != 'Disable User-Agent'
  end

  def create
    @widget = Widget.create params[:widget]
    head :ok
  end

  def update
    @widget = Widget.get params[:id]
    @widget.update_attributes params[:widget]
    head :ok
  end

  def destroy
    @widget = Widget.get params[:id]
    @widget.destroy
    head :ok
  end
end
