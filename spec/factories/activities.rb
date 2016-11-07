FactoryGirl.define do
  factory :activity do
    user
    appointment
    owner { create(:guider) }
    message 'did a thing to a thing'
    type 'AuditActivity'
  end
end
