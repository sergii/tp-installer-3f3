import { Head, Link, usePage } from "@inertiajs/react"

import AppLogoIcon from "@/components/app-logo-icon"
import { dashboard, sessions } from "@/routes"

export default function Welcome() {
  const { auth } = usePage().props

  return (
    <>
      <Head title="TeploTEC" />
      <main className="flex min-h-screen items-center justify-center bg-background p-6 text-foreground">
        <div className="grid w-full max-w-5xl overflow-hidden rounded-2xl border bg-card shadow-sm lg:grid-cols-[1.15fr_0.85fr]">
          <section className="flex flex-col justify-center p-8 md:p-12">
            <p className="text-sm font-medium text-muted-foreground">TeploTEC</p>
            <h1 className="mt-2 max-w-xl text-4xl font-semibold tracking-tight md:text-5xl">Installation OS for geothermal projects</h1>
            <p className="mt-5 max-w-xl text-base leading-7 text-muted-foreground">Plan installation work once, then operate it through Today, List, Kanban, ReUI Gantt, Timeline, and the knowledge graph.</p>
            <div className="mt-8 flex gap-3">
              {auth.user ? (
                <Link href={dashboard.index()} className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground">Open dashboard</Link>
              ) : (
                <Link href={sessions.new()} className="rounded-md bg-primary px-4 py-2 text-sm font-medium text-primary-foreground">Sign in</Link>
              )}
            </div>
          </section>
          <section className="flex min-h-80 items-center justify-center bg-muted/40 p-12">
            <div className="flex size-48 items-center justify-center rounded-3xl border bg-background shadow-sm">
              <AppLogoIcon className="size-32" />
            </div>
          </section>
        </div>
      </main>
    </>
  )
}
