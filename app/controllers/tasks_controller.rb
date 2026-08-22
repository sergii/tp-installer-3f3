# frozen_string_literal: true

class TasksController < InertiaController
  before_action :require_current_organization

  def create
    project = Current.organization.projects.find(params[:project_id])
    task = project.tasks.new(task_params.merge(organization: Current.organization, created_by: Current.user))

    if task.save
      project.project_events.create!(organization: Current.organization, task:, actor: Current.user, event_type: "task.created", metadata: { title: task.title })
      redirect_back fallback_location: project_path(project), notice: "Task created"
    else
      redirect_back fallback_location: project_path(project), inertia: { errors: task.errors }
    end
  end

  def update
    task = Current.organization.tasks.find(params[:id])
    previous_status = task.status

    if task.update(task_params)
      if task.status != previous_status
        task.project.project_events.create!(organization: Current.organization, task:, actor: Current.user, event_type: "task.status_changed", metadata: { from: previous_status, to: task.status })
      end
      redirect_back fallback_location: project_path(task.project), notice: "Task updated"
    else
      redirect_back fallback_location: project_path(task.project), inertia: { errors: task.errors }
    end
  end

  private

  def task_params
    params.permit(:title, :description, :status, :kind, :position, :progress, :start_on, :due_on, :parent_id, :assigned_to_id)
  end
end
