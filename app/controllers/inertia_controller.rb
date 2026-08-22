# frozen_string_literal: true

class InertiaController < ApplicationController
  inertia_config default_render: true
  inertia_share auth: {
    user: -> { Current.user.as_json(only: %i[id name email verified created_at updated_at]) },
    session: -> { Current.session.as_json(only: %i[id]) }
  }
  inertia_share organization: -> {
    Current.organization && Current.organization.as_json(only: %i[id name slug])
  }
  inertia_share membership: -> {
    Current.membership && {
      role: Current.membership.role,
      admin: Current.membership.admin?
    }
  }
end
