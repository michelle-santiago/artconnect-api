class CommissionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "commission_channel#{params[:chat_id]}"
  end
end