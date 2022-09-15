module UserManager
  class AuthenticateUser
    include Interactor

    delegate :email, :password, to: :context

    def call
      user = User.find_by_email(email)

      if user&.authenticate(password)
        context.user = user
        context.message = I18n.t('notice.sessions.create.success')
      else
        context.fail!(message: I18n.t('notice.sessions.create.failure'))
      end
    end
  end
end
