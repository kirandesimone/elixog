defmodule Elixog.CoverImages.CoverImage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cover_images" do
    field :url, :string

    belongs_to :post, Elixog.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(cover_image, attrs) do
    cover_image
    |> cast(attrs, [:url, :post_id])
    |> validate_required([:url])
    |> foreign_key_constraint(:post)
  end
end
