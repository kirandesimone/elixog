defmodule Elixog.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Elixog.Repo

  alias Elixog.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(title) do
    search = "%#{title}%"

    Post
    |> join(:left, [p], c in assoc(p, :comments))
    |> where([p], p.visible and ilike(p.title, ^search))
    |> preload([p, c], [:tags, comments: c])
    |> order_by([p], desc: p.inserted_at)
    |> Repo.all()
  end

  def list_posts do
    Post
    |> join(:left, [p], c in assoc(p, :comments))
    |> where([p], p.visible)
    |> preload([p, c], [:tags, comments: c])
    |> order_by([p], desc: p.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Post
    |> join(:left, [p], c in assoc(p, :comments))
    |> preload([p, c], [:user, :tags, comments: {c, :user}])
    |> Repo.get!(id)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}, tags \\ []) do
    # atom_attrs = key_to_atom(attrs)
    %Post{}
    |> Post.changeset(attrs, tags)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs, tags \\ []) do
    post
    |> Post.changeset(attrs, tags)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @doc """
  Returns ALL posts that have the same title

  ## Examples

      iex> search_for_post("title")
      [%Post{}]

  """

  # def key_to_atom(map) do
  #  Enum.reduce(map, %{}, fn
  #    {key, value}, acc when is_atom(key) -> Map.put(acc, key, value)
  #    {key, value}, acc when is_binary(key) -> Map.put(acc, String.to_existing_atom(key), value)
  #  end)
  # end
end
