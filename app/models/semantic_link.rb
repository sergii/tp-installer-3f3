# frozen_string_literal: true

class SemanticLink < ApplicationRecord
  include OrganizationScoped

  belongs_to :source_entity, class_name: "KnowledgeEntity"
  belongs_to :target_entity, class_name: "KnowledgeEntity"

  validates :relation, presence: true
  validate :entities_match_organization

  private

  def entities_match_organization
    return unless source_entity && target_entity && organization_id

    errors.add(:source_entity, "must belong to the same organization") if source_entity.organization_id != organization_id
    errors.add(:target_entity, "must belong to the same organization") if target_entity.organization_id != organization_id
  end
end
