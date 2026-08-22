# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :session, :organization, :membership
  attribute :user_agent, :ip_address

  delegate :user, to: :session, allow_nil: true
end
