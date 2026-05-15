import Config

# Default config for tests
config :safe_inspect,
  redacted_keys: [:birth_date, :dob],
  inspect_opts: [limit: 100]
