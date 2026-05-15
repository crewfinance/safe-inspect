defmodule SafeInspectTest do
  use ExUnit.Case, async: true
  doctest SafeInspect

  import SafeInspect

  defmodule Struct do
    defstruct [:foo, :dob]
  end

  test "tuple" do
    assert inspect!({:birth_date, "01211995"}) == "{:birth_date, :redacted}"
    assert inspect!({"birthDate", "01211995"}) == "{\"birthDate\", :redacted}"
    assert inspect!({{:dob, "01211995"}, :foo}) == "{{:dob, :redacted}, :foo}"

    assert inspect!({{:dob, "01211995"}, :foo, {:dob, "01211995"}}) ==
             "{{:dob, :redacted}, :foo, {:dob, :redacted}}"
  end

  test "struct" do
    assert inspect!(%Struct{dob: "01211995"}) ==
             "%SafeInspectTest.Struct{foo: nil, dob: :redacted}"

    assert inspect!(%Struct{dob: "01211995", foo: :bar}) ==
             "%SafeInspectTest.Struct{foo: :bar, dob: :redacted}"
  end

  test "maps" do
    assert inspect!(%{birth_date: "01211995"}) == "%{birth_date: :redacted}"
    assert inspect!(%{"birthDate" => "01211995"}) == "%{\"birthDate\" => :redacted}"
    assert inspect!(%{birth_date: "01211995", foo: :bar}) == "%{foo: :bar, birth_date: :redacted}"

    assert inspect!(%{"birthDate" => "01211995", foo: :bar}) ==
             "%{:foo => :bar, \"birthDate\" => :redacted}"
  end

  test "keyword" do
    assert inspect!(birth_date: "01211995") == "[birth_date: :redacted]"
    assert inspect!(birth_date: "01211995", foo: :bar) == "[birth_date: :redacted, foo: :bar]"
  end

  test "ignore nil" do
    assert inspect!({:birth_date, nil}) == "{:birth_date, nil}"
    assert inspect!(%Struct{dob: nil}) == "%SafeInspectTest.Struct{foo: nil, dob: nil}"
    assert inspect!(%{birth_date: nil}) == "%{birth_date: nil}"
    assert inspect!(birth_date: nil) == "[birth_date: nil]"
  end

  test "applies inspect_opts from config by default" do
    # Default Elixir limit is 50; test config sets 100. Lists with >50 items prove config applied.
    list = Enum.to_list(1..75)
    rendered = inspect!(list)
    assert String.contains?(rendered, "75")
    refute String.contains?(rendered, "...")
  end

  test "call opts override config inspect_opts" do
    list = Enum.to_list(1..75)
    assert inspect!(list, limit: 3) == "[1, 2, 3, ...]"
  end

  test "call opts merged with config inspect_opts when keys differ" do
    # Config sets limit: 100. Passing an unrelated call opt should not drop the config limit;
    # a 75-item list would truncate under Elixir's default limit of 50.
    list = Enum.to_list(1..75)
    rendered = inspect!(list, printable_limit: 50)
    assert String.contains?(rendered, "75")
    refute String.contains?(rendered, "...")
  end

  test "changeset" do
    assert inspect!(%{
             __struct__: Ecto.Changeset,
             data: %{},
             changes: %{birthdate: nil},
             errors: [birthdate: {"can't be blank", [validation: :required]}]
           }) ==
             "%{data: %{}, __struct__: Ecto.Changeset, errors: [birthdate: {\"can't be blank\", [validation: :required]}], changes: %{birthdate: nil}}"
  end
end
