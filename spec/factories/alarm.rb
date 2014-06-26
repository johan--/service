FactoryGirl.define do
	factory :alarm do
		sequence :number do |n|
			"70012#{n}"
		end
		
		sequence :description do |n|
			"Alarm no##{n}"
		end
	end
end