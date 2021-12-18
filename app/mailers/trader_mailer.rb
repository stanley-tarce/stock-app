class TraderMailer < ApplicationMailer
    default from: 'support@stockapp.com'

    def send_email_receipt
        @trader = params[:trader]
        mail(to: email_address_with_name(@trader.email, @trader.name),
            subject: "Your registration is succesful"
        )
        puts "email sent"
    end
end
