class ApplicationController < ActionController::Base
  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def mobile_device?
    if session[:mobile_override]
      session[:mobile_override] == "1"
    else
      (request.user_agent =~ /Mobile|webOS/)
    end
  end
  helper_method :mobile_device?
end

class PostsController < ApplicationController
  # Render mobile or desktop depending on User-Agent for these actions.
  before_action :check_for_mobile, :only => [:new, :edit]

  # Always render mobile versions for these, regardless of User-Agent.
  before_action :prepare_for_mobile, :only => :show
end
