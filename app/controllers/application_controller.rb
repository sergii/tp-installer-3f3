# frozen_string_literal: true

class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate
  around_action :with_current_organization

  private

  def authenticate
    redirect_to sign_in_path unless perform_authentication
  end

  def require_no_authentication
    return unless perform_authentication

    flash[:notice] = "You are already signed in"
    redirect_to root_path
  end

  def perform_authentication
    Current.session ||= Session.find_by_id(cookies.signed[:session_token])
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  def require_current_organization
    return if Current.organization

    redirect_to root_path, alert: "No active workspace is available"
  end

  def with_current_organization
    membership = selected_membership
    return yield unless membership

    Current.membership = membership
    Current.organization = membership.organization
    connection = ActiveRecord::Base.connection
    connection.execute("SELECT set_config('app.current_organization', #{connection.quote(membership.organization_id.to_s)}, false)")
    yield
  ensure
    connection&.execute("RESET app.current_organization") if membership
    Current.organization = nil
    Current.membership = nil
  end

  def selected_membership
    return unless Current.user

    Current.user.memberships.active.includes(:organization).first
  end
end
