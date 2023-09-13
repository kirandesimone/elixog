defmodule Elixog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :published_on, :date
    field :visible, :boolean
    field :title, :string
    has_many :comments, Elixog.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :published_on, :visible, :content])
    |> validate_required([:title, :published_on, :visible, :content])
  end
end
