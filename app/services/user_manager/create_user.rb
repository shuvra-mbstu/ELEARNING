module UserManager
  class CreateUser
    include Interactor

    delegate :username, :params, to: :context

    def call
      params.merge!(username: username)
      user = User.create(params)
      context.user = user
      context.message = I18n.t('notice.create.success',
                               resource: I18n.t('views.shared.account'))
      return if user.persisted?

      context.fail!(message: I18n.t('notice.create.failure',
                                    resource: I18n.t('views.shared.account')))
    end
  end
end
