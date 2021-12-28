class TraderMailer < ApplicationMailer
    default from: ENV['TRADER_EMAIL']

    def send_email_receipt
        @trader = params[:trader]
        mail(to: email_address_with_name(@trader.email, @trader.name),
            subject: "Your registration is successful"
        )
    end

    def approved_account_receipt
        @trader = params[:trader]
        mail(to: email_address_with_name(@trader.email, @trader.name),
        subject: "Your account is approved"
    )
    end
end
