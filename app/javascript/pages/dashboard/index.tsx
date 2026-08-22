import { Head, Link } from "@inertiajs/react"

import AppLayout from "@/layouts/app-layout"
import type { BreadcrumbItem } from "@/types"

type Stats = {
  active_projects: number
  open_tasks: number
  due_today: number
  overdue: number
}

type TaskRow = {
  id: string
  title: string
  status: string
  progress: number
  due_on: string | null
  project: string
}

type ProjectRow = {
  id: string
  name: string
  code: string
  status: string
  location: string | null
  target_on: string | null
}

const breadcrumbs: BreadcrumbItem[] = [
  { title: "Dashboard", href: "/dashboard" },
]

export default function Dashboard({
  stats,
  today,
  projects,
}: {
  stats: Stats
  today: TaskRow[]
  projects: ProjectRow[]
}) {
  const cards = [
    ["Active projects", stats.active_projects],
    ["Open tasks", stats.open_tasks],
    ["Due today", stats.due_today],
    ["Overdue", stats.overdue],
  ] as const

  return (
    <AppLayout breadcrumbs={breadcrumbs}>
      <Head title="Dashboard" />
      <div className="flex flex-1 flex-col gap-6 p-4 md:p-6">
        <div>
          <p className="text-muted-foreground text-sm">
            TeploTEC Installation OS
          </p>
          <h1 className="text-2xl font-semibold tracking-tight">
            Operations dashboard
          </h1>
        </div>

        <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
          {cards.map(([label, value]) => (
            <div
              key={label}
              className="bg-card rounded-xl border p-4 shadow-sm"
            >
              <p className="text-muted-foreground text-sm">{label}</p>
              <p className="mt-2 text-3xl font-semibold tabular-nums">
                {value}
              </p>
            </div>
          ))}
        </div>

        <div className="grid gap-6 xl:grid-cols-[1.2fr_1fr]">
          <section className="bg-card rounded-xl border">
            <div className="flex items-center justify-between border-b px-4 py-3">
              <div>
                <h2 className="font-semibold">Needs attention</h2>
                <p className="text-muted-foreground text-sm">
                  In progress, due today, and overdue work
                </p>
              </div>
              <Link
                href="/today"
                className="text-sm font-medium hover:underline"
              >
                Open Today
              </Link>
            </div>
            <div className="divide-y">
              {today.length === 0 && (
                <p className="text-muted-foreground p-4 text-sm">
                  Nothing urgent right now.
                </p>
              )}
              {today.map((task) => (
                <div
                  key={task.id}
                  className="flex items-center gap-4 px-4 py-3"
                >
                  <div className="min-w-0 flex-1">
                    <p className="truncate font-medium">{task.title}</p>
                    <p className="text-muted-foreground text-sm">
                      {task.project}
                    </p>
                  </div>
                  <span className="text-muted-foreground text-xs tracking-wide uppercase">
                    {task.status.replaceAll("_", " ")}
                  </span>
                  <span className="w-12 text-right text-sm tabular-nums">
                    {task.progress}%
                  </span>
                </div>
              ))}
            </div>
          </section>

          <section className="bg-card rounded-xl border">
            <div className="flex items-center justify-between border-b px-4 py-3">
              <div>
                <h2 className="font-semibold">Projects</h2>
                <p className="text-muted-foreground text-sm">
                  Current installation portfolio
                </p>
              </div>
              <Link
                href="/projects"
                className="text-sm font-medium hover:underline"
              >
                All projects
              </Link>
            </div>
            <div className="divide-y">
              {projects.length === 0 && (
                <p className="text-muted-foreground p-4 text-sm">
                  Create the first project to start planning.
                </p>
              )}
              {projects.map((project) => (
                <Link
                  key={project.id}
                  href={`/projects/${project.id}`}
                  className="hover:bg-muted/40 block px-4 py-3"
                >
                  <div className="flex items-center justify-between gap-3">
                    <div className="min-w-0">
                      <p className="truncate font-medium">{project.name}</p>
                      <p className="text-muted-foreground text-sm">
                        {project.code}
                        {project.location ? ` · ${project.location}` : ""}
                      </p>
                    </div>
                    <span className="rounded-full border px-2 py-1 text-xs capitalize">
                      {project.status}
                    </span>
                  </div>
                </Link>
              ))}
            </div>
          </section>
        </div>
      </div>
    </AppLayout>
  )
}
