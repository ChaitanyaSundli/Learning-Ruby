class Session
  attr_accessor :current_user, :role

  def initialize
    @current_user = nil
    @role = nil
  end

  def logged_in?
    !@current_user.nil?
  end

  def logout
    @current_user = nil
    @role = nil
  end
end