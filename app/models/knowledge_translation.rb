# frozen_string_literal: true

class KnowledgeTranslation < ApplicationRecord
  include OrganizationScoped

  belongs_to :knowledge_entity

  validates :locale, :name, presence: true
  validates :locale, uniqueness: { scope: :knowledge_entity_id }
end
