class UsersRepresenter
  def initialize(users)
    @users = users
  end

  def as_json(_ = {})
    @users.map do |user|
      {
        id: user.id,
        email: user.email,
        name: user.name,
        username: user.username,
        avatar: user.avatar
      }
    end
  end
end