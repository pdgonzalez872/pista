defmodule Pista.LivestreamsTest do
  use Pista.DataCase

  alias Pista.Livestreams

  describe "youtube_channels" do
    alias Pista.Livestreams.YoutubeChannel

    import Pista.LivestreamsFixtures

    @invalid_attrs %{
      name: nil,
      status: nil,
      third_party_channel_id: nil,
      cadence_seconds: nil,
      last_fetched: nil,
      should_hydrate: nil
    }

    test "list_youtube_channels/0 returns all youtube_channels" do
      youtube_channel = youtube_channel_fixture()
      assert Livestreams.list_youtube_channels() == [youtube_channel]
    end

    test "get_youtube_channel!/1 returns the youtube_channel with given id" do
      youtube_channel = youtube_channel_fixture()
      assert Livestreams.get_youtube_channel!(youtube_channel.id) == youtube_channel
    end

    test "create_youtube_channel/1 with valid data creates a youtube_channel" do
      valid_attrs = %{
        name: "some name",
        status: "some status",
        third_party_channel_id: "some third_party_channel_id",
        cadence_seconds: 42,
        last_fetched: ~N[2023-08-10 16:31:00],
        should_hydrate: true
      }

      assert {:ok, %YoutubeChannel{} = youtube_channel} =
               Livestreams.create_youtube_channel(valid_attrs)

      assert youtube_channel.name == "some name"
      assert youtube_channel.status == "some status"
      assert youtube_channel.third_party_channel_id == "some third_party_channel_id"
      assert youtube_channel.cadence_seconds == 42
      assert youtube_channel.last_fetched == ~N[2023-08-10 16:31:00]
      assert youtube_channel.should_hydrate == true
    end

    test "create_youtube_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Livestreams.create_youtube_channel(@invalid_attrs)
    end

    test "update_youtube_channel/2 with valid data updates the youtube_channel" do
      youtube_channel = youtube_channel_fixture()

      update_attrs = %{
        name: "some updated name",
        status: "some updated status",
        third_party_channel_id: "some updated third_party_channel_id",
        cadence_seconds: 43,
        last_fetched: ~N[2023-08-11 16:31:00],
        should_hydrate: false
      }

      assert {:ok, %YoutubeChannel{} = youtube_channel} =
               Livestreams.update_youtube_channel(youtube_channel, update_attrs)

      assert youtube_channel.name == "some updated name"
      assert youtube_channel.status == "some updated status"
      assert youtube_channel.third_party_channel_id == "some updated third_party_channel_id"
      assert youtube_channel.cadence_seconds == 43
      assert youtube_channel.last_fetched == ~N[2023-08-11 16:31:00]
      assert youtube_channel.should_hydrate == false
    end

    test "update_youtube_channel/2 with invalid data returns error changeset" do
      youtube_channel = youtube_channel_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Livestreams.update_youtube_channel(youtube_channel, @invalid_attrs)

      assert youtube_channel == Livestreams.get_youtube_channel!(youtube_channel.id)
    end

    test "delete_youtube_channel/1 deletes the youtube_channel" do
      youtube_channel = youtube_channel_fixture()
      assert {:ok, %YoutubeChannel{}} = Livestreams.delete_youtube_channel(youtube_channel)

      assert_raise Ecto.NoResultsError, fn ->
        Livestreams.get_youtube_channel!(youtube_channel.id)
      end
    end

    test "change_youtube_channel/1 returns a youtube_channel changeset" do
      youtube_channel = youtube_channel_fixture()
      assert %Ecto.Changeset{} = Livestreams.change_youtube_channel(youtube_channel)
    end
  end

  describe "youtube_channel_livestream_fetches" do
    alias Pista.Livestreams.YoutubeChannelLivestreamFetches

    import Pista.LivestreamsFixtures

    @invalid_attrs %{status: nil, response: nil}

    test "list_youtube_channel_livestream_fetches/0 returns all youtube_channel_livestream_fetches" do
      youtube_channel_livestream_fetches = youtube_channel_livestream_fetches_fixture()

      assert Livestreams.list_youtube_channel_livestream_fetches() == [
               youtube_channel_livestream_fetches
             ]
    end

    test "get_youtube_channel_livestream_fetches!/1 returns the youtube_channel_livestream_fetches with given id" do
      youtube_channel_livestream_fetches = youtube_channel_livestream_fetches_fixture()

      assert Livestreams.get_youtube_channel_livestream_fetches!(
               youtube_channel_livestream_fetches.id
             ) == youtube_channel_livestream_fetches
    end

    test "create_youtube_channel_livestream_fetches/1 with valid data creates a youtube_channel_livestream_fetches" do
      valid_attrs = %{status: "some status", response: %{}}

      assert {:ok, %YoutubeChannelLivestreamFetches{} = youtube_channel_livestream_fetches} =
               Livestreams.create_youtube_channel_livestream_fetches(valid_attrs)

      assert youtube_channel_livestream_fetches.status == "some status"
      assert youtube_channel_livestream_fetches.response == %{}
    end

    test "create_youtube_channel_livestream_fetches/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Livestreams.create_youtube_channel_livestream_fetches(@invalid_attrs)
    end

    test "update_youtube_channel_livestream_fetches/2 with valid data updates the youtube_channel_livestream_fetches" do
      youtube_channel_livestream_fetches = youtube_channel_livestream_fetches_fixture()
      update_attrs = %{status: "some updated status", response: %{}}

      assert {:ok, %YoutubeChannelLivestreamFetches{} = youtube_channel_livestream_fetches} =
               Livestreams.update_youtube_channel_livestream_fetches(
                 youtube_channel_livestream_fetches,
                 update_attrs
               )

      assert youtube_channel_livestream_fetches.status == "some updated status"
      assert youtube_channel_livestream_fetches.response == %{}
    end

    test "update_youtube_channel_livestream_fetches/2 with invalid data returns error changeset" do
      youtube_channel_livestream_fetches = youtube_channel_livestream_fetches_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Livestreams.update_youtube_channel_livestream_fetches(
                 youtube_channel_livestream_fetches,
                 @invalid_attrs
               )

      assert youtube_channel_livestream_fetches ==
               Livestreams.get_youtube_channel_livestream_fetches!(
                 youtube_channel_livestream_fetches.id
               )
    end

    test "delete_youtube_channel_livestream_fetches/1 deletes the youtube_channel_livestream_fetches" do
      youtube_channel_livestream_fetches = youtube_channel_livestream_fetches_fixture()

      assert {:ok, %YoutubeChannelLivestreamFetches{}} =
               Livestreams.delete_youtube_channel_livestream_fetches(
                 youtube_channel_livestream_fetches
               )

      assert_raise Ecto.NoResultsError, fn ->
        Livestreams.get_youtube_channel_livestream_fetches!(youtube_channel_livestream_fetches.id)
      end
    end

    test "change_youtube_channel_livestream_fetches/1 returns a youtube_channel_livestream_fetches changeset" do
      youtube_channel_livestream_fetches = youtube_channel_livestream_fetches_fixture()

      assert %Ecto.Changeset{} =
               Livestreams.change_youtube_channel_livestream_fetches(
                 youtube_channel_livestream_fetches
               )
    end
  end

  describe "youtube_channel_livestreams" do
    alias Pista.Livestreams.YoutubeChannelLivestream

    import Pista.LivestreamsFixtures

    @invalid_attrs %{status: nil, url: nil, embed_url: nil, video_id: nil}

    test "list_youtube_channel_livestreams/0 returns all youtube_channel_livestreams" do
      youtube_channel_livestream = youtube_channel_livestream_fixture()
      assert Livestreams.list_youtube_channel_livestreams() == [youtube_channel_livestream]
    end

    test "get_youtube_channel_livestream!/1 returns the youtube_channel_livestream with given id" do
      youtube_channel_livestream = youtube_channel_livestream_fixture()

      assert Livestreams.get_youtube_channel_livestream!(youtube_channel_livestream.id) ==
               youtube_channel_livestream
    end

    test "create_youtube_channel_livestream/1 with valid data creates a youtube_channel_livestream" do
      valid_attrs = %{
        status: "some status",
        url: "some url",
        embed_url: "some embed_url",
        video_id: "some video_id"
      }

      assert {:ok, %YoutubeChannelLivestream{} = youtube_channel_livestream} =
               Livestreams.create_youtube_channel_livestream(valid_attrs)

      assert youtube_channel_livestream.status == "some status"
      assert youtube_channel_livestream.video_id == "some video_id"
    end

    test "create_youtube_channel_livestream/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Livestreams.create_youtube_channel_livestream(@invalid_attrs)
    end

    test "update_youtube_channel_livestream/2 with valid data updates the youtube_channel_livestream" do
      youtube_channel_livestream = youtube_channel_livestream_fixture()

      update_attrs = %{
        status: "some updated status",
        url: "some updated url",
        embed_url: "some updated embed_url",
        video_id: "some updated video_id"
      }

      assert {:ok, %YoutubeChannelLivestream{} = youtube_channel_livestream} =
               Livestreams.update_youtube_channel_livestream(
                 youtube_channel_livestream,
                 update_attrs
               )

      assert youtube_channel_livestream.status == "some updated status"
      assert youtube_channel_livestream.video_id == "some updated video_id"
    end

    test "update_youtube_channel_livestream/2 with invalid data returns error changeset" do
      youtube_channel_livestream = youtube_channel_livestream_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Livestreams.update_youtube_channel_livestream(
                 youtube_channel_livestream,
                 @invalid_attrs
               )

      assert youtube_channel_livestream ==
               Livestreams.get_youtube_channel_livestream!(youtube_channel_livestream.id)
    end

    test "delete_youtube_channel_livestream/1 deletes the youtube_channel_livestream" do
      youtube_channel_livestream = youtube_channel_livestream_fixture()

      assert {:ok, %YoutubeChannelLivestream{}} =
               Livestreams.delete_youtube_channel_livestream(youtube_channel_livestream)

      assert_raise Ecto.NoResultsError, fn ->
        Livestreams.get_youtube_channel_livestream!(youtube_channel_livestream.id)
      end
    end

    test "change_youtube_channel_livestream/1 returns a youtube_channel_livestream changeset" do
      youtube_channel_livestream = youtube_channel_livestream_fixture()

      assert %Ecto.Changeset{} =
               Livestreams.change_youtube_channel_livestream(youtube_channel_livestream)
    end
  end

  test "get_youtube_channel_livestream_by_embed_url_and_set_to_inactive/1" do
    valid_attrs = %{
      status: "some status",
      url: "some url",
      embed_url: "some_embed_url",
      video_id: "some video_id"
    }

    # create one
    assert {:ok, a} =
             Livestreams.create_youtube_channel_livestream(valid_attrs)

    # create again, same stuff
    assert {:ok, _b} =
             Livestreams.create_youtube_channel_livestream(valid_attrs)

    assert _ =
             Livestreams.get_youtube_channel_livestream_by_embed_url_and_set_to_inactive(
               a.embed_url
             )
  end
end
