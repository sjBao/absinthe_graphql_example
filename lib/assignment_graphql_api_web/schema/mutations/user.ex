defmodule AssignmentGraphqlApiWeb.Schema.Mutation.User do
  use Absinthe.Schema.Notation
  alias AssignmentGraphqlApiWeb.Resolvers

  input_object :preference_input do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end

  object :user_mutations do
    @desc "Creates a new user and returns it."
    field :create_user, :user do
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:preferences, :preference_input)

      resolve(&Resolvers.User.create_user/2)
    end

    @desc "Updates an existing user and returns it."
    field :update_user, :user do
      arg(:id, non_null(:id))
      arg(:name, :string)
      arg(:email, :string)
      arg(:preferences, :preference_input)

      resolve(&Resolvers.User.update_user/2)
    end

    @desc "Updates the preference of an existing user by id and returns it."
    field :update_user_preferences, :preferences do
      arg(:id, non_null(:id))
      arg(:likes_emails, :boolean)
      arg(:likes_phone_calls, :boolean)
      arg(:likes_faxes, :boolean)

      resolve(&Resolvers.User.update_user_preferences/2)
    end
  end
end
