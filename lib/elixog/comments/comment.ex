defmodule Elixog.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    belongs_to :post, Elixog.Posts.Post
    belongs_to :user, Elixog.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :post_id, :user_id])
    |> validate_required([:content, :post_id, :user_id])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:user_id)
  end
end
