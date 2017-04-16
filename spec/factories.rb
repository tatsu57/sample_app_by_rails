FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Person #{n}"}
    sequence(:email) {|n| "Person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    # :adminを使うと上記の:userに加えて、adminをtrueにしてくれる
    factory :admin do
      admin true
    end
  end
end
