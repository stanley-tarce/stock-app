# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TraderMailer, type: :mailer do
  before(:each) do
    @trader = FactoryBot.create(:trader)
  end

  # let(:valid_attributes) {
  #   {
  #     :trader => {
  #       :name => "Leann",
  #       :email => "ellerreyes82@gmail.com",
  #       :password => "24242424",
  #       :password_confirmation => "24242424",
  #     }
  #   }
  # }

  it 'sends confirmation if account creation is successful' do
    mail = TraderMailer.with(trader: @trader).send_email_receipt
    expect(mail.subject).to eq('Your registration is successful')
    expect(mail.to).to eq([@trader.email])
    expect(mail.from).to eq(['support@stockapp.com'])
    # expect {
    #   post :invite, params: valid_attributes
    # }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
