defmodule Elixog.TagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Elixog.Tags` context.
  """

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Elixog.Tags.create_tag()

    tag
  end
end
