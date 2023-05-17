FactoryBot.define do
  factory :commission, class: 'Commission' do
      kind { 'portrait' }
      price { 10 } 
      duration { '7' }
  end


end