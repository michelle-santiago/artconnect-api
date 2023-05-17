FactoryBot.define do
  factory :request, class: 'Request' do
      kind { 'portrait' }
      price { 10 } 
      duration { '7' }
  end

end