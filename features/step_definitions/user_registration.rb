Given(/^I am a guest$/) do
end

Given(/^I want to register on service web application$/) do
  @machine_owners = create(:machine_owner)
  visit "/signup"
end

When(/^I fill the register form with valid data$/) do
  current_path.should == '/signup'
  select('Delphi', :from => 'user_firm_id')
  fill_in "user_first_name", :with => "Daenerys"
  fill_in "user_last_name", :with => "Targaryen"
  fill_in "user_phone_number", :with => "0720123123"
  fill_in "user_email", :with => "daenerys.targaryen@mail.com"
  fill_in "user_password", :with => "securepass"
  fill_in "user_password_confirmation", :with => "securepass"
  click_button "Sign up"
end

When(/^I succesfully submit the form$/) do
  expect(User.find_by_email('daenerys.targaryen@mail.com')).not_to be_nil
end

Then(/^I receive an email regarding successfull submision of registration to admins$/) do
  expect(unread_emails_for("daenerys.targaryen@mail.com").size).to eq(1)
end

Then(/^Path should be login$/) do
  current_path.should == "/login"
end

When(/^I fill the register form with invalid data$/) do
  visit "/signup"
  # select('Delphi', :from => 'user_machine_owner_id')
  fill_in "user_first_name", :with => "D"
  fill_in "user_last_name", :with => "T"
  fill_in "user_phone_number", :with => "1"
  fill_in "user_email", :with => "daenerys"
  fill_in "user_password", :with => "password123"
  fill_in "user_password_confirmation", :with => "password123"
  click_button "Sign up"
end

Then(/^I should see the register form again$/) do
  expect(page).to have_selector('form#new_user')
end

Then(/^I should not be registered in application$/) do
  expect(User.find_by_email('daenerys')).to be_nil
end

Given(/^I've registered before with "(.*?)"$/) do |email|
  @user = create(:user2)
  expect(User.find_by_email(email)).not_to be_nil
end

Given(/^I'm waiting for account confirmation$/) do
  expect(@user.approved_at).to be_nil
end

Given(/^I can't login yet into application$/) do
  login = Login.new(email: @user.email, password: @user.password)
  expect(login.conditional_authentication).to be_nil
end

When(/^I receive the confirmation account email from application$/) do
  UserMailer.user_registration_approved(@user).deliver
  open_email(@user.email, :with_subject => "Your registration has been approved" )
end 

Then(/^I login into application with my credentials$/) do
  @user.update_attributes(:approved_at => Time.now)
  visit "/login"
  fill_in "login_email", :with => "#{@user.email}"
  fill_in "login_password", :with => "#{@user.password}"
  click_button "Sign in"
end

Then(/^I see the root index with all my firm machines listed$/) do
  @machines = create(:machine)
  current_path.should == "/"
end

Given(/^I was registered and waiting for confirmation$/) do
  @user = create(:user2)
  expect(@user.approved_at).to be_nil
end

Given(/^Waiting for confirmation of the account$/) do
  expect(@user.approved_at).to be_nil
end

Then(/^I received an email with denial reason$/) do
  UserMailer.user_registration_denied(@user).deliver
  open_email(@user.email, :with_subject => "Your registration has been denied" )
end

Given(/^I don't know about web application$/) do
  @user = create(:user2, approved_at: Time.now, confirmed: true)
end

Given(/^I received an email with registration invitation$/) do
  UserMailer.invitation(@user).deliver
  open_email(@user.email, :with_subject => "You have been invited to International G&T web platform")
end

Then(/^I click the link from invitation$/) do
  click_first_link_in_email
end

Then(/^I enter credentials from email$/) do
  current_path.should == login_path
  fill_in('login_email', :with => @user.email)
  fill_in('login_password', :with => @user.password)
  click_button('Sign in')
end

Then(/^I'm logged into application$/) do
  expect(page).to have_content("Logged in as #{@user.full_name}")
end

Then(/^I receive an welcome email$/) do
  open_email(@user.email, :with_subject => "Welcome to International G&T web platform")
end

Given(/^user with mail "(.*?)" exists$/) do |arg1|
  User.stub(:find).and_return(create(:user))
end

When(/^I fill login form with valid data for "(.*?)"$/) do |email|
  visit('/login')
  fill_in 'login_email', with: email
  fill_in 'login_password', with: 'securepassword'
  click_button 'Sign in'
end

Then(/^I should be logged in as "(.*?)" user$/) do |name|
  expect(page).to have_content("Logged in as " + name)
end

When(/^I fill login form with invalid data$/) do
  visit('/login')
  fill_in 'login_email', with: 'test@mail.com'
  fill_in 'login_password', with: 'securepass'
  click_button 'Sign in'
end

Then(/^I should see an error$/) do
  expect(page).to have_content('Invalid email or password')
end

Then(/^I'm not logged in application$/) do
  current_path.should == '/login'
end

Given(/^I am a "(.*?)" user$/) do |arg1|
end

When(/^I go to logout page$/) do
  visit('/logout')
end

Then(/^I should be logged out$/) do
  current_path.should == '/login'
end

Then(/^I click the confirmation link$/) do
  click_first_link_in_email
end

Then(/^I try to login with my credentials$/) do
  @user.update_attribute(:confirmed, false)
  visit login_path
  fill_in "login_email", with: @user.email
  fill_in "login_password", with: @user.password
  click_button "Sign in"
end

Then(/^I'm not logged into application$/) do
  current_path.should == login_path
  expect(page).to have_content("Invalid email or password")
end

Given(/^I'm a registered and approved user$/) do
  @user = create(:user, password_reset_token: nil)
end

When(/^I forgot my password$/) do
end

Then(/^I go to login page$/) do
  visit login_path
end

Then(/^I click "(.*?)"$/) do |link|
  click_link link
end

Then(/^I enter my email$/) do
  current_path.should == new_password_reset_users_path
  fill_in "email", with: @user.email
  click_button "Reset Password"
end

Then(/^I receive an email with a password reset link$/) do
  open_email(@user.email, :with_subject => "Password reset instructions")
end

Then(/^I follow the link$/) do
  click_first_link_in_email
end

Then(/^I set a new password$/) do
  current_path.should == edit_password_reset_users_path(@user.reload.password_reset_token)
  fill_in "user_password", with: "securepassword11"
  fill_in "user_password_confirmation", with: "securepassword11"
  click_button "Save"
end

Then(/^I login into application with my new password$/) do
  current_path.should == login_path
  fill_in "login_email", with: @user.email
  fill_in "login_password", with: "securepassword11"
  click_button "Sign in"
  current_path.should == root_path
end

Then(/^I enter a wrong email$/) do
  click_button "Reset Password"
end

Then(/^I see the form again with a flash message$/) do
  current_path.should == create_password_reset_users_path
  expect(page).to have_content("Entered email was not found!")
end

Then(/^I copy and paste wrong the link from email$/) do
  @user.password_reset_token = '12312313123123'
  visit edit_password_reset_users_path(@user.password_reset_token)
end

Then(/^I see the login page with a warning flash message$/) do
  current_path.should == login_path
  expect(page).to have_content("Oops, url not valid!")
end

Then(/^I fill the new password form with invalid date$/) do
  current_path.should == edit_password_reset_users_path(@user.reload.password_reset_token)
  fill_in "user_password", with: ""
  fill_in "user_password_confirmation", with: ""
  click_button "Save"
end

Then(/^I see the new password form again$/) do
  current_path.should == save_password_reset_users_path(@user.password_reset_token)
  expect(page).to have_selector("form#reset_password")
  expect(page).to have_content("Please correct form errors!")
end

Then(/^I follow the link after three hours$/) do
  @user.update_attribute(:password_reset_sent_at, Time.now - 3.hours)
  click_first_link_in_email
end

Then(/^I'm on login page with a warning flash message$/) do
  current_path.should == new_password_reset_users_path
  expect(page).to have_content("Password reset link has expired")
end