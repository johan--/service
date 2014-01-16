# require "spec_helper"

# describe UserRegistrationNotifier do
# 	describe 'registration_confirmation' do
# 		let(:user) { mock_model(User, :first_name => "John", :last_name => "Wilkins",
# 		 			:email => "john_wilkins@firm.com", :admin => false) }
# 		let(:mail) { UserRegistrationNotifier.registration_confirmation(user) }

# 		#ensure that the subject is correct
# 		it 'renders the subject' do
# 			mail.subject.should == 'Registration confirmation'
# 		end

# 		#ensure the receiver is correct
# 		it 'renders the receiver email' do
# 			mail.to.should == [user.email]
# 		end

# 		#ensure the sender is correct
# 		it 'renders the sender mail' do
# 			mail.from.should == ['noreply@service.com']
# 		end

# 		#ensure that the first and last name appears in email body
# 		it 'assigns first and last name' do
# 			mail.body.encoded.should match(user.first_name + ' ' + user.last_name)
# 		end
# 	end
# end