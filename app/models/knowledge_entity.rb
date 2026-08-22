# frozen_string_literal: true

class KnowledgeEntity < ApplicationRecord
  include OrganizationScoped

  has_many :translations, class_name: "KnowledgeTranslation", dependent: :destroy
  has_many :outgoing_links, class_name: "SemanticLink", foreign_key: :source_entity_id, dependent: :destroy
  has_many :incoming_links, class_name: "SemanticLink", foreign_key: :target_entity_id, dependent: :destroy

  validates :kind, :key, :canonical_name, presence: true
  validates :key, uniqueness: { scope: :organization_id }
end
