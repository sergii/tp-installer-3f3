# frozen_string_literal: true

class ProcessDependencyTemplate < ApplicationRecord
  include OrganizationScoped

  belongs_to :process_template
  belongs_to :predecessor_step, class_name: "ProcessStepTemplate"
  belongs_to :successor_step, class_name: "ProcessStepTemplate"
end
