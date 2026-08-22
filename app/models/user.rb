# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :created_tasks, class_name: "Task", foreign_key: :created_by_id, dependent: :nullify
  has_many :assigned_tasks, class_name: "Task", foreign_key: :assigned_to_id, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def ensure_workspace!
    memberships.active.includes(:organization).first&.organization || with_lock do
      memberships.active.includes(:organization).first&.organization || create_personal_workspace!
    end
  end

  private

  def create_personal_workspace!
    base = name.parameterize.presence || "workspace"
    organization = Organization.create!(name: "#{name}'s workspace", slug: "#{base}-#{id}")
    memberships.create!(organization:, role: "owner")
    organization
  end
end
