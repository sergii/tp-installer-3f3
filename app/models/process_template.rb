# frozen_string_literal: true

class ProcessTemplate < ApplicationRecord
  include OrganizationScoped

  has_many :steps, -> { order(:position) }, class_name: "ProcessStepTemplate", dependent: :destroy
  has_many :dependencies, class_name: "ProcessDependencyTemplate", dependent: :destroy

  validates :name, :key, presence: true
  validates :key, uniqueness: { scope: :organization_id }
end
