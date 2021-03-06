# == Schema Information
#
# Table name: people
#
#  id                               :integer          not null, primary key
#  first_name                       :string(255)
#  last_name                        :string(255)
#  email_address                    :string(255)
#  address_1                        :string(255)
#  address_2                        :string(255)
#  city                             :string(255)
#  state                            :string(255)
#  postal_code                      :string(255)
#  geography_id                     :integer
#  primary_device_id                :integer
#  primary_device_description       :string(255)
#  secondary_device_id              :integer
#  secondary_device_description     :string(255)
#  primary_connection_id            :integer
#  primary_connection_description   :string(255)
#  phone_number                     :string(255)
#  participation_type               :string(255)
#  created_at                       :datetime
#  updated_at                       :datetime
#  signup_ip                        :string(255)
#  signup_at                        :datetime
#  voted                            :string(255)
#  called_311                       :string(255)
#  secondary_connection_id          :integer
#  secondary_connection_description :string(255)
#  verified                         :string(255)
#  preferred_contact_method         :string(255)
#  token                            :string(255)
#  active                           :boolean          default(TRUE)
#  deactivated_at                   :datetime
#  deactivated_method               :string(255)
#  neighborhood                     :string(255)
#  tag_count_cache                  :integer          default(0)
#

require 'faker'

devices = Logan::Application.config.device_mappings
connections = Logan::Application.config.connection_mappings

FactoryGirl.define do
  factory :person do
    first_name        { Faker::Name.first_name }
    last_name         { Faker::Name.last_name }
    email_address     { Faker::Internet.email }
    phone_number      { Faker::PhoneNumber.cell_phone }
    address_1         { Faker::Address.street_address }
    address_2         { Faker::Address.secondary_address }
    city              { Faker::Address.city }
    state             { Faker::Address.state }
    postal_code       { 11222 }
    signup_at         Time.current
    primary_device_id devices[:desktop]
    primary_device_description 'crawling'

    secondary_device_id devices[:tablet]
    secondary_device_description 'nice'

    primary_connection_id connections[:phone]
    primary_connection_description 'so so'
    secondary_connection_id connections[:public_wifi]
    secondary_connection_description 'worse'
  end
end
