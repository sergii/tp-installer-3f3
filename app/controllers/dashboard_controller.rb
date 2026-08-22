# frozen_string_literal: true

class DashboardController < InertiaController
  before_action :require_current_organization

  def index
    projects = Current.organization.projects
    tasks = Current.organization.tasks

    render inertia: "dashboard/index", props: {
      stats: {
        active_projects: projects.active.count,
        open_tasks: tasks.open.count,
        due_today: tasks.open.due_today.count,
        overdue: tasks.overdue.count
      },
      today: task_rows(tasks.open.where(due_on: ..Date.current).order(:due_on).limit(8)),
      projects: projects.active.order(updated_at: :desc).limit(6).map { |project| project_row(project) }
    }
  end

  private

  def task_rows(tasks)
    tasks.includes(:project).map do |task|
      task.slice(:id, :title, :status, :progress, :due_on).merge(project: task.project.name)
    end
  end

  def project_row(project)
    project.slice(:id, :name, :code, :status, :location, :target_on)
  end
end
