# frozen_string_literal: true

return unless Rails.env.development?

password = ENV.fetch("DEMO_PASSWORD", "TeploTEC-Demo-2026!")
result = DemoWorkspaceSeed.call(password:)

puts "Development demo login: #{result.fetch(:admin).email} / #{password}"
puts "Demo workspace: #{result.fetch(:organization).name}"
