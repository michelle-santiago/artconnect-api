class DirectChannel < ApplicationCable::Channel
  def subscribed
    stream_from "direct_channel#{params[:id]}"
  end
end