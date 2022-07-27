defmodule AssignmentGraphqlApiWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation
  alias AssignmentGraphqlApiWeb.Resolvers

  object :user_queries do
    @desc "Return a single user by id."
    field :user, :user do
      arg :id, non_null(:id)

      resolve &Resolvers.User.find/2
    end

    @desc "Retrieve a list of users matching the given preference filters."
    field :users, list_of(:user) do
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean
      arg :likes_faxes, :boolean

      resolve &Resolvers.User.all/2
    end
  end
end
