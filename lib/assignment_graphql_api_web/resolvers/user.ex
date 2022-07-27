defmodule AssignmentGraphqlApiWeb.Resolvers.User do
  alias AssignmentGraphqlApiWeb.User

  def all(params, _), do: User.all(params)

  def find(%{id: id}, _), do: id |> String.to_integer() |> User.find()

  def create_user(params, _), do: User.create(params)

  def update_user(params, _), do: User.update(params)

  def update_user_preferences(params, _), do: User.update_preferences(params)
end
