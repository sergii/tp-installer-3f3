# frozen_string_literal: true

class DemoWorkspaceSeed
  ORGANIZATION_NAME = "TeploTEC Demo"
  ORGANIZATION_SLUG = "teplotec-demo"

  USERS = {
    admin: ["Demo Admin", "demo.admin@teplotec.example", "owner"],
    engineer: ["Олена Коваль", "demo.engineer@teplotec.example", "member"],
    drilling: ["Денис Бондар", "demo.drilling@teplotec.example", "member"],
    service: ["Андрій Мельник", "demo.service@teplotec.example", "member"]
  }.freeze

  PRIMARY_TASKS = [
    { key: :discovery, title: "Discovery & site data", status: "done", progress: 100, start: -31, due: -24, assignee: :engineer },
    { key: :lead_qualification, title: "Кваліфікація запиту та цілей замовника", parent: :discovery, status: "done", progress: 100, start: -31, due: -30, assignee: :admin },
    { key: :collect_drawings, title: "Зібрати плани будинку та вихідні дані", parent: :discovery, status: "done", progress: 100, start: -30, due: -28, assignee: :engineer },
    { key: :site_survey, title: "Обстеження ділянки", parent: :discovery, status: "done", progress: 100, start: -27, due: -26, assignee: :engineer },
    { key: :access_check, title: "Перевірити заїзд бурової та підземні комунікації", parent: :discovery, status: "done", progress: 100, start: -26, due: -24, assignee: :drilling },

    { key: :engineering, title: "Engineering & commercial", status: "done", progress: 100, start: -23, due: -13, assignee: :engineer },
    { key: :heat_loss, title: "Розрахунок тепловтрат будинку", parent: :engineering, status: "done", progress: 100, start: -23, due: -21, assignee: :engineer },
    { key: :ground_loop_sizing, title: "Попередній розрахунок геоконтуру", parent: :engineering, status: "done", progress: 100, start: -21, due: -19, assignee: :engineer },
    { key: :equipment_selection, title: "Підібрати тепловий насос і гідравлічну схему", parent: :engineering, status: "done", progress: 100, start: -19, due: -17, assignee: :engineer },
    { key: :proposal, title: "Підготувати комерційну пропозицію", parent: :engineering, status: "done", progress: 100, start: -17, due: -16, assignee: :admin },
    { key: :customer_approval, title: "Погодження концепції замовником", parent: :engineering, kind: "milestone", status: "done", progress: 100, start: -15, due: -15, assignee: :admin },
    { key: :detailed_design, title: "Детальне проєктування системи", parent: :engineering, status: "done", progress: 100, start: -15, due: -13, assignee: :engineer },

    { key: :procurement, title: "Procurement & logistics", status: "in_progress", progress: 65, start: -12, due: 4, assignee: :admin },
    { key: :release_procurement, title: "Випустити BOM у закупівлю", parent: :procurement, status: "done", progress: 100, start: -12, due: -11, assignee: :engineer },
    { key: :heat_pump_order, title: "Замовити тепловий насос 16 кВт", parent: :procurement, status: "in_progress", progress: 70, start: -10, due: 4, assignee: :admin },
    { key: :pipe_delivery, title: "Прийняти PE100-RC трубу для геозондів", parent: :procurement, status: "in_progress", progress: 80, start: -7, due: 0, assignee: :admin },
    { key: :manifold_delivery, title: "Колектор, арматура та витратоміри", parent: :procurement, status: "blocked", progress: 35, start: -5, due: 2, assignee: :admin },

    { key: :drilling_phase, title: "Drilling & ground loop", status: "in_progress", progress: 28, start: -2, due: 10, assignee: :drilling },
    { key: :mobilize_rig, title: "Мобілізація бурової установки", parent: :drilling_phase, status: "in_progress", progress: 90, start: -2, due: 0, assignee: :drilling },
    { key: :borehole_1, title: "Свердловина BH-01 · 95 м", parent: :drilling_phase, status: "in_progress", progress: 45, start: 0, due: 2, assignee: :drilling },
    { key: :borehole_2, title: "Свердловина BH-02 · 95 м", parent: :drilling_phase, status: "todo", progress: 0, start: 2, due: 4, assignee: :drilling },
    { key: :borehole_3, title: "Свердловина BH-03 · 95 м", parent: :drilling_phase, status: "todo", progress: 0, start: 4, due: 6, assignee: :drilling },
    { key: :probe_installation, title: "Монтаж U-зондів і тампонаж", parent: :drilling_phase, status: "todo", progress: 0, start: 1, due: 7, assignee: :drilling },
    { key: :trenching, title: "Траншея від свердловин до технічного приміщення", parent: :drilling_phase, status: "todo", progress: 0, start: 6, due: 8, assignee: :drilling },
    { key: :pressure_test, title: "Гідравлічне випробування геоконтуру", parent: :drilling_phase, status: "todo", progress: 0, start: 8, due: 9, assignee: :engineer },
    { key: :ground_loop_ready, title: "Геоконтур готовий до підключення", parent: :drilling_phase, kind: "milestone", status: "todo", progress: 0, start: 10, due: 10, assignee: :engineer },

    { key: :plant_room, title: "Plant room installation", status: "todo", progress: 0, start: 9, due: 18, assignee: :engineer },
    { key: :manifold_installation, title: "Монтаж колектора геоконтуру", parent: :plant_room, status: "blocked", progress: 0, start: 9, due: 11, assignee: :engineer },
    { key: :heat_pump_positioning, title: "Доставка та встановлення теплового насоса", parent: :plant_room, status: "todo", progress: 0, start: 10, due: 11, assignee: :service },
    { key: :hydronic_piping, title: "Обв'язка теплового насоса", parent: :plant_room, status: "todo", progress: 0, start: 11, due: 14, assignee: :service },
    { key: :dhw_connection, title: "Підключення бойлера ГВП 300 л", parent: :plant_room, status: "todo", progress: 0, start: 13, due: 15, assignee: :service },
    { key: :electrical_supply, title: "Живлення, захист та автоматика", parent: :plant_room, status: "todo", progress: 0, start: 12, due: 15, assignee: :engineer },
    { key: :controls, title: "Датчики, контролер та первинні налаштування", parent: :plant_room, status: "todo", progress: 0, start: 15, due: 17, assignee: :engineer },
    { key: :fill_brine, title: "Промивка, вакуумування та заповнення геоконтуру", parent: :plant_room, status: "todo", progress: 0, start: 16, due: 18, assignee: :service },

    { key: :commissioning_phase, title: "Commissioning & handover", status: "todo", progress: 0, start: 18, due: 24, assignee: :service },
    { key: :commissioning, title: "Пусконалагодження системи", parent: :commissioning_phase, status: "todo", progress: 0, start: 18, due: 19, assignee: :service },
    { key: :tuning, title: "Балансування контурів і параметризація", parent: :commissioning_phase, status: "todo", progress: 0, start: 19, due: 21, assignee: :engineer },
    { key: :as_built, title: "As-built схема, серійні номери та фото", parent: :commissioning_phase, status: "todo", progress: 0, start: 20, due: 22, assignee: :engineer },
    { key: :customer_training, title: "Навчання замовника", parent: :commissioning_phase, status: "todo", progress: 0, start: 22, due: 22, assignee: :service },
    { key: :handover, title: "Передача системи замовнику", parent: :commissioning_phase, kind: "milestone", status: "todo", progress: 0, start: 23, due: 23, assignee: :admin },
    { key: :follow_up, title: "Контрольний дзвінок після першого тижня", parent: :commissioning_phase, status: "todo", progress: 0, start: 30, due: 30, assignee: :service }
  ].freeze

  PRIMARY_DEPENDENCIES = [
    %i[lead_qualification collect_drawings],
    %i[collect_drawings site_survey],
    %i[site_survey access_check],
    %i[site_survey heat_loss],
    %i[heat_loss ground_loop_sizing],
    %i[ground_loop_sizing equipment_selection],
    %i[equipment_selection proposal],
    %i[proposal customer_approval],
    %i[customer_approval detailed_design],
    %i[detailed_design release_procurement],
    %i[release_procurement heat_pump_order],
    %i[release_procurement pipe_delivery],
    %i[release_procurement manifold_delivery],
    %i[access_check mobilize_rig],
    %i[pipe_delivery borehole_1],
    %i[mobilize_rig borehole_1],
    %i[borehole_1 borehole_2],
    %i[borehole_2 borehole_3],
    %i[borehole_1 probe_installation],
    %i[borehole_3 trenching],
    %i[probe_installation pressure_test],
    %i[trenching pressure_test],
    %i[pressure_test ground_loop_ready],
    %i[ground_loop_ready manifold_installation],
    %i[manifold_delivery manifold_installation],
    %i[heat_pump_order heat_pump_positioning],
    %i[heat_pump_positioning hydronic_piping],
    %i[manifold_installation fill_brine],
    %i[hydronic_piping dhw_connection],
    %i[hydronic_piping electrical_supply],
    %i[electrical_supply controls],
    %i[fill_brine commissioning],
    %i[controls commissioning],
    %i[commissioning tuning],
    %i[tuning customer_training],
    %i[commissioning as_built],
    %i[as_built handover],
    %i[customer_training handover],
    %i[handover follow_up]
  ].freeze

  PROCESS_STEPS = [
    [:survey, "Site survey", 0, 2],
    [:heat_loss, "Heat-loss calculation", 2, 2],
    [:ground_loop_design, "Ground-loop design", 4, 3],
    [:proposal, "Proposal and approval", 7, 3],
    [:detailed_design, "Detailed design", 10, 3],
    [:procurement, "Procurement", 11, 10],
    [:drilling, "Borehole drilling", 14, 7],
    [:ground_loop, "Ground-loop completion", 19, 4],
    [:plant_room, "Plant-room installation", 21, 7],
    [:electrical_controls, "Electrical and controls", 24, 4],
    [:commissioning, "Commissioning", 28, 2],
    [:handover, "Handover", 30, 1]
  ].freeze

  KNOWLEDGE_ENTITIES = [
    [:system, "system.geothermal_heating", "Geothermal heating system", "Геотермальна система опалення", { lifecycle: "installed_asset" }],
    [:system, "system.ground_loop", "Ground loop", "Геотермальний контур", { circuit: "primary" }],
    [:system, "system.plant_room", "Plant room", "Технічне приміщення", {}],
    [:component, "component.heat_pump", "Heat pump", "Тепловий насос", { demo_output_kw: 16 }],
    [:component, "component.borehole", "Borehole", "Геотермальна свердловина", { demo_depth_m: 95 }],
    [:component, "component.u_probe", "U-probe", "U-подібний геозонд", {}],
    [:component, "component.pe100rc_pipe", "PE100-RC pipe", "Труба PE100-RC", { demo_nominal_diameter_mm: 40 }],
    [:component, "component.manifold", "Ground-loop manifold", "Колектор геоконтуру", {}],
    [:component, "component.check_valve", "Check valve", "Зворотний клапан", {}],
    [:component, "component.circulation_pump", "Circulation pump", "Циркуляційний насос", {}],
    [:component, "component.expansion_vessel", "Expansion vessel", "Розширювальний бак", {}],
    [:component, "component.dhw_cylinder", "DHW cylinder", "Бойлер ГВП", { demo_volume_l: 300 }],
    [:concept, "concept.brine", "Brine", "Теплоносій геоконтуру", { aliases_uk: ["розсіл", "брін"] }],
    [:substance, "substance.propylene_glycol", "Propylene glycol", "Пропіленгліколь", {}],
    [:property, "property.freezing_point", "Freezing point", "Температура замерзання", { unit: "degC" }],
    [:property, "property.viscosity", "Viscosity", "В'язкість", {}],
    [:property, "property.flow_rate", "Flow rate", "Витрата теплоносія", {}],
    [:process, "process.site_survey", "Site survey", "Обстеження ділянки", {}],
    [:process, "process.drilling", "Borehole drilling", "Буріння свердловин", {}],
    [:process, "process.pressure_test", "Pressure test", "Гідравлічне випробування", {}],
    [:process, "process.commissioning", "Commissioning", "Пусконалагодження", {}],
    [:document, "document.as_built", "As-built documentation", "Виконавча документація", {}],
    [:service, "service.follow_up", "Post-commissioning follow-up", "Контроль після запуску", {}],
    [:service, "service.annual_inspection", "Annual inspection", "Щорічний сервіс", {}]
  ].freeze

  KNOWLEDGE_LINKS = [
    ["system.geothermal_heating", "contains", "component.heat_pump"],
    ["system.geothermal_heating", "contains", "system.ground_loop"],
    ["system.geothermal_heating", "located_in", "system.plant_room"],
    ["system.ground_loop", "contains", "component.borehole"],
    ["component.borehole", "contains", "component.u_probe"],
    ["component.u_probe", "made_from", "component.pe100rc_pipe"],
    ["system.ground_loop", "uses", "concept.brine"],
    ["concept.brine", "may_contain", "substance.propylene_glycol"],
    ["concept.brine", "has_property", "property.freezing_point"],
    ["concept.brine", "has_property", "property.viscosity"],
    ["system.ground_loop", "measured_by", "property.flow_rate"],
    ["system.ground_loop", "connects_to", "component.manifold"],
    ["component.manifold", "connects_to", "component.heat_pump"],
    ["component.circulation_pump", "circulates", "concept.brine"],
    ["component.check_valve", "used_in", "system.ground_loop"],
    ["component.expansion_vessel", "used_in", "system.ground_loop"],
    ["component.dhw_cylinder", "connected_to", "component.heat_pump"],
    ["process.site_survey", "precedes", "process.drilling"],
    ["process.drilling", "followed_by", "process.pressure_test"],
    ["process.pressure_test", "precedes", "process.commissioning"],
    ["process.commissioning", "produces", "document.as_built"],
    ["process.commissioning", "followed_by", "service.follow_up"],
    ["service.follow_up", "precedes", "service.annual_inspection"]
  ].freeze

  def self.call(password:)
    new(password:).call
  end

  def initialize(password:)
    @password = password.to_s
    raise ArgumentError, "DEMO_PASSWORD must be at least 12 characters" if @password.length < 12
  end

  def call
    ActiveRecord::Base.transaction do
      @users = seed_users
      @organization = Organization.find_or_create_by!(slug: ORGANIZATION_SLUG) do |organization|
        organization.name = ORGANIZATION_NAME
      end
      @organization.update!(name: ORGANIZATION_NAME)
      seed_memberships

      within_organization do
        reset_workspace_data
        seed_process_template
        seed_knowledge_graph
        seed_primary_project
        seed_planning_project
        seed_service_project
      end
    end

    {
      organization: @organization,
      admin: @users.fetch(:admin),
      project_count: 3,
      primary_task_count: PRIMARY_TASKS.size
    }
  end

  private

  def seed_users
    USERS.to_h do |key, (name, email, _role)|
      user = User.find_or_initialize_by(email:)
      user.name = name
      user.password = @password
      user.password_confirmation = @password
      user.verified = true
      user.save!
      [key, user]
    end
  end

  def seed_memberships
    USERS.each do |key, (_name, _email, role)|
      membership = Membership.find_or_initialize_by(user: @users.fetch(key), organization: @organization)
      membership.role = role
      membership.active = true
      membership.save!
    end
  end

  def within_organization
    connection = ActiveRecord::Base.connection
    previous_organization = Current.organization
    previous_membership = Current.membership

    Current.organization = @organization
    Current.membership = @users.fetch(:admin).memberships.find_by!(organization: @organization)
    connection.execute("SELECT set_config('app.current_organization', #{connection.quote(@organization.id.to_s)}, false)")
    yield
  ensure
    connection&.execute("RESET app.current_organization")
    Current.organization = previous_organization
    Current.membership = previous_membership
  end

  def reset_workspace_data
    @organization.projects.destroy_all
    @organization.process_templates.destroy_all
    @organization.knowledge_entities.destroy_all
  end

  def seed_process_template
    template = @organization.process_templates.create!(
      key: "residential-geothermal-installation",
      name: "Residential geothermal installation",
      description: "Reference workflow for a complete residential geothermal heat-pump installation."
    )

    steps = PROCESS_STEPS.to_h do |key, name, offset_days, duration_days|
      step = template.steps.create!(
        organization: @organization,
        key: key.to_s,
        name:,
        position: PROCESS_STEPS.index([key, name, offset_days, duration_days]),
        offset_days:,
        duration_days:
      )
      [key, step]
    end

    PROCESS_STEPS.each_cons(2) do |left, right|
      template.dependencies.create!(
        organization: @organization,
        predecessor_step: steps.fetch(left.first),
        successor_step: steps.fetch(right.first),
        kind: "finish_to_start"
      )
    end
  end

  def seed_knowledge_graph
    @knowledge = KNOWLEDGE_ENTITIES.to_h do |kind, key, canonical_name, ukrainian_name, metadata|
      entity = @organization.knowledge_entities.create!(kind: kind.to_s, key:, canonical_name:, metadata:)
      entity.translations.create!(organization: @organization, locale: "en", name: canonical_name)
      entity.translations.create!(organization: @organization, locale: "uk", name: ukrainian_name)
      [key, entity]
    end

    KNOWLEDGE_LINKS.each do |source, relation, target|
      @organization.semantic_links.create!(
        source_entity: @knowledge.fetch(source),
        target_entity: @knowledge.fetch(target),
        relation:
      )
    end
  end

  def seed_primary_project
    project = @organization.projects.create!(
      code: "GEO-2026-042",
      name: "Козин · геотермальна система 16 кВт",
      status: "active",
      location: "Козин, Київська область",
      start_on: date(-31),
      target_on: date(30),
      description: <<~TEXT.strip
        DEMO PROJECT. Приватний будинок 285 м². Розрахункове теплове навантаження 14.8 кВт.
        Демонстраційна конфігурація: тепловий насос класу 16 кВт, 3 свердловини по 95 м,
        U-зонди PE100-RC, колектор у технічному приміщенні, бойлер ГВП 300 л.
        Значення створені для демонстрації workflow, Gantt, Kanban, Timeline та Knowledge Graph,
        а не як затверджений інженерний проєкт.
      TEXT
    )

    tasks = {}
    PRIMARY_TASKS.each_with_index do |spec, position|
      parent = spec[:parent] && tasks.fetch(spec[:parent])
      task = project.tasks.create!(
        organization: @organization,
        parent:,
        created_by: @users.fetch(:admin),
        assigned_to: @users.fetch(spec.fetch(:assignee)),
        title: spec.fetch(:title),
        description: demo_task_description(spec.fetch(:key)),
        status: spec.fetch(:status),
        kind: spec.fetch(:kind, "task"),
        position:,
        progress: spec.fetch(:progress),
        start_on: date(spec.fetch(:start)),
        due_on: date(spec.fetch(:due)),
        completed_at: spec.fetch(:status) == "done" ? time(spec.fetch(:due), 16) : nil
      )
      tasks[spec.fetch(:key)] = task
    end

    PRIMARY_DEPENDENCIES.each do |predecessor_key, successor_key|
      TaskDependency.create!(
        organization: @organization,
        predecessor_task: tasks.fetch(predecessor_key),
        successor_task: tasks.fetch(successor_key),
        kind: "finish_to_start"
      )
    end

    seed_events(project, tasks)
  end

  def seed_planning_project
    project = @organization.projects.create!(
      code: "GEO-2026-043",
      name: "Буча · реконструкція системи опалення 12 кВт",
      status: "planning",
      location: "Буча, Київська область",
      start_on: date(-3),
      target_on: date(24),
      description: "DEMO PROJECT. Будинок після реконструкції; порівнюємо геотермальний та повітряний сценарії."
    )

    specs = [
      ["Отримати оновлений план поверхів", "done", -3, -2, 100, :engineer],
      ["Уточнити склад огороджувальних конструкцій", "in_progress", -2, 0, 65, :engineer],
      ["Повторний виїзд на ділянку", "todo", 1, 1, 0, :engineer],
      ["Чернетка теплотехнічного розрахунку", "todo", 2, 4, 0, :engineer],
      ["Оцінити доступну площу під буріння", "todo", 3, 4, 0, :drilling],
      ["Порівняти 2 × 110 м та 3 × 75 м", "todo", 5, 7, 0, :engineer],
      ["Підготувати два бюджетні сценарії", "todo", 8, 10, 0, :admin],
      ["Презентація концепції замовнику", "todo", 11, 11, 0, :admin]
    ]

    specs.each_with_index do |(title, status, start_offset, due_offset, progress, assignee), position|
      project.tasks.create!(
        organization: @organization,
        created_by: @users.fetch(:admin),
        assigned_to: @users.fetch(assignee),
        title:,
        status:,
        position:,
        progress:,
        start_on: date(start_offset),
        due_on: date(due_offset),
        completed_at: status == "done" ? time(due_offset, 15) : nil
      )
    end

    project.project_events.create!(
      organization: @organization,
      actor: @users.fetch(:admin),
      event_type: "project.created",
      occurred_at: time(-3, 9),
      metadata: { source: "website", demo: true }
    )
  end

  def seed_service_project
    project = @organization.projects.create!(
      code: "SRV-2026-018",
      name: "Ірпінь · сезонний сервіс геотермальної системи",
      status: "active",
      location: "Ірпінь, Київська область",
      start_on: date(-2),
      target_on: date(2),
      description: "DEMO SERVICE CASE. Перевірка роботи системи перед опалювальним сезоном."
    )

    specs = [
      ["Отримати історію помилок контролера", "done", -2, -1, 100],
      ["Перевірити тиск первинного контуру", "in_progress", -1, 0, 60],
      ["Перевірити концентрацію теплоносія", "todo", 0, 0, 0],
      ["Почистити фільтри та оглянути арматуру", "todo", 0, 1, 0],
      ["Зафіксувати робочі температури після сервісу", "todo", 1, 1, 0],
      ["Сформувати сервісний звіт", "todo", 1, 2, 0]
    ]

    specs.each_with_index do |(title, status, start_offset, due_offset, progress), position|
      project.tasks.create!(
        organization: @organization,
        created_by: @users.fetch(:admin),
        assigned_to: @users.fetch(:service),
        title:,
        status:,
        position:,
        progress:,
        start_on: date(start_offset),
        due_on: date(due_offset),
        completed_at: status == "done" ? time(due_offset, 17) : nil
      )
    end

    project.project_events.create!(
      organization: @organization,
      actor: @users.fetch(:service),
      event_type: "service.visit_scheduled",
      occurred_at: time(-2, 12),
      metadata: { demo: true }
    )
  end

  def seed_events(project, tasks)
    events = [
      ["project.created", -31, 10, nil, { source: "website", demo: true }],
      ["site.survey_completed", -26, 17, :site_survey, { access: "confirmed", demo: true }],
      ["design.heat_loss_completed", -21, 18, :heat_loss, { heat_load_kw: 14.8, demo: true }],
      ["proposal.sent", -16, 12, :proposal, { revision: 2, demo: true }],
      ["design.approved", -15, 16, :customer_approval, { approved_by: "customer", demo: true }],
      ["procurement.released", -11, 11, :release_procurement, { bom_revision: 3, demo: true }],
      ["drilling.mobilization_started", -2, 8, :mobilize_rig, { crew: "Drilling crew A", demo: true }],
      ["delivery.pipe_received", -1, 14, :pipe_delivery, { material: "PE100-RC", demo: true }]
    ]

    events.each do |event_type, day_offset, hour, task_key, metadata|
      project.project_events.create!(
        organization: @organization,
        task: task_key && tasks.fetch(task_key),
        actor: @users.fetch(task_key == :mobilize_rig ? :drilling : :admin),
        event_type:,
        occurred_at: time(day_offset, hour),
        metadata:
      )
    end
  end

  def demo_task_description(key)
    {
      borehole_1: "Demo: запланована глибина 95 м. Фактичні значення мають фіксуватися окремо після буріння.",
      borehole_2: "Demo: друга свердловина геополя.",
      borehole_3: "Demo: третя свердловина геополя.",
      pipe_delivery: "Demo procurement item: PE100-RC U-probe pipe for three boreholes.",
      manifold_delivery: "Навмисно blocked у demo, щоб Kanban і Today показували проблемну роботу.",
      pressure_test: "Перед переходом до plant-room робіт геоконтур має пройти випробування.",
      commissioning: "Пуск, перевірка напрямків потоків, температур, аварій та базових уставок.",
      as_built: "Фото, схема фактичної конфігурації, серійні номери й ключові commissioning values."
    }[key]
  end

  def date(offset)
    Date.current + offset
  end

  def time(offset, hour)
    Time.zone.local(date(offset).year, date(offset).month, date(offset).day, hour)
  end
end
