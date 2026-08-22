# frozen_string_literal: true

module OrganizationScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :organization
    before_validation :assign_current_organization, on: :create
    validates :organization, presence: true
  end

  private

  def assign_current_organization
    self.organization ||= Current.organization
  end
end
