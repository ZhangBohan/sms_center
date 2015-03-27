class SmsMessage < ActiveRecord::Base
  def to_s
    "ID: #{id}, name: #{name}, phone: #{phone}, effected_at: #{effected_at}"
  end

  # before_save :default_values
  # def default_values
  #   self.status = false
  # end
end
