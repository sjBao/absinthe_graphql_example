defmodule AssignmentGraphqlApiWeb.Router do
  use AssignmentGraphqlApiWeb, :router

  # pipeline :browser do
  #   plug :accepts, ["html"]
  #   plug :fetch_session
  #   plug :fetch_live_flash
  #   plug :put_root_layout, {AssignmentGraphqlApiWeb.LayoutView, :root}
  #   plug :protect_from_forgery
  #   plug :put_secure_browser_headers
  # end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: AssignmentGraphqlApiWeb.Schema

    if Mix.env() === :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: AssignmentGraphqlApiWeb.Schema,
        socket: AssignmentGraphqlApiWeb.UserSocket,
        interface: :playground
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", AssignmentGraphqlApiWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :api

      live_dashboard "/dashboard", metrics: AssignmentGraphqlApiWeb.Telemetry
    end
  end
end
