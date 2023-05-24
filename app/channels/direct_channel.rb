class DirectChannel < ApplicationCable::Channel
  def subscribed
    stream_from "direct_channel#{params[:chat_id]}"

  end
end