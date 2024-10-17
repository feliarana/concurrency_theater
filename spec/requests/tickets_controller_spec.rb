require 'rails_helper'

RSpec.describe TicketsController, type: :request do
  let(:ticket) { create(:ticket, status: 'available') }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  it 'allows only one user to reserve the ticket concurrently' do
    token1 = jwt_token_for(user1)
    token2 = jwt_token_for(user2)

    threads = []

    threads << Thread.new do
      post "/tickets/#{ticket.id}/reserve", headers: { 'Authorization' => "Bearer #{token1}" }
    end

    threads << Thread.new do
      post "/tickets/#{ticket.id}/reserve", headers: { 'Authorization' => "Bearer #{token2}" }
    end

    threads.each(&:join)

    ticket.reload

    expect(ticket.status).to eq('reserved')
    expect([ user1.id, user2.id ]).to include(ticket.user_id)
  end
end
