# frozen_string_literal: true

class Membership < ApplicationRecord
  ROLES = %w[owner admin member].freeze

  belongs_to :user
  belongs_to :organization

  scope :active, -> { where(active: true) }

  validates :role, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :organization_id }

  def admin?
    role.in?(%w[owner admin])
  end
end
