require "rails_helper"

RSpec.describe TraderMailer, type: :mailer do
  before(:each) do
    @trader = FactoryBot.create(:trader)
  end
  
  it "sends confirmation if account creation is successful" do
    mail = TraderMailer.with(trader: @trader).send_email_receipt
    expect(mail.subject).to eq("Your registration is successful")
    expect(mail.to).to eq([@trader.email])
    expect(mail.from).to eq(["support@stockapp.com"])
  end
  end
end
