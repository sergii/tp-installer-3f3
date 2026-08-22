# frozen_string_literal: true

class KnowledgeController < InertiaController
  before_action :require_current_organization

  def index
    entities = Current.organization.knowledge_entities.order(:kind, :canonical_name)
    links = Current.organization.semantic_links.includes(:source_entity, :target_entity)

    render inertia: "knowledge/index", props: {
      entities: entities.map { |entity| entity.slice(:id, :kind, :key, :canonical_name, :metadata) },
      links: links.map do |link|
        {
          id: link.id,
          relation: link.relation,
          source: { id: link.source_entity_id, name: link.source_entity.canonical_name },
          target: { id: link.target_entity_id, name: link.target_entity.canonical_name }
        }
      end
    }
  end
end
