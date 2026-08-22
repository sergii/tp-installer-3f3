import { Head, Link, useForm } from "@inertiajs/react"
import type { FormEvent } from "react"

import AppLayout from "@/layouts/app-layout"
import type { BreadcrumbItem } from "@/types"

type Project = {
  id: string
  name: string
  code: string
  status: string
  location: string | null
  target_on: string | null
  open_tasks: number
}

const breadcrumbs: BreadcrumbItem[] = [{ title: "Projects", href: "/projects" }]

export default function ProjectsIndex({ projects }: { projects: Project[]; statuses: string[] }) {
  const form = useForm({ name: "", code: "", location: "", status: "planning" })

  const submit = (event: FormEvent) => {
    event.preventDefault()
    form.post("/projects", { onSuccess: () => form.reset() })
  }

  return (
    <AppLayout breadcrumbs={breadcrumbs}>
      <Head title="Projects" />
      <div className="flex flex-1 flex-col gap-6 p-4 md:p-6">
        <div>
          <p className="text-sm text-muted-foreground">Installation portfolio</p>
          <h1 className="text-2xl font-semibold tracking-tight">Projects</h1>
        </div>

        <form onSubmit={submit} className="grid gap-3 rounded-xl border bg-card p-4 md:grid-cols-[1fr_180px_1fr_auto]">
          <input className="h-10 rounded-md border bg-background px-3 text-sm" placeholder="Project name" value={form.data.name} onChange={(event) => form.setData("name", event.target.value)} required />
          <input className="h-10 rounded-md border bg-background px-3 text-sm uppercase" placeholder="Code" value={form.data.code} onChange={(event) => form.setData("code", event.target.value)} required />
          <input className="h-10 rounded-md border bg-background px-3 text-sm" placeholder="Location" value={form.data.location} onChange={(event) => form.setData("location", event.target.value)} />
          <button disabled={form.processing} className="h-10 rounded-md bg-primary px-4 text-sm font-medium text-primary-foreground disabled:opacity-50">Create project</button>
        </form>

        <div className="overflow-hidden rounded-xl border bg-card">
          {projects.length === 0 && <p className="p-6 text-sm text-muted-foreground">No projects yet.</p>}
          <div className="divide-y">
            {projects.map((project) => (
              <Link key={project.id} href={`/projects/${project.id}`} className="grid gap-2 px-4 py-4 hover:bg-muted/40 md:grid-cols-[120px_1fr_150px_100px_120px] md:items-center">
                <span className="font-mono text-sm text-muted-foreground">{project.code}</span>
                <div>
                  <p className="font-medium">{project.name}</p>
                  <p className="text-sm text-muted-foreground">{project.location || "Location not set"}</p>
                </div>
                <span className="text-sm capitalize">{project.status}</span>
                <span className="text-sm tabular-nums">{project.open_tasks} open</span>
                <span className="text-sm text-muted-foreground">{project.target_on || "No target"}</span>
              </Link>
            ))}
          </div>
        </div>
      </div>
    </AppLayout>
  )
}
