defmodule Elixog.CoverImagesTest do
  use Elixog.DataCase

  alias Elixog.CoverImages

  describe "cover_images" do
    alias Elixog.CoverImages.CoverImage

    import Elixog.CoverImagesFixtures
    import Elixog.AccountsFixtures
    import Elixog.PostsFixtures

    @invalid_attrs %{url: nil, post_id: nil}

    test "list_cover_images/0 returns all cover_images" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      cover_image = cover_image_fixture(post_id: post.id)
      assert CoverImages.list_cover_images() == [cover_image]
    end

    test "get_cover_image!/1 returns the cover_image with given id" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      cover_image = cover_image_fixture(post_id: post.id)
      assert CoverImages.get_cover_image!(cover_image.id) == cover_image
    end

    test "create_cover_image/1 with valid data creates a cover_image" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      valid_attrs = %{url: "some url", post_id: post.id}

      assert {:ok, %CoverImage{} = cover_image} = CoverImages.create_cover_image(valid_attrs)
      assert cover_image.url == "some url"
    end

    test "create_cover_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CoverImages.create_cover_image(@invalid_attrs)
    end

    test "update_cover_image/2 with valid data updates the cover_image" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      cover_image = cover_image_fixture(post_id: post.id)

      update_attrs = %{url: "some updated url"}

      assert {:ok, %CoverImage{} = cover_image} =
               CoverImages.update_cover_image(cover_image, update_attrs)

      assert cover_image.url == "some updated url"
    end

    test "update_cover_image/2 with invalid data returns error changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      cover_image = cover_image_fixture(post_id: post.id)

      assert {:error, %Ecto.Changeset{}} =
               CoverImages.update_cover_image(cover_image, @invalid_attrs)

      assert cover_image == CoverImages.get_cover_image!(cover_image.id)
    end

    test "delete_cover_image/1 deletes the cover_image" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      cover_image = cover_image_fixture(post_id: post.id)

      assert {:ok, %CoverImage{}} = CoverImages.delete_cover_image(cover_image)
      assert_raise Ecto.NoResultsError, fn -> CoverImages.get_cover_image!(cover_image.id) end
    end

    test "change_cover_image/1 returns a cover_image changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      cover_image = cover_image_fixture(post_id: post.id)

      assert %Ecto.Changeset{} = CoverImages.change_cover_image(cover_image)
    end
  end
end
