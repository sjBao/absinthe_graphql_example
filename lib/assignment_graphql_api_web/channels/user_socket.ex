defmodule AssignmentGraphqlApiWeb.UserSocket do
    use Phoenix.Socket
    use Absinthe.Phoenix.Socket, schema: AssignmentGraphqlApiWeb.Schema

    channel "users:*", AssignmentGraphqlApiWeb.UserChannel

    @impl true
    def connect(_params, socket, _connect_info) do
        {:ok, socket}
    end

    @impl true
    def id(_socket), do: nil
end
