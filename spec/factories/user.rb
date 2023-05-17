FactoryBot.define do
  factory :user, class: 'User' do
      first_name { Faker::Name.unique.name }
      last_name { Faker::Name.unique.name } 
      username { Faker::Alphanumeric.alpha(number: 10) }
      email { Faker::Internet.email }
      password { 'password' }
      password_confirmation { 'password' }
  end

  trait :artist do
      role { 'artist' }
  end

  trait :client do
    role { 'client' }
  end
end