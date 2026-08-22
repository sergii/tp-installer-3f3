# frozen_string_literal: true

class SemanticLink < ApplicationRecord
  include OrganizationScoped

  belongs_to :source_entity, class_name: "KnowledgeEntity"
  belongs_to :target_entity, class_name: "KnowledgeEntity"

  validates :relation, presence: true
end
