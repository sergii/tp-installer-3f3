# frozen_string_literal: true

class KnowledgeTranslation < ApplicationRecord
  include OrganizationScoped

  belongs_to :knowledge_entity

  validates :locale, :name, presence: true
  validates :locale, uniqueness: { scope: :knowledge_entity_id }
  validate :knowledge_entity_matches_organization

  private

  def knowledge_entity_matches_organization
    return unless knowledge_entity && organization_id

    errors.add(:knowledge_entity, "must belong to the same organization") if knowledge_entity.organization_id != organization_id
  end
end
