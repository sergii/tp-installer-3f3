# frozen_string_literal: true

class ProcessStepTemplate < ApplicationRecord
  include OrganizationScoped

  belongs_to :process_template
  has_many :outgoing_dependencies, class_name: "ProcessDependencyTemplate", foreign_key: :predecessor_step_id, dependent: :destroy
  has_many :incoming_dependencies, class_name: "ProcessDependencyTemplate", foreign_key: :successor_step_id, dependent: :destroy

  validates :name, :key, presence: true
  validates :key, uniqueness: { scope: :process_template_id }
  validates :duration_days, numericality: { greater_than: 0 }
  validate :process_template_matches_organization

  private

  def process_template_matches_organization
    return unless process_template && organization_id

    errors.add(:process_template, "must belong to the same organization") if process_template.organization_id != organization_id
  end
end
