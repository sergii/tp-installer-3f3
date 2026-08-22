# frozen_string_literal: true

class ProjectEvent < ApplicationRecord
  include OrganizationScoped

  belongs_to :project
  belongs_to :task, optional: true
  belongs_to :actor, class_name: "User", optional: true

  validates :event_type, :occurred_at, presence: true
  validate :references_match_organization

  private

  def references_match_organization
    return unless organization

    errors.add(:project, "must belong to the same organization") if project && project.organization_id != organization_id
    errors.add(:task, "must belong to the event project") if task && task.project_id != project_id

    if actor && !organization.memberships.active.exists?(user_id: actor.id)
      errors.add(:actor, "must belong to the event organization")
    end
  end
end
