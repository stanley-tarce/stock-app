class TraderMailer < ApplicationMailer
    default from: 'dokitomorvin@gmail.com'

    def send_email_receipt
        @trader = params[:trader]
        from: "support@stockapp.com",
        mail(to: email_address_with_name(@trader.email, @trader.fullname),
            subject: "Your registration is succesful"
        )
    end


end
