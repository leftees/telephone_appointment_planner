class HolidaySerializer < ActiveModel::Serializer
  attribute :title
  attribute :start_at, key: :start
  attribute :end_at, key: :end
end