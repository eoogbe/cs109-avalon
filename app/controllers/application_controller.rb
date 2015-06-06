class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private
  
  def self.helper_attr *attrs
    attr_accessor(*attrs)
    helper_method(*attrs)
  end
end
