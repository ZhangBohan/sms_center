json.array!(@sms_messages) do |sms_message|
  json.extract! sms_message, :id, :name, :phone, :description, :effected_at, :status
  json.url sms_message_url(sms_message, format: :json)
end
