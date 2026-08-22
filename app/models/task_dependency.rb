# frozen_string_literal: true

class TaskDependency < ApplicationRecord
  include OrganizationScoped

  KINDS = %w[finish_to_start start_to_start finish_to_finish start_to_finish].freeze

  belongs_to :predecessor_task, class_name: "Task"
  belongs_to :successor_task, class_name: "Task"

  validates :kind, inclusion: { in: KINDS }
  validate :tasks_share_project_and_organization

  private

  def tasks_share_project_and_organization
    return unless predecessor_task && successor_task

    errors.add(:base, "tasks must belong to the same project") if predecessor_task.project_id != successor_task.project_id
    errors.add(:base, "tasks must belong to the same organization") if predecessor_task.organization_id != organization_id || successor_task.organization_id != organization_id
  end
end
