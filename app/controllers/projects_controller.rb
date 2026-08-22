# frozen_string_literal: true

class ProjectsController < InertiaController
  VIEWS = %w[overview today list kanban gantt timeline graph].freeze

  before_action :require_current_organization

  def index
    render inertia: "projects/index", props: {
      projects: Current.organization.projects.order(updated_at: :desc).map { |project| project_row(project) },
      statuses: Project::STATUSES
    }
  end

  def create
    project = Current.organization.projects.new(project_params)

    if project.save
      project.project_events.create!(organization: Current.organization, actor: Current.user, event_type: "project.created")
      redirect_to project_path(project), notice: "Project created"
    else
      redirect_to projects_path, inertia: { errors: project.errors }
    end
  end

  def show
    project = Current.organization.projects.find(params[:id])
    tasks = project.tasks.includes(:assigned_to)
    view = params[:view].presence_in(VIEWS) || "overview"

    render inertia: "projects/show", props: {
      project: project_row(project).merge(description: project.description, start_on: project.start_on),
      view:,
      views: VIEWS,
      taskStatuses: Task::STATUSES,
      tasks: tasks.map { |task| task_row(task) },
      events: project.project_events.order(occurred_at: :desc).limit(50).map { |event| event.slice(:id, :event_type, :occurred_at, :metadata) }
    }
  end

  private

  def project_params
    permitted = params.permit(:name, :code, :status, :location, :description, :start_on, :target_on)
    permitted[:code] = permitted[:code].to_s.upcase
    permitted
  end

  def project_row(project)
    project.slice(:id, :name, :code, :status, :location, :target_on)
      .merge(open_tasks: project.tasks.open.count)
  end

  def task_row(task)
    task.slice(:id, :title, :description, :status, :kind, :position, :progress, :start_on, :due_on, :parent_id)
      .merge(assigned_to: task.assigned_to&.slice(:id, :name))
  end
end
