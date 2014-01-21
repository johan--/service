require 'spec_helper'

describe User do
	let(:user) { User.new }

	describe 'validations' do
		before :each do
			@params = {
				machine_owner_id: 1,
				first_name: 'Robb',
				last_name: 'Stark',
				phone_number: 0720123123,
				email: 'robb.stark@mail.com',
				password: 'securepassword',
				password_confirmation: 'securepassword', 
				admin: false
			}
		end
		it {should validate_presence_of :machine_owner_id}
		it {should validate_presence_of :first_name}
		it {should ensure_length_of(:first_name).is_at_least(2).is_at_most(50)}
		it {should_not allow_value('Test234', 'Test 234', 'Test!234').for(:first_name)}
		it {should validate_presence_of :last_name}
		it {should ensure_length_of(:last_name).is_at_least(2).is_at_most(50)}
		it {should_not allow_value('Test234', 'Test 234', 'Test!234').for(:last_name)}
		it {should validate_presence_of :phone_number}
		it {should validate_numericality_of(:phone_number)}	
		it ' is invalid when phone number is too short' do
			@params[:phone_number] = 12345
			user = User.new(@params)
			expect(user.valid?).to be_false
		end
		it ' is invalid when phone number is too long' do
			@params[:phone_number] = SecureRandom.random_number(10*(10**25))
			user = User.new(@params)
			expect(user.valid?).to be_false
		end
		it {should validate_presence_of :email}
		it {should_not allow_value('user', 'user.mail').for(:email)}
		it {should validate_uniqueness_of(:email)}
		it {should validate_presence_of :password}
		it {should ensure_length_of(:password).is_at_least(6).is_at_most(255)}
		it {should validate_confirmation_of(:password)}
	end

	it 'is an ActiveRecord model' do
		expect(User.superclass).to eq(ActiveRecord::Base)
	end	

	it { should have_secure_password }
	it { should_not allow_mass_assignment_of(:password_digest) }
	it { should belong_to(:machine_owner) }
	it { should have_many(:service_events) }

	it 'has first_name' do
		user.first_name = "John"
		expect(user.first_name).to eq("John")
	end

	it 'has last_name' do
		user.last_name = "Wilkins"
		expect(user.last_name).to eq("Wilkins")
	end

	it 'has email' do
		user.email = "john.wilkins@mail.com"
		expect(user.email).to eq("john.wilkins@mail.com")
	end

	it 'has phone_number' do
		user.phone_number = 1234567890
		expect(user.phone_number).to eq(1234567890)
	end

	it 'responds to password' do
		user.password = "pass"
		expect(user.password).to eq("pass")
	end

	it "responds to password_confirmation" do
		user.password_confirmation = "pass"
		expect(user.password_confirmation).to eq("pass")
	end
end