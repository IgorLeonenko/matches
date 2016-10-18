class UserRepresenter
  def initialize(user)
    @user = user
  end

  def as_json(_ = {})
    {
      id: user.id,
      email: user.email,
      name: user.name,
      username: user.username,
      avatar: user.avatar
    }
  end
end