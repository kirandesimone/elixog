defmodule Elixog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :published_on, :date
    field :visible, :boolean
    field :title, :string
    has_many :comments, Elixog.Comments.Comment
    belongs_to :user, Elixog.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :published_on, :visible, :content, :user_id])
    |> validate_required([:title, :visible, :content, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
