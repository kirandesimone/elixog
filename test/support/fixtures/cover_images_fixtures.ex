defmodule Elixog.CoverImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Elixog.CoverImages` context.
  """

  @doc """
  Generate a cover_image.
  """
  def cover_image_fixture(attrs \\ %{}) do
    {:ok, cover_image} =
      attrs
      |> Enum.into(%{
        url: "https://www.example.com/image.png"
      })
      |> Elixog.CoverImages.create_cover_image()

    cover_image
  end
end
