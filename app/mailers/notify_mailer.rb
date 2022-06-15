# class NotifyMailer < ApplicationMailer
#   default from: 'mymail@gmail.com'

#   def notify_email
#     @notify_item = params[:notify_item]
#     @product = Product.find(params[:product_id])
#     @url = 'http://ecom.com/product_path'
#     mail(to: @notify_item.email, subject: "Notification from E-com #{@product.name} Update")
#   end
# end
