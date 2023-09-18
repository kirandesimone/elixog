defmodule ElixogWeb.PostControllerTest do
  use ElixogWeb.ConnCase

  import Elixog.PostsFixtures
  import Elixog.AccountsFixtures

  @create_attrs %{
    user_id: 0,
    content: "some content",
    published_on: "2023-09-11",
    visible: true,
    title: "some title",
    comments: []
  }
  @update_attrs %{
    content: "some updated content",
    published_on: "2023-09-12",
    visible: true,
    title: "some updated title",
    comments: []
  }
  @invalid_attrs %{content: nil, published_on: nil, visible: nil, title: nil, comments: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      user = user_fixture()

      conn = conn |> log_in_user(user) |> get(~p"/posts/new")
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn |> log_in_user(user) |> post(~p"/posts", post: %{@create_attrs | user_id: user.id})

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ "Post #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()

      conn = conn |> log_in_user(user) |> post(~p"/posts", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    test "renders form for editing chosen post", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      conn = conn |> log_in_user(user) |> get(~p"/posts/#{post}/edit")
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      conn = conn |> log_in_user(user) |> put(~p"/posts/#{post}", post: @update_attrs)
      assert redirected_to(conn) == ~p"/posts/#{post}"

      conn = get(conn, ~p"/posts/#{post}")
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      conn = conn |> log_in_user(user) |> put(~p"/posts/#{post}", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    test "deletes chosen post", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      conn = conn |> log_in_user(user) |> delete(~p"/posts/#{post}")
      assert redirected_to(conn) == ~p"/posts"

      assert_error_sent 404, fn ->
        get(conn, ~p"/posts/#{post}")
      end
    end
  end

  # defp create_post(_) do
  # post = post_fixture()
  # %{post: post}
  # end
end
