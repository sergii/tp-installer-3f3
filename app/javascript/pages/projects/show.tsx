import { useMemo } from "react"
import type { FormEvent } from "react"
import { Head, Link, router, useForm } from "@inertiajs/react"

import { ProjectGantt } from "@/components/project-gantt"
import AppLayout from "@/layouts/app-layout"
import type { BreadcrumbItem } from "@/types"

type Project = {
  id: string
  name: string
  code: string
  status: string
  location: string | null
  description: string | null
  start_on: string | null
  target_on: string | null
  open_tasks: number
}

type Task = {
  id: string
  title: string
  description: string | null
  status: string
  kind: string
  position: number
  progress: number
  start_on: string | null
  due_on: string | null
  parent_id: string | null
  assigned_to: { id: number; name: string } | null
}

type Event = { id: string; event_type: string; occurred_at: string; metadata: Record<string, unknown> }

export default function ProjectShow({ project, tasks, view, views, taskStatuses, events }: { project: Project; tasks: Task[]; view: string; views: string[]; taskStatuses: string[]; events: Event[] }) {
  const breadcrumbs: BreadcrumbItem[] = [
    { title: "Projects", href: "/projects" },
    { title: project.name, href: `/projects/${project.id}` },
  ]
  const taskForm = useForm({ title: "", status: "todo", kind: "task", start_on: "", due_on: "" })

  const submitTask = (event: FormEvent) => {
    event.preventDefault()
    taskForm.post(`/projects/${project.id}/tasks`, { preserveScroll: true, onSuccess: () => taskForm.reset() })
  }

  const byStatus = useMemo(() => Object.fromEntries(taskStatuses.map((status) => [status, tasks.filter((task) => task.status === status)])), [taskStatuses, tasks])
  const visibleTasks = view === "today" ? tasks.filter((task) => task.status !== "done" && task.due_on && task.due_on <= new Date().toISOString().slice(0, 10)) : tasks
  const setStatus = (task: Task, status: string) => router.patch(`/tasks/${task.id}`, { status }, { preserveScroll: true })

  return (
    <AppLayout breadcrumbs={breadcrumbs}>
      <Head title={`${project.code} · ${project.name}`} />
      <div className="flex flex-1 flex-col gap-5 p-4 md:p-6">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <div className="flex items-center gap-2 text-sm text-muted-foreground"><span className="font-mono">{project.code}</span><span>·</span><span className="capitalize">{project.status}</span></div>
            <h1 className="mt-1 text-2xl font-semibold tracking-tight">{project.name}</h1>
            <p className="mt-1 text-sm text-muted-foreground">{project.location || "Location not set"}{project.target_on ? ` · target ${project.target_on}` : ""}</p>
          </div>
          <div className="rounded-lg border px-3 py-2 text-sm"><span className="font-semibold tabular-nums">{project.open_tasks}</span> open tasks</div>
        </div>

        <nav className="flex gap-1 overflow-x-auto rounded-lg border bg-muted/30 p-1">
          {views.map((item) => (
            <Link key={item} href={`/projects/${project.id}${item === "overview" ? "" : `?view=${item}`}`} className={`whitespace-nowrap rounded-md px-3 py-1.5 text-sm capitalize ${view === item ? "bg-background font-medium shadow-sm" : "text-muted-foreground hover:text-foreground"}`}>
              {item}
            </Link>
          ))}
        </nav>

        <form onSubmit={submitTask} className="grid gap-2 rounded-xl border bg-card p-3 md:grid-cols-[1fr_140px_140px_auto]">
          <input className="h-9 rounded-md border bg-background px-3 text-sm" placeholder="New task" value={taskForm.data.title} onChange={(e) => taskForm.setData("title", e.target.value)} required />
          <input type="date" className="h-9 rounded-md border bg-background px-2 text-sm" value={taskForm.data.start_on} onChange={(e) => taskForm.setData("start_on", e.target.value)} />
          <input type="date" className="h-9 rounded-md border bg-background px-2 text-sm" value={taskForm.data.due_on} onChange={(e) => taskForm.setData("due_on", e.target.value)} />
          <button className="h-9 rounded-md bg-primary px-4 text-sm font-medium text-primary-foreground">Add task</button>
        </form>

        {(view === "overview" || view === "list" || view === "today") && (
          <div className="overflow-hidden rounded-xl border bg-card">
            <div className="grid grid-cols-[1fr_140px_80px_120px] gap-3 border-b bg-muted/30 px-4 py-2 text-xs font-medium uppercase tracking-wide text-muted-foreground">
              <span>Task</span><span>Status</span><span>Progress</span><span>Due</span>
            </div>
            {visibleTasks.length === 0 && <p className="p-5 text-sm text-muted-foreground">No tasks in this view.</p>}
            <div className="divide-y">
              {visibleTasks.map((task) => (
                <div key={task.id} className="grid grid-cols-[1fr_140px_80px_120px] gap-3 px-4 py-3 text-sm">
                  <span className="font-medium">{task.title}</span>
                  <select value={task.status} onChange={(e) => setStatus(task, e.target.value)} className="rounded border bg-background px-2 py-1 text-xs capitalize">
                    {taskStatuses.map((status) => <option key={status} value={status}>{status.replaceAll("_", " ")}</option>)}
                  </select>
                  <span className="tabular-nums">{task.progress}%</span>
                  <span className="text-muted-foreground">{task.due_on || "-"}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {view === "kanban" && (
          <div className="grid gap-3 xl:grid-cols-4">
            {taskStatuses.map((status) => (
              <section key={status} className="min-w-0 rounded-xl border bg-muted/20 p-3">
                <div className="mb-3 flex items-center justify-between"><h2 className="text-sm font-semibold capitalize">{status.replaceAll("_", " ")}</h2><span className="text-xs text-muted-foreground">{byStatus[status].length}</span></div>
                <div className="space-y-2">
                  {byStatus[status].map((task) => <div key={task.id} className="rounded-lg border bg-card p-3 shadow-sm"><p className="text-sm font-medium">{task.title}</p><p className="mt-2 text-xs text-muted-foreground">{task.due_on || "No due date"} · {task.progress}%</p></div>)}
                </div>
              </section>
            ))}
          </div>
        )}

        {view === "gantt" && <ProjectGantt tasks={tasks} />}

        {view === "timeline" && (
          <div className="rounded-xl border bg-card p-4">
            <div className="space-y-4 border-l pl-5">
              {events.map((event) => <div key={event.id} className="relative"><span className="absolute -left-[25px] top-1.5 size-2 rounded-full bg-foreground" /><p className="text-sm font-medium">{event.event_type.replaceAll(".", " ")}</p><p className="text-xs text-muted-foreground">{new Date(event.occurred_at).toLocaleString()}</p></div>)}
              {events.length === 0 && <p className="text-sm text-muted-foreground">No events yet.</p>}
            </div>
          </div>
        )}

        {view === "graph" && (
          <div className="rounded-xl border bg-card p-5">
            <div className="flex flex-wrap items-center gap-3">
              <div className="rounded-lg border-2 px-4 py-3 font-semibold">{project.code}</div>
              {tasks.map((task) => <div key={task.id} className="rounded-lg border px-3 py-2 text-sm">{task.title}</div>)}
            </div>
            <p className="mt-5 text-sm text-muted-foreground">This view will grow into dependencies and semantic project links. The domain already stores TaskDependency separately from presentation.</p>
          </div>
        )}
      </div>
    </AppLayout>
  )
}
