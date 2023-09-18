defmodule Elixog.PostsTest do
  use Elixog.DataCase

  alias Elixog.Posts
  alias Elixog.Comments

  describe "posts" do
    alias Elixog.Posts.Post

    import Elixog.PostsFixtures
    import Elixog.CommentsFixtures
    import Elixog.AccountsFixtures

    @invalid_attrs %{content: nil, published_on: nil, visible: nil, title: nil}

    test "list_posts/0 returns all posts" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert Posts.list_posts() == [Repo.preload(post, :comments)]
    end

    test "list_posts/0 returns empty with false visibility" do
      user = user_fixture()

      false_attr = %{
        user_id: user.id,
        content: "false test",
        title: "false post",
        visible: false,
        published_on: "2023-09-11"
      }

      post_fixture(false_attr)
      assert Posts.list_posts() == []
    end

    test "get_post!/1 returns the post with given id and associated comments" do
      user = user_fixture()
      post = Repo.preload(post_fixture(user_id: user.id), [:user, comments: [:user]])
      comment = Repo.preload(comment_fixture(user_id: user.id, post_id: post.id), :user)
      assert Posts.get_post!(post.id).comments == [comment]
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()

      valid_attrs = %{
        user_id: user.id,
        content: "some content",
        published_on: "2023-09-12",
        visible: true,
        title: "some title"
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.published_on == ~D[2023-09-12]
      assert post.visible == true
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      update_attrs = %{
        "content" => "some updated content",
        "published_on" => "2023-09-12",
        "visible" => true,
        "title" => "some updated title"
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.visible == true
      assert post.published_on == ~D[2023-09-12]
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      pre_load_post = Repo.preload(post, [:user, comments: [:user]])
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(pre_load_post, @invalid_attrs)
      assert pre_load_post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      comment = comment_fixture(user_id: user.id, post_id: post.id)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_post/1 returns a post changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
