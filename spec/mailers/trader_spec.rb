# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TraderMailer, type: :mailer do
  before(:each) do
    @trader = FactoryBot.create(:trader)
    
  end
  it '1. It sends confirmation if account creation is successful' do
    mail = TraderMailer.with(trader: @trader).send_email_receipt
    expect(mail.subject).to eq('Your registration is successful')
  end
  it "2. It should have a from address" do
    mail = TraderMailer.with(trader: @trader).send_email_receipt
    expect(mail.from).to eq(['support@stockapp.com'])
  end
  it "3. It should have a sending address" do
    mail = TraderMailer.with(trader: @trader).send_email_receipt
    expect(mail.to).to eq([@trader.email])
  end
end
