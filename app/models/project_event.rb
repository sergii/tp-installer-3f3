# frozen_string_literal: true

class ProjectEvent < ApplicationRecord
  include OrganizationScoped

  belongs_to :project
  belongs_to :task, optional: true
  belongs_to :actor, class_name: "User", optional: true

  validates :event_type, :occurred_at, presence: true
end
