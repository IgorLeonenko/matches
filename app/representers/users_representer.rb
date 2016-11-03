class UsersRepresenter
  def initialize(users)
    @users = users
  end

  def basic
    @users.map { |user| UserRepresenter.new(user).basic }
  end
end
