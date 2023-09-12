defmodule Elixog.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Elixog.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        published_on: "2023-09-11",
        visible: true,
        title: "some title"
      })
      |> Elixog.Posts.create_post()

    post
  end
end
