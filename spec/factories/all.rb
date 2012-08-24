FactoryGirl.define do
  factory :wedding do
    name "John and jane"
    bride "Jane Doe"
    bride_email "jane@test.com"
    groom "John Smith"
    groom_email "john@test.com"
    on Date.today #{ |a| Date.today }
  end

  factory :guest do
    association :wedding
    list {|g| g.wedding.guest_lists.last }
    sequence :name do |n|
      "guest_#{n}"
    end
    email {|g| "#{g.name}@test.com" }
  end

  factory :guest_list do
    association :wedding
    sequence :name do |n|
      "list_#{n}"
    end
  end

  factory :user do
    sequence :nickname do |n|
      "user_#{n}"
    end
    email {|g| "#{g.nickname}@test.com" }
    password 'password'
    password_confirmation 'password'
  end
end