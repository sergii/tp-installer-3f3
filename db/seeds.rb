# frozen_string_literal: true

return unless Rails.env.development?

email = ENV.fetch("SEED_ADMIN_EMAIL", "admin@teplotec.local")
password = ENV.fetch("SEED_ADMIN_PASSWORD", "TeploTEC-Local-2026!")

user = User.find_or_initialize_by(email:)
user.name ||= "TeploTEC Admin"
user.password = password if user.new_record?
user.password_confirmation = password if user.new_record?
user.verified = true
user.save!

organization = Organization.find_or_create_by!(slug: "teplotec") { |record| record.name = "TeploTEC" }
Membership.find_or_create_by!(user:, organization:) { |record| record.role = "owner" }

project = Project.find_or_create_by!(organization:, code: "GEO-001") do |record|
  record.name = "Geothermal installation demo"
  record.status = "active"
  record.location = "Kyiv region"
  record.start_on = Date.current.beginning_of_week
  record.target_on = Date.current + 21.days
end

[
  ["Site survey", "done", -5, -4, 100],
  ["Heat-loss calculation", "done", -4, -2, 100],
  ["Borehole design", "in_progress", -1, 2, 60],
  ["Drilling", "todo", 3, 7, 0],
  ["Ground loop pressure test", "todo", 8, 9, 0],
  ["Heat pump installation", "todo", 10, 13, 0],
  ["Commissioning", "todo", 14, 15, 0]
].each_with_index do |(title, status, start_offset, due_offset, progress), position|
  Task.find_or_create_by!(organization:, project:, title:) do |task|
    task.created_by = user
    task.status = status
    task.position = position
    task.progress = progress
    task.start_on = Date.current + start_offset.days
    task.due_on = Date.current + due_offset.days
  end
end

puts "Development login: #{email} / #{password}"
