require 'spec_helper'

describe Devise::RegistrationsController do
	describe 'GET new' do
		let(:new_user) { mock_model('User').as_new_record }
		before :each do
		    request.env['devise.mapping'] = Devise.mappings[:user]
			User.stub(:new).and_return(new_user)
		end
		it 'assigns user variable to the view' do
			get :new
			expect(assigns[:user]).to eq(new_user)
		end
		it 'renders new template' do
			get :new
			expect(response).to render_template :new
		end
	end

	describe 'POST create' do
		before :each do
		    request.env['devise.mapping'] = Devise.mappings[:user]
	    end
		it 'it sends new message to User class' do
			params = {
				"machine_owner_id" => "1",
				"first_name" => "John",
				"last_name" => "Wilkins",
				"phone_number" => "1234567890",
				"email" => "john.wilkins@firm.com",
				"password" => "pass",
				"password_confirmation" => "pass",
				"admin" => false
			}
			User.should_receive(:new).with(params)
			post :create, user: params
		end
	end
end
