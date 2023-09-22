defmodule Elixog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :published_on, :date
    field :visible, :boolean
    field :title, :string

    belongs_to :user, Elixog.Accounts.User
    has_one :cover_image, Elixog.CoverImages.CoverImage, on_replace: :update
    has_many :comments, Elixog.Comments.Comment
    many_to_many :tags, Elixog.Tags.Tag, join_through: "posts_tags", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(post, attrs, tags \\ []) do
    post
    |> cast(attrs, [:title, :published_on, :visible, :content, :user_id])
    |> cast_assoc(:cover_image)
    |> validate_required([:title, :visible, :content, :user_id])
    |> foreign_key_constraint(:user_id)
    |> put_assoc(:tags, tags)
  end
end
