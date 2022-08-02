defmodule AssignmentGraphqlApiWeb.User do
  alias AssignmentGraphqlApiWeb.Database

  def all(filters) do
    users = Database.get_users()

    case filters
         |> Map.keys()
         |> Enum.reduce(users, fn key, acc ->
           Enum.filter(acc, &(&1.preferences[key] === filters[key]))
         end) do
      [] -> {:error, %{message: "No users found", details: filters}}
      users -> {:ok, users}
    end
  end

  def all, do: {:ok, Database.get_users()}

  def find(id) when is_binary(id), do: find(String.to_integer(id))

  def find(id) do
    users = Database.get_users()

    case Enum.find(users, &(&1.id === id)) do
      nil -> {:error, %{message: "User not found", details: %{id: id}}}
      user -> {:ok, user}
    end
  end

  def create(params) do
    with new_user <- %{
           id: UUID.uuid1(),
           name: params[:name],
           email: params[:email],
           preferences:
             Map.merge(
               %{
                 likes_emails: true,
                 likes_phone_calls: true,
                 likes_faxes: true
               },
               Map.get(params, :preferences) || %{}
             )
         },
         :ok <- Database.create_user(new_user) do
      {:ok, new_user}
    else
      _ -> {:error, %{message: "User could not be created"}}
    end
  end

  def update(%{id: id} = params) do
    users = Database.get_users()

    with {:ok, user} <- find(id),
         updated_user_preferences =
           Map.merge(user.preferences, Map.get(params, :preferences) || %{}),
         updated_user =
           Map.merge(
             user,
             Map.merge(Map.delete(params, :id), %{preferences: updated_user_preferences})
           ),
         updated_users =
           Enum.map(users, fn user ->
             if user.id === String.to_integer(id) do
               updated_user
             else
               user
             end
           end),
         :ok <- Database.update_users(updated_users) do
      {:ok, updated_user}
    end
  end

  def update_preferences(%{id: id} = params) do
    users = Database.get_users()

    with {:ok, user} <- find(id),
         updated_user_preferences = Map.merge(user.preferences, params),
         updated_user = Map.merge(user, %{preferences: updated_user_preferences}),
         updated_users =
           Enum.map(users, fn user ->
             if user.id === String.to_integer(id) do
               updated_user
             else
               user
             end
           end),
         :ok <- Database.update_users(updated_users) do
      {:ok, updated_user_preferences}
    end
  end
end
