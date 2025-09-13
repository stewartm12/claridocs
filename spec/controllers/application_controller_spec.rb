require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'inherits from ActionController::Base' do
    expect(ApplicationController).to be < ActionController::Base
  end
end
