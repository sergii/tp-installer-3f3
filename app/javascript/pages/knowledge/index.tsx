import { Head } from "@inertiajs/react"

import AppLayout from "@/layouts/app-layout"
import type { BreadcrumbItem } from "@/types"

type Entity = {
  id: string
  kind: string
  key: string
  canonical_name: string
  metadata: Record<string, unknown>
}
type Link = {
  id: string
  relation: string
  source: { id: string; name: string }
  target: { id: string; name: string }
}

const breadcrumbs: BreadcrumbItem[] = [
  { title: "Knowledge", href: "/knowledge" },
]

export default function KnowledgeIndex({
  entities,
  links,
}: {
  entities: Entity[]
  links: Link[]
}) {
  return (
    <AppLayout breadcrumbs={breadcrumbs}>
      <Head title="Knowledge" />
      <div className="flex flex-1 flex-col gap-6 p-4 md:p-6">
        <div>
          <p className="text-muted-foreground text-sm">
            Shared company semantics
          </p>
          <h1 className="text-2xl font-semibold tracking-tight">
            Knowledge graph
          </h1>
          <p className="text-muted-foreground mt-2 max-w-3xl text-sm">
            Equipment, processes, concepts, standards, and their relationships
            live here independently from any single project.
          </p>
        </div>
        <div className="grid gap-6 xl:grid-cols-[1fr_1fr]">
          <section className="bg-card rounded-xl border">
            <div className="border-b px-4 py-3">
              <h2 className="font-semibold">Entities</h2>
            </div>
            <div className="divide-y">
              {entities.length === 0 && (
                <p className="text-muted-foreground p-4 text-sm">
                  No knowledge entities yet.
                </p>
              )}
              {entities.map((entity) => (
                <div key={entity.id} className="px-4 py-3">
                  <p className="font-medium">{entity.canonical_name}</p>
                  <p className="text-muted-foreground text-xs tracking-wide uppercase">
                    {entity.kind} · {entity.key}
                  </p>
                </div>
              ))}
            </div>
          </section>
          <section className="bg-card rounded-xl border">
            <div className="border-b px-4 py-3">
              <h2 className="font-semibold">Semantic links</h2>
            </div>
            <div className="divide-y">
              {links.length === 0 && (
                <p className="text-muted-foreground p-4 text-sm">
                  No semantic links yet.
                </p>
              )}
              {links.map((link) => (
                <div key={link.id} className="px-4 py-3 text-sm">
                  <span className="font-medium">{link.source.name}</span>
                  <span className="text-muted-foreground mx-2">
                    → {link.relation} →
                  </span>
                  <span className="font-medium">{link.target.name}</span>
                </div>
              ))}
            </div>
          </section>
        </div>
      </div>
    </AppLayout>
  )
}
