# frozen_string_literal: true

class ProcessDependencyTemplate < ApplicationRecord
  include OrganizationScoped

  belongs_to :process_template
  belongs_to :predecessor_step, class_name: "ProcessStepTemplate"
  belongs_to :successor_step, class_name: "ProcessStepTemplate"

  validate :references_match_process

  private

  def references_match_process
    return unless process_template && predecessor_step && successor_step

    expected = [organization_id, process_template_id]
    predecessor = [predecessor_step.organization_id, predecessor_step.process_template_id]
    successor = [successor_step.organization_id, successor_step.process_template_id]

    errors.add(:predecessor_step, "must belong to the same process") if predecessor != expected
    errors.add(:successor_step, "must belong to the same process") if successor != expected
  end
end
