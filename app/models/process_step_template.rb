# frozen_string_literal: true

class ProcessStepTemplate < ApplicationRecord
  include OrganizationScoped

  belongs_to :process_template
  has_many :outgoing_dependencies, class_name: "ProcessDependencyTemplate", foreign_key: :predecessor_step_id, dependent: :destroy
  has_many :incoming_dependencies, class_name: "ProcessDependencyTemplate", foreign_key: :successor_step_id, dependent: :destroy

  validates :name, :key, presence: true
  validates :key, uniqueness: { scope: :process_template_id }
  validates :duration_days, numericality: { greater_than: 0 }
end
