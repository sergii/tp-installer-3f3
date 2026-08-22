# frozen_string_literal: true

class Project < ApplicationRecord
  include OrganizationScoped

  STATUSES = %w[planning active paused completed cancelled].freeze

  has_many :tasks, -> { order(:position, :created_at) }, dependent: :destroy
  has_many :project_events, dependent: :destroy

  validates :name, :code, presence: true
  validates :code, uniqueness: { scope: :organization_id }
  validates :status, inclusion: { in: STATUSES }

  scope :active, -> { where(status: %w[planning active paused]) }
end
