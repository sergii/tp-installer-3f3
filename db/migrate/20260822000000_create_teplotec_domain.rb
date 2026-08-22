# frozen_string_literal: true

class CreateTeplotecDomain < ActiveRecord::Migration[8.1]
  RLS_TABLES = %w[
    projects
    tasks
    task_dependencies
    project_events
    process_templates
    process_step_templates
    process_dependency_templates
    knowledge_entities
    knowledge_translations
    semantic_links
  ].freeze

  def change
    create_table :organizations, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_index :organizations, :slug, unique: true

    create_table :memberships, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.string :role, null: false, default: "member"
      t.boolean :active, null: false, default: true
      t.timestamps
    end
    add_index :memberships, %i[user_id organization_id], unique: true

    create_table :projects, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :code, null: false
      t.string :status, null: false, default: "planning"
      t.string :location
      t.text :description
      t.date :start_on
      t.date :target_on
      t.timestamps
    end
    add_index :projects, %i[organization_id code], unique: true
    add_index :projects, %i[organization_id status]

    create_table :tasks, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.references :project, type: :uuid, null: false, foreign_key: true
      t.references :parent, type: :uuid, foreign_key: { to_table: :tasks }
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :assigned_to, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description
      t.string :status, null: false, default: "todo"
      t.string :kind, null: false, default: "task"
      t.integer :position, null: false, default: 0
      t.integer :progress, null: false, default: 0
      t.date :start_on
      t.date :due_on
      t.datetime :completed_at
      t.timestamps
    end
    add_index :tasks, %i[organization_id status due_on]
    add_index :tasks, %i[project_id position]
    add_check_constraint :tasks, "progress BETWEEN 0 AND 100", name: "tasks_progress_range"

    create_table :task_dependencies, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.references :predecessor_task, type: :uuid, null: false, foreign_key: { to_table: :tasks }
      t.references :successor_task, type: :uuid, null: false, foreign_key: { to_table: :tasks }
      t.string :kind, null: false, default: "finish_to_start"
      t.timestamps
    end
    add_index :task_dependencies, %i[predecessor_task_id successor_task_id], unique: true, name: "index_task_dependencies_on_pair"
    add_check_constraint :task_dependencies, "predecessor_task_id <> successor_task_id", name: "task_dependency_not_self"

    create_table :project_events, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.references :project, type: :uuid, null: false, foreign_key: true
      t.references :task, type: :uuid, foreign_key: true
      t.references :actor, foreign_key: { to_table: :users }
      t.string :event_type, null: false
      t.datetime :occurred_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.jsonb :metadata, null: false, default: {}
      t.timestamps
    end
    add_index :project_events, %i[project_id occurred_at]

    create_table :process_templates, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :key, null: false
      t.text :description
      t.boolean :active, null: false, default: true
      t.timestamps
    end
    add_index :process_templates, %i[organization_id key], unique: true

    create_table :process_step_templates, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.references :process_template, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :key, null: false
      t.integer :position, null: false, default: 0
      t.integer :offset_days, null: false, default: 0
      t.integer :duration_days, null: false, default: 1
      t.timestamps
    end
    add_index :process_step_templates, %i[process_template_id key], unique: true

    create_table :process_dependency_templates, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.references :process_template, type: :uuid, null: false, foreign_key: true
      t.references :predecessor_step, type: :uuid, null: false, foreign_key: { to_table: :process_step_templates }
      t.references :successor_step, type: :uuid, null: false, foreign_key: { to_table: :process_step_templates }
      t.string :kind, null: false, default: "finish_to_start"
      t.timestamps
    end

    create_table :knowledge_entities, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.string :kind, null: false
      t.string :key, null: false
      t.string :canonical_name, null: false
      t.jsonb :metadata, null: false, default: {}
      t.timestamps
    end
    add_index :knowledge_entities, %i[organization_id key], unique: true
    add_index :knowledge_entities, %i[organization_id kind]

    create_table :knowledge_translations, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.references :knowledge_entity, type: :uuid, null: false, foreign_key: true
      t.string :locale, null: false
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
    add_index :knowledge_translations, %i[knowledge_entity_id locale], unique: true

    create_table :semantic_links, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true
      t.references :source_entity, type: :uuid, null: false, foreign_key: { to_table: :knowledge_entities }
      t.references :target_entity, type: :uuid, null: false, foreign_key: { to_table: :knowledge_entities }
      t.string :relation, null: false
      t.jsonb :metadata, null: false, default: {}
      t.timestamps
    end
    add_index :semantic_links, %i[source_entity_id target_entity_id relation], unique: true, name: "index_semantic_links_on_pair_and_relation"

    reversible do |direction|
      direction.up do
        RLS_TABLES.each do |table|
          execute <<~SQL
            ALTER TABLE #{table} ENABLE ROW LEVEL SECURITY;
            ALTER TABLE #{table} FORCE ROW LEVEL SECURITY;
            CREATE POLICY organization_isolation ON #{table}
              USING (organization_id = current_setting('app.current_organization', true)::uuid)
              WITH CHECK (organization_id = current_setting('app.current_organization', true)::uuid);
          SQL
        end
      end

      direction.down do
        RLS_TABLES.reverse_each do |table|
          execute "DROP POLICY IF EXISTS organization_isolation ON #{table}"
        end
      end
    end
  end
end
