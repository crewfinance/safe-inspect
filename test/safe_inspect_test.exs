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
    assert inspect!(%{birth_date: "01211995", foo: :bar}) ==  "%{foo: :bar, birth_date: :redacted}"

    assert inspect!(%{"birthDate" => "01211995", foo: :bar}) ==
             "%{:foo => :bar, \"birthDate\" => :redacted}"
  end

  test "keyword" do
    assert inspect!(birth_date: "01211995") == "[birth_date: :redacted]"
    assert inspect!(birth_date: "01211995", foo: :bar) == "[birth_date: :redacted, foo: :bar]"
  end
end
