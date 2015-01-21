Fabricator(:user) do
  email { Faker::Internet.email }
  organization
end
