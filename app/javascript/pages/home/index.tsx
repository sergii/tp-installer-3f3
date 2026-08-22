import { Head, Link, usePage } from "@inertiajs/react"

import AppLogoIcon from "@/components/app-logo-icon"
import { dashboard, sessions } from "@/routes"

export default function Welcome() {
  const { auth } = usePage().props

  return (
    <>
      <Head title="TeploTEC" />
      <main className="bg-background text-foreground flex min-h-screen items-center justify-center p-6">
        <div className="bg-card grid w-full max-w-5xl overflow-hidden rounded-2xl border shadow-sm lg:grid-cols-[1.15fr_0.85fr]">
          <section className="flex flex-col justify-center p-8 md:p-12">
            <p className="text-muted-foreground text-sm font-medium">
              TeploTEC
            </p>
            <h1 className="mt-2 max-w-xl text-4xl font-semibold tracking-tight md:text-5xl">
              Installation OS for geothermal projects
            </h1>
            <p className="text-muted-foreground mt-5 max-w-xl text-base leading-7">
              Plan installation work once, then operate it through Today, List,
              Kanban, ReUI Gantt, Timeline, and the knowledge graph.
            </p>
            <div className="mt-8 flex gap-3">
              {auth.user ? (
                <Link
                  href={dashboard.index()}
                  className="bg-primary text-primary-foreground rounded-md px-4 py-2 text-sm font-medium"
                >
                  Open dashboard
                </Link>
              ) : (
                <Link
                  href={sessions.new()}
                  className="bg-primary text-primary-foreground rounded-md px-4 py-2 text-sm font-medium"
                >
                  Sign in
                </Link>
              )}
            </div>
          </section>
          <section className="bg-muted/40 flex min-h-80 items-center justify-center p-12">
            <div className="bg-background flex size-48 items-center justify-center rounded-3xl border shadow-sm">
              <AppLogoIcon className="size-32" />
            </div>
          </section>
        </div>
      </main>
    </>
  )
}
