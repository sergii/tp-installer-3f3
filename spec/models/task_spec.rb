# frozen_string_literal: true

require "rails_helper"

RSpec.describe Task, type: :model do
  fixtures :users

  let(:user) { users(:one) }
  let(:organization) { user.ensure_workspace! }
  let(:project) { organization.projects.create!(name: "Demo", code: "DEMO") }

  it "keeps completed task state consistent" do
    task = organization.tasks.create!(project:, title: "Commissioning", status: "done", created_by: user)

    expect(task.progress).to eq(100)
    expect(task.completed_at).to be_present
  end

  it "rejects a parent from another project" do
    other_project = organization.projects.create!(name: "Other", code: "OTHER")
    parent = organization.tasks.create!(project: other_project, title: "Other task", created_by: user)
    task = organization.tasks.new(project:, title: "Child", parent:, created_by: user)

    expect(task).not_to be_valid
    expect(task.errors[:parent]).to include("must belong to the same project")
  end

  it "rejects an assignee outside the organization" do
    outsider = users(:two)
    task = organization.tasks.new(project:, title: "Restricted", assigned_to: outsider, created_by: user)

    expect(task).not_to be_valid
    expect(task.errors[:assigned_to]).to include("must belong to the task organization")
  end
end
