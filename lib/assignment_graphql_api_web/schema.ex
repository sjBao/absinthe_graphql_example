defmodule AssignmentGraphqlApiWeb.Schema do
  use Absinthe.Schema

  import_types AssignmentGraphqlApiWeb.Types.User
  import_types AssignmentGraphqlApiWeb.Schema.Queries.User
  import_types AssignmentGraphqlApiWeb.Schema.Mutation.User
  import_types AssignmentGraphqlApiWeb.Schema.Subscriptions.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end
end
