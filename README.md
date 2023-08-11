# Safe Inspect

[![Version](https://img.shields.io/hexpm/v/safe_inspect.svg)](https://hex.pm/packages/safe_inspect)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/safe_inspect/)
[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://opensource.org/license/apache-2-0)

## Installation

Add `:safe_inspect` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:safe_inspect, "~> 1.0.0"}
  ]
end
```

## About

Safely inspect in your logs by redacting sensitive data

```elixir
import SafeInspect

with foo <- my_func1(),
     bar <- my_func2(foo) do
  {:ok, bar}
else
  err ->
    # No fear of accidentally logging sensitive data when using the special `inspect!`
    Logger.error("Something bad happened: #{inspect!(error)}")
end
```

Your logs will look something like this, depending on your config:

```
[error] Something bad happened: {:bad_user, %User{id: 123, email: :redacted, address: :redacted}}
```

## Configuration

In you `config/config.exs` add all the keys that you want to redact. Here's an example:

```elixir
config :safe_inspect,
  redacted_keys: [
    :birth_date,
    :dob,
    :driver_license_number,
    :email,
    :ethnicity,
    :first_name,
    :full_name,
    :gender,
    :ip_address,
    :last_name,
    :nationality,
    :passport,
    :passport_number,
    :password,
    :phone,
    :phone_number,
    :salary,
    :social_security_number,
    :ssn,
    :username
  ]
```
