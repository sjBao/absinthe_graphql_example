defmodule AssignmentGraphqlApiWeb.Schema.Subscriptions.User do
  use Absinthe.Schema.Notation

  object :user_subscriptions do
    @desc "Listens to changes made to a user."
    field :user_changed, :user do
      trigger(:update_user,
        topic: fn _data ->
          "user_changed"
        end
      )

      config(fn _, _ ->
        {:ok, topic: "user_changed"}
      end)
    end

    @desc "Listens to changes made to the preferences of a user."
    field :user_preferences_changed, :preferences do
      trigger(:update_user_preferences,
        topic: fn _data ->
          "user_preferences_changed"
        end
      )

      config(fn _, _ ->
        {:ok, topic: "user_preferences_changed"}
      end)
    end

    @desc "Listens for created users."
    field :user_created, :user do
      trigger(:create_user,
        topic: fn _data ->
          "user_created"
        end
      )

      config(fn _, _ ->
        {:ok, topic: "user_created"}
      end)
    end
  end
end
