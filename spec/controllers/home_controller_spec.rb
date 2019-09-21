require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe '#index' do
    it 'response 200' do
      get :index
      expect(response).to be_success
      # expect(response).to be_successful
    end
  end
end
