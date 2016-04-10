# == Schema Information
#
# Table name: submissions
#
#  id              :integer          not null, primary key
#  raw_content     :text
#  person_id       :integer
#  ip_addr         :string(255)
#  entry_id        :string(255)
#  form_structure  :text
#  field_structure :text
#  created_at      :datetime
#  updated_at      :datetime
#

class Submission < ActiveRecord::Base

  validates_presence_of :raw_content
  belongs_to :person
  validates :person_id, numericality: { only_integer: true, allow_nil: true }

  enum form_type: [ :unknown, :screening, :availability, :test ]

  self.per_page = 15

  def fields
    # return the set of fields that make up a submission
    #  { field_id => 'field description' }

    @fields ||= JSON.parse(field_structure)['Fields'].inject({}) do |acc, i|
      extract_field_data(acc, i)
    end
  end

  def field_label(field_id)
    fields[field_id][:title]
  end

  def field_value(field_id)
    value = []

    if fields[field_id][:subfields].any?
      fields[field_id][:subfields].each do |sf|
        value << JSON.parse(raw_content)[sf]
      end
    else
      value << JSON.parse(raw_content)[field_id]
    end
    value.size == 1 ? value.first : value
  end

  def form_name
    @form_name ||= JSON.parse(form_structure)['Name']
  end

  def form_email
    JSON.parse(field_structure)['Fields'].each do |field|
      return field_value(field['ID']) if field['Title'] == 'Email'
    end
    return nil
  end

  def form_email_or_phone_number
    JSON.parse(field_structure)['Fields'].each do |field|
      return field_value(field['ID']) if field['Title'] == 'Email'
      return field_value(field['ID']) if field['Title'] == 'Email or Phone Number'
      return field_value(field['ID']) if field['Title'] == 'Phone number'  
    end
    return nil
  end

  def submission_values
    # return the field values in a nice format for search indexing
    fields.collect { |field_id, _desc| field_value(field_id) }.join(' ')
  end

  private

    def extract_field_data(data, field)
      data[field['ID']] = {
        title: field['Title'],
        type: field['Type'],
        subfields: (field['SubFields'] || []).collect { |sf| sf['ID'] }
      }
      # Rails.logger.debug("field: #{field['ID']} --> #{data[field['ID']]}")
      data
    end

end
