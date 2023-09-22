defmodule Elixog.PostsTest do
  use Elixog.DataCase

  alias Elixog.Posts
  alias Elixog.Comments

  describe "posts" do
    alias Elixog.Posts.Post
    alias Elixog.CoverImages.CoverImage

    import Elixog.PostsFixtures
    import Elixog.CommentsFixtures
    import Elixog.AccountsFixtures
    import Elixog.TagsFixtures

    @invalid_attrs %{content: nil, published_on: nil, visible: nil, title: nil, cover_image: nil}

    test "list_posts/0 returns all posts" do
      user = user_fixture()

      post =
        post_fixture(user_id: user.id, cover_image: %{url: "https://www.example.com/image.png"})

      assert Posts.list_posts() == [Repo.preload(post, :comments)]
    end

    test "list_posts/0 returns empty with false visibility" do
      user = user_fixture()

      false_attr = %{
        user_id: user.id,
        content: "false test",
        title: "false post",
        visible: false,
        published_on: "2023-09-11",
        cover_image: %{
          url: "https://www.example.com/image.png"
        }
      }

      post_fixture(false_attr)
      assert Posts.list_posts() == []
    end

    test "get_post!/1 returns the post with given id and comments" do
      user = user_fixture()

      post =
        Repo.preload(
          post_fixture(
            user_id: user.id,
            cover_image: %{url: "https://www.example.com/image.png"}
          ),
          [:user, :cover_image, comments: [:user]]
        )

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
        title: "some title",
        cover_image: %{
          url: "https://www.example.com/image.png"
        }
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.published_on == ~D[2023-09-12]
      assert post.visible == true
      assert post.title == "some title"

      assert %CoverImage{url: "https://www.example.com/image.png"} =
               Repo.preload(post, :cover_image).cover_image
    end

    test "create_post/1 with tags" do
      user = user_fixture()
      tag1 = tag_fixture()
      tag2 = tag_fixture()

      valid_attrs1 = %{
        content: "post 1",
        title: "title post 1",
        visible: true,
        published_on: "2023-03-01",
        user_id: user.id,
        cover_image: %{
          url: "https://www.example.com/image.png"
        }
      }

      valid_attrs2 = %{
        content: "post 2",
        title: "title post 2",
        visible: true,
        published_on: "2023-05-08",
        user_id: user.id,
        cover_image: %{
          url: "https://www.example.com/image.png"
        }
      }

      assert {:ok, %Post{} = post1} = Posts.create_post(valid_attrs1, [tag1, tag2])
      assert {:ok, %Post{} = post2} = Posts.create_post(valid_attrs2, [tag2])

      assert Repo.preload(post1, :tags).tags == [tag1, tag2]
      assert Repo.preload(post2, :tags).tags == [tag2]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      user = user_fixture()

      post =
        post_fixture(user_id: user.id, cover_image: %{url: "https://www.example.com/image.png"})

      update_attrs = %{
        content: "some updated content",
        published_on: "2023-09-12",
        visible: true,
        title: "some updated title",
        cover_image: %{
          url: "https://www.example.com/image2.png"
        }
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.visible == true
      assert post.published_on == ~D[2023-09-12]
      assert post.title == "some updated title"
      assert post.cover_image.url == "https://www.example.com/image2.png"
    end

    test "update_post/2 with tags" do
      user = user_fixture()
      tag1 = tag_fixture()
      tag2 = tag_fixture()

      post =
        post_fixture(
          %{user_id: user.id, cover_image: %{url: "https://www.example.com/image.png"}},
          [tag1]
        )

      update_attrs = %{
        content: "Updated Content",
        title: "Updated Title",
        visible: true,
        published_on: "2023-10-10"
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs, [tag2])
      assert post.content == "Updated Content"
      assert post.title == "Updated Title"
      assert post.visible == true
      assert post.published_on == ~D[2023-10-10]

      assert Repo.preload(post, :tags).tags == [tag2]
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = user_fixture()

      post =
        post_fixture(user_id: user.id, cover_image: %{url: "https://www.example.com/image.png"})

      pre_load_post = Repo.preload(post, [:user, comments: [:user]])
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(pre_load_post, @invalid_attrs)
      assert pre_load_post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      user = user_fixture()

      post =
        post_fixture(user_id: user.id, cover_image: %{url: "https://www.example.com/image.png"})

      comment = comment_fixture(user_id: user.id, post_id: post.id)

      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(CoverImage, post.cover_image.id) end
    end

    test "delete_post/1 deletes a post with tags" do
      user = user_fixture()
      tag = tag_fixture()

      post =
        post_fixture(
          %{user_id: user.id, cover_image: %{url: "https://www.example.com/image.png"}},
          [tag]
        )

      query = from p in Post, join: t in assoc(p, :tags), on: t.id == ^tag.id

      assert {:ok, %Post{} = post} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
      refute Repo.exists?(query)
    end

    test "change_post/1 returns a post changeset" do
      user = user_fixture()

      post =
        post_fixture(user_id: user.id, cover_image: %{url: "https://www.example.com/image.png"})

      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
