module UserManager
  class CreateUsername
    include Interactor

    delegate :params, to: :context

    def call
      context.username = create_username(params[:full_name])
    end

    private

    def create_username(fullname)
      return 'temp' if fullname.blank?

      username = fullname.parameterize(separator: '_')
      taken_usernames = User.
                        where('username LIKE ?', "#{username}%").
                        pluck(:username)
      return username unless taken_usernames.include?(username)

      User.last.with_lock do
        suffix = User.last.id
        "#{username}_#{suffix}"
      end
    end
  end
end
