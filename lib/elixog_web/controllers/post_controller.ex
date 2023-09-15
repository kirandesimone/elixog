defmodule ElixogWeb.PostController do
  use ElixogWeb, :controller

  alias Elixog.Comments
  alias Elixog.Comments.Comment
  alias Elixog.Posts
  alias Elixog.Posts.Post

  plug :require_user_owns_post when action in [:edit, :update, :delete]

  def index(conn, %{"search" => title}) do
    searched_posts = Posts.search_for_post(title)
    render(conn, :index, posts: searched_posts)
  end

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, :index, posts: posts)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, :new, changeset: changeset, current_user: conn.assigns[:current_user])
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def create(conn, %{"comment" => comment_params}) do
    case Comments.create_comment(comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/posts/#{comment.post_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :show, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Comments.change_comment(%Comment{})

    render(conn, :show,
      post: post,
      changeset: changeset,
      current_user: conn.assigns[:current_user]
    )
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Posts.change_post(post)

    render(conn, :edit,
      post: post,
      changeset: changeset,
      current_user: conn.assigns[:current_user]
    )
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: ~p"/posts")
  end

  defp require_user_owns_post(conn, _params) do
    post_id = String.to_integer(conn.path_params["id"])
    post = Posts.get_post!(post_id)

    if conn.assigns[:current_user].id == post.user_id do
      conn
    else
      conn
      |> put_flash(:error, "You can only edit or delete your own posts.")
      |> redirect(to: ~p"/posts/#{post_id}")
      |> halt()
    end
  end
end
