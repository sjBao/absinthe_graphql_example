defmodule AssignmentGraphqlApiWeb.Schema.Subscriptions.User do
  use Absinthe.Schema.Notation

  object :user_subscriptions do
    @desc "Listens to changes made to a user."
    field :user_changed, :user do
      arg :user_id, non_null(:id)

      trigger :update_user,
        topic: fn data ->
          "user_changed:#{data[:id]}"
        end

      config fn args, _ ->
        {:ok, topic: "user_changed:#{args.user_id}"}
      end
    end

    @desc "Listens to changes made to the preferences of a user."
    field :user_preferences_changed, :preferences do
      arg :user_id, non_null(:id)

      trigger :update_user_preferences,
        topic: fn data ->
          "user_preferences_changed:#{data[:id]}"
        end

      config fn args, _ ->
        {:ok, topic: "user_preferences_changed:#{args.user_id}"}
      end
    end

    @desc "Listens for created users."
    field :user_created, :user do
      trigger :create_user,
        topic: fn _user ->
          "user_created"
        end

      config fn _, _ ->
        {:ok, topic: "user_created"}
      end
    end
  end
end
