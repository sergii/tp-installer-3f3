# frozen_string_literal: true

class TodayController < InertiaController
  before_action :require_current_organization

  def index
    tasks = Current.organization.tasks.open.includes(:project)
      .where("due_on <= :today OR status = :in_progress", today: Date.current, in_progress: "in_progress")
      .order(Arel.sql("due_on ASC NULLS LAST"), :created_at)

    render inertia: "today/index", props: {
      tasks: tasks.map do |task|
        task.slice(:id, :title, :status, :progress, :start_on, :due_on)
          .merge(project: { id: task.project_id, name: task.project.name })
      end
    }
  end
end
