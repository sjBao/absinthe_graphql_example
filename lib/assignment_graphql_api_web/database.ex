# mock user data source
defmodule AssignmentGraphqlApiWeb.Database do
  use GenServer

  @db_path "lib/assignment_graphql_api_web/users.json"

  def start_link(_state) do
    with {:ok, users} <- db_read(),
         {:ok, pid} <- GenServer.start_link(__MODULE__, users, name: :users_database) do
      {:ok, pid}
    else
      _ -> {:error, %{message: "Could not start database"}}
    end
  end

  def get_users do
    GenServer.call(:users_database, {:get_users})
  end

  def create_user(new_user) do
    GenServer.cast(:users_database, {:create_user, new_user})
  end

  def update_users(updated_users) do
    GenServer.cast(:users_database, {:update_users, updated_users})
  end

  def init(initial_data) do
    {:ok, initial_data}
  end

  def handle_call({:get_users}, _from, users) do
    {:reply, users, users}
  end

  def handle_cast({:update_users, users_data}, _state) do
    {:ok, pid} = GenServer.start_link(__MODULE__, users_data)
    GenServer.cast(pid, {:write_to_db, users_data})

    {:noreply, users_data}
  end

  def handle_cast({:create_user, new_user}, users) do
    updated_users = [new_user | users]
    {:ok, pid} = GenServer.start_link(__MODULE__, updated_users)
    GenServer.cast(pid, {:write_to_db, updated_users})

    {:noreply, updated_users}
  end

  def handle_cast({:write_to_db, users}, _state) do
    case db_write(users) do
      {:ok, users_data} -> {:stop, :normal, users_data}
      _ -> {:stop, :error, %{message: "Could not write to database"}}
    end
  end

  defp db_read do
    with {:ok, raw_txt} <- File.read(@db_path),
         {:ok, users_data} <- Jason.decode(raw_txt, keys: :atoms) do
      {:ok, users_data}
    else
      {:error, :enoent} ->
        File.write(@db_path, "[]")
        {:ok, []}
      _ -> {:error, %{message: "Failed to read users data"}}
    end
  end

  defp db_write(users) do
    with {:ok, raw_txt} <- Jason.encode(users, keys: :atoms),
         :ok <- File.write(@db_path, raw_txt) do
      {:ok, users}
    else
      _ -> {:error, %{message: "Failed to write users data"}}
    end
  end
end
