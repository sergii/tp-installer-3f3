# frozen_string_literal: true

class Task < ApplicationRecord
  include OrganizationScoped

  STATUSES = %w[todo in_progress blocked done].freeze
  KINDS = %w[task milestone].freeze

  belongs_to :project
  belongs_to :parent, class_name: "Task", optional: true
  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :assigned_to, class_name: "User", optional: true
  has_many :children, class_name: "Task", foreign_key: :parent_id, dependent: :nullify
  has_many :outgoing_dependencies, class_name: "TaskDependency", foreign_key: :predecessor_task_id, dependent: :destroy
  has_many :incoming_dependencies, class_name: "TaskDependency", foreign_key: :successor_task_id, dependent: :destroy
  has_many :project_events, dependent: :nullify

  validates :title, presence: true, length: { maximum: 240 }
  validates :status, inclusion: { in: STATUSES }
  validates :kind, inclusion: { in: KINDS }
  validates :progress, inclusion: { in: 0..100 }
  validate :project_matches_organization
  validate :parent_matches_project
  validate :users_belong_to_organization
  validate :dates_are_ordered

  scope :open, -> { where.not(status: "done") }
  scope :due_today, -> { where(due_on: Date.current) }
  scope :overdue, -> { open.where(due_on: ...Date.current) }

  before_save :synchronize_completion

  private

  def project_matches_organization
    return unless project && organization_id

    errors.add(:project, "must belong to the same organization") if project.organization_id != organization_id
  end

  def parent_matches_project
    return unless parent

    errors.add(:parent, "must belong to the same project") if parent.project_id != project_id
    errors.add(:parent, "must belong to the same organization") if parent.organization_id != organization_id
  end

  def users_belong_to_organization
    validate_member(created_by, :created_by)
    validate_member(assigned_to, :assigned_to)
  end

  def validate_member(user, attribute)
    return unless user && organization
    return if organization.memberships.active.exists?(user_id: user.id)

    errors.add(attribute, "must belong to the task organization")
  end

  def dates_are_ordered
    errors.add(:due_on, "must be on or after the start date") if start_on && due_on && due_on < start_on
  end

  def synchronize_completion
    if status == "done"
      self.progress = 100
      self.completed_at ||= Time.current
    elsif will_save_change_to_status?
      self.completed_at = nil
    end
  end
end
