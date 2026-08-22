import { addDays, startOfDay } from "date-fns"
import { useMemo } from "react"

import { Gantt } from "@/components/reui/gantt/gantt"
import { GanttNav } from "@/components/reui/gantt/gantt-nav"
import type {
  GanttEvent,
  GanttResource,
} from "@/components/reui/gantt/gantt-types"
import { GanttView } from "@/components/reui/gantt/gantt-view"

type ProjectTask = {
  id: string
  title: string
  status: string
  progress: number
  start_on: string | null
  due_on: string | null
}

const statusColors: Record<string, string> = {
  todo: "var(--color-zinc-500)",
  in_progress: "var(--color-blue-500)",
  blocked: "var(--color-red-500)",
  done: "var(--color-emerald-500)",
}

function parseDate(value: string | null) {
  if (!value) return null

  return startOfDay(new Date(`${value}T00:00:00`))
}

export function ProjectGantt({ tasks }: { tasks: ProjectTask[] }) {
  const resources = useMemo<GanttResource[]>(
    () => tasks.map((task) => ({ id: task.id, title: task.title })),
    [tasks],
  )

  const events = useMemo<GanttEvent[]>(
    () =>
      tasks.map((task) => {
        const start =
          parseDate(task.start_on) ??
          parseDate(task.due_on) ??
          startOfDay(new Date())
        const due = parseDate(task.due_on)
        const end = due && due >= start ? addDays(due, 1) : addDays(start, 1)

        return {
          id: `task-${task.id}`,
          title: task.title,
          start,
          end,
          allDay: true,
          color: statusColors[task.status] ?? "var(--color-zinc-500)",
          resourceId: task.id,
          progress: task.progress,
          readOnly: true,
        }
      }),
    [tasks],
  )

  if (tasks.length === 0) {
    return (
      <div className="bg-card text-muted-foreground rounded-xl border p-8 text-sm">
        Add tasks with dates to build the project schedule.
      </div>
    )
  }

  return (
    <div className="bg-card overflow-hidden rounded-xl border">
      <Gantt
        defaultEvents={events}
        resources={resources}
        defaultScale="month"
        treePanel={{ width: 280 }}
        interactions={{ drag: false, resize: false, selectSlot: false }}
        className="h-[620px] w-full"
      >
        <GanttNav />
        <GanttView />
      </Gantt>
    </div>
  )
}
