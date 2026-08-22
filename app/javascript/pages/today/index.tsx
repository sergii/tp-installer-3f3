import { Head, Link, router } from "@inertiajs/react"

import AppLayout from "@/layouts/app-layout"
import type { BreadcrumbItem } from "@/types"

type Task = {
  id: string
  title: string
  status: string
  progress: number
  start_on: string | null
  due_on: string | null
  project: { id: string; name: string }
}

const breadcrumbs: BreadcrumbItem[] = [{ title: "Today", href: "/today" }]

export default function Today({ tasks }: { tasks: Task[] }) {
  const complete = (task: Task) => router.patch(`/tasks/${task.id}`, { status: "done" }, { preserveScroll: true })

  return (
    <AppLayout breadcrumbs={breadcrumbs}>
      <Head title="Today" />
      <div className="mx-auto flex w-full max-w-5xl flex-1 flex-col gap-5 p-4 md:p-6">
        <div>
          <p className="text-sm text-muted-foreground">Daily execution</p>
          <h1 className="text-2xl font-semibold tracking-tight">Today</h1>
        </div>
        <div className="overflow-hidden rounded-xl border bg-card">
          {tasks.length === 0 && <p className="p-6 text-sm text-muted-foreground">No overdue or in-progress tasks.</p>}
          <div className="divide-y">
            {tasks.map((task) => (
              <div key={task.id} className="flex flex-wrap items-center gap-3 p-4">
                <button onClick={() => complete(task)} className="size-5 rounded-full border hover:bg-muted" aria-label={`Complete ${task.title}`} />
                <div className="min-w-0 flex-1">
                  <p className="font-medium">{task.title}</p>
                  <Link href={`/projects/${task.project.id}`} className="text-sm text-muted-foreground hover:underline">{task.project.name}</Link>
                </div>
                <span className="text-sm text-muted-foreground">{task.due_on ?? "No due date"}</span>
                <span className="rounded-full border px-2 py-1 text-xs capitalize">{task.status.replaceAll("_", " ")}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </AppLayout>
  )
}
