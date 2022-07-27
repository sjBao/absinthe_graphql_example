defmodule AssignmentGraphqlApiWeb.Types.User do
  use Absinthe.Schema.Notation

  @desc "Object representing a user of the application."
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :preferences, :preferences
  end

  @desc "Object representing user preference filters."
  object :preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end
end
