import Config

# Default config for tests
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
