# frozen_string_literal: true

require "rails_helper"

RSpec.describe DemoWorkspaceSeed do
  let(:password) { "TeploTEC-Demo-Test-2026!" }

  it "creates a resettable RLS-isolated demo workspace with realistic projections" do
    travel_to Time.zone.local(2026, 8, 22, 12) do
      result = described_class.call(password:)
      organization = result.fetch(:organization)

      expect(organization.slug).to eq("teplotec-demo")
      expect(result.fetch(:admin).email).to eq("demo.admin@teplotec.example")
      expect(organization.memberships.active.count).to eq(4)

      with_organization(organization) do
        expect(organization.projects.count).to eq(3)

        primary = organization.projects.find_by!(code: "GEO-2026-042")
        expect(primary.tasks.count).to eq(described_class::PRIMARY_TASKS.size)
        expect(primary.tasks.where(status: "blocked").count).to be >= 2
        expect(primary.tasks.where(due_on: Date.current).open).not_to be_empty
        expect(TaskDependency.where(organization:).count).to eq(described_class::PRIMARY_DEPENDENCIES.size)
        expect(primary.project_events.count).to eq(8)

        expect(organization.process_templates.count).to eq(1)
        expect(organization.knowledge_entities.count).to eq(described_class::KNOWLEDGE_ENTITIES.size)
        expect(organization.semantic_links.count).to eq(described_class::KNOWLEDGE_LINKS.size)
      end

      described_class.call(password:)

      with_organization(organization.reload) do
        expect(organization.projects.count).to eq(3)
        expect(organization.projects.find_by!(code: "GEO-2026-042").tasks.count)
          .to eq(described_class::PRIMARY_TASKS.size)
      end
    end
  end

  it "requires a password long enough for the application password policy" do
    expect { described_class.call(password: "too-short") }
      .to raise_error(ArgumentError, /at least 12 characters/)
  end

  def with_organization(organization)
    connection = ActiveRecord::Base.connection
    previous = Current.organization

    Current.organization = organization
    connection.execute("SELECT set_config('app.current_organization', #{connection.quote(organization.id.to_s)}, false)")
    yield
  ensure
    connection&.execute("RESET app.current_organization")
    Current.organization = previous
  end
end
