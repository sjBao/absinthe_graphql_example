import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :assignment_graphql_api, AssignmentGraphqlApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "VA1WrywmFYb/bgAxKCaNqIHz33m61r23x+rQ7xHbzxqDuArpO7/EYvVD62sVvDe9",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
