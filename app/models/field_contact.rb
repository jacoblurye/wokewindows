class FieldContact < ApplicationRecord
  include Attributable

  serialize :key_situations, JSON

  belongs_to :contact_officer, foreign_key: :contact_officer_id, class_name: "Officer", optional: true, inverse_of: :field_contacts
  belongs_to :supervisor, foreign_key: :supervisor_id, class_name: "Officer", optional: true
  has_many :field_contact_names, dependent: :delete_all

  counter_culture :contact_officer

  # use fc_num for resource urls
  def to_param
    fc_num
  end
end
