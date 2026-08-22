# frozen_string_literal: true

namespace :demo do
  desc "Reset and seed the isolated TeploTEC Demo workspace"
  task seed: :environment do
    password = ENV.fetch("DEMO_PASSWORD") do
      abort "DEMO_PASSWORD is required and must contain at least 12 characters"
    end

    result = DemoWorkspaceSeed.call(password:)

    puts
    puts "TeploTEC Demo workspace is ready"
    puts "Organization: #{result.fetch(:organization).name}"
    puts "Projects: #{result.fetch(:project_count)}"
    puts "Primary project tasks: #{result.fetch(:primary_task_count)}"
    puts "Login: #{result.fetch(:admin).email}"
    puts "Password: the DEMO_PASSWORD value supplied to this command"
    puts
    puts "Re-running demo:seed resets only the #{DemoWorkspaceSeed::ORGANIZATION_NAME} workspace."
  end
end
