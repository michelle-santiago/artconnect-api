class DirectChannel < ApplicationCable::Channel
  def subscribed
    stream_from "direct_channel#{params[:id]}"
  end

  def unsubscribed
    stop_stream_from "direct_channel#{params[:id]}"
  end
end