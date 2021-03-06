class Weather < ApplicationRecord
  belongs_to :city
  validates_presence_of :current, :min, :max, :description, on: :create
  validates_presence_of :current, :description, on: :update
  validates_numericality_of :current, :min, :max

  def self.daily
    find_by(created_at: (Time.current.at_beginning_of_day..Time.current.at_end_of_day))
  end

  def self.current(city)
    raise if city.blank?
    weather_service = OpenWeatherMap.new(city.name)
    current = weather_service.by_city
    weather =
      if City.daily_weather(city.id).blank?
        city.weathers.create!(current)
      else
        city.weathers.daily.update(current) if city.weathers.daily.current != current[:current]
        city.weathers.daily
      end
  end

  def self.last_month(city = 3)
    where(created_at: (Date.current - 1.month)..Date.current.end_of_day, city_id: city)
  end

  def self.group_max_temp
    select(:created_at, :max).group(:created_at, :max)
  end
end
