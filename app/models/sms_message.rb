class SmsMessage < ActiveRecord::Base
  def to_s
    "ID: #{id}, name: #{name}, phone: #{phone}, effected_at: #{effected_at}"
  end

end
