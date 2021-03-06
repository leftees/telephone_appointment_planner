class CreateHolidays
  include ActiveModel::Model
  extend ActiveModel::Naming
  include DateRangePickerHelper

  attr_reader :title
  attr_reader :date_range
  attr_reader :users

  validates :title, presence: true
  validates :date_range, presence: true
  validates :users, presence: true

  def to_model
    Holiday.new
  end

  def initialize(title = nil, date_range = nil, users = [])
    @title = title
    @date_range = date_range
    @users = users
  end

  def call
    return false unless valid?
    start_at, end_at = date_range.split(' - ').map do |d|
      strp_date_range_picker_time(d)
    end
    User.where(id: users).each do |user|
      Holiday.create!(title: title, bank_holiday: false, user: user, start_at: start_at, end_at: end_at)
    end
    true
  end
end
