defmodule AssignmentGraphqlApiWeb.User do
  # mock user data source
  @db_path "lib/assignment_graphql_api_web/users.json"

  def all(filters) do
    case filters
         |> Map.keys()
         |> Enum.reduce(db_read(), fn key, acc ->
           Enum.filter(acc, &(&1.preferences[key] === filters[key]))
         end) do
      [] -> {:error, %{message: "No users found", details: filters}}
      users -> {:ok, users}
    end
  end

  def all(), do: {:ok, db_read()}

  def find(id) when is_binary(id), do: find(String.to_integer(id))

  def find(id) do
    case Enum.find(db_read(), &(&1.id === id)) do
      nil -> {:error, %{message: "User not found", details: %{id: id}}}
      user -> {:ok, user}
    end
  end

  def create(params) do
    new_user = %{
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
          params[:preferences]
        )
    }

    db_write([new_user | db_read()])

    {:ok, new_user}
  end

  def update(%{id: id} = params) do
    {:ok, user} = find(id)
    updated_user_preferences = Map.merge(user.preferences, Map.get(params, :preferences) || %{})

    updated_user =
      Map.merge(
        user,
        Map.merge(Map.delete(params, :id), %{preferences: updated_user_preferences})
      )

    db_write(
      Enum.map(db_read(), fn user ->
        if user.id === String.to_integer(id) do
          updated_user
        else
          user
        end
      end)
    )

    {:ok, updated_user}
  end

  def update_preferences(%{id: id} = params) do
    {:ok, user} = find(id)
    updated_user_preferences = Map.merge(user.preferences, params)
    updated_user = Map.merge(user, %{preferences: updated_user_preferences})

    db_write(
      Enum.map(db_read(), fn user ->
        if user.id === String.to_integer(id) do
          updated_user
        else
          user
        end
      end)
    )

    {:ok, updated_user_preferences}
  end

  defp db_read do
    {:ok, raw_txt} = IO.inspect(File.read("lib/assignment_graphql_api_web/users.json"))
    {:ok, users_data} = Jason.decode(raw_txt, keys: :atoms)

    users_data
  end

  defp db_write(users) do
    {:ok, text} = Jason.encode(users)
    File.write(@db_path, text)
  end
end
