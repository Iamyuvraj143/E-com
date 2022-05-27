class SendNotifyEmailToUserJob < ApplicationJob
  queue_as :default

  def perform(notify_item, product_id)
    NotifyMailer.with(notify_item: notify_item, product_id: product_id).notify_email.deliver_now
  end
end
