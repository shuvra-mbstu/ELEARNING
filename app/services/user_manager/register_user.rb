module UserManager
  class RegisterUser
    include Interactor::Organizer

    organize CreateUsername, CreateUser
  end
end
