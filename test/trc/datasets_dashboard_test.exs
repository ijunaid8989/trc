defmodule TRC.Datasets.DatasetsDashboardTest do
  use TRC.DataCase

  import TRC.DatasetsFixtures

  alias TRC.Cache
  alias TRC.Datasets.DatasetsDashboard

  setup do
    _ = Cache.flush()
    :ok
  end

  describe "DatasetsDashboard" do
    setup [:twitch_fixture]
    setup [:meme_gen_fixture]
    setup [:collision_electron_fixture]

    test "all()" do
      _ = Cache.delete_all()

      %{items: items, total: total} = DatasetsDashboard.all()

      assert length(items) == total
    end

    test "all() when it uses the cache" do
      %{items: items, total: _total} = DatasetsDashboard.all()

      assert length(items) == 3

      %{
        alternate_text: "some",
        archived_url: "some",
        base_meme_name: "some",
        file_size: 41,
        md5_hash: "some",
        meme_id: 41,
        meme_page_url: "some"
      }
      |> TRC.Datasets.create_meme_gen()

      %{items: items, total: _total} = DatasetsDashboard.all()
      assert length(items) == 3
    end

    test "all() with clearing out read cache" do
      %{items: items, total: _total} = DatasetsDashboard.all()

      assert length(items) == 3

      %{
        alternate_text: "some",
        archived_url: "some",
        base_meme_name: "some",
        file_size: 41,
        md5_hash: "some",
        meme_id: 41,
        meme_page_url: "some"
      }
      |> TRC.Datasets.create_meme_gen()

      %{items: items, total: _total} = DatasetsDashboard.all()
      assert length(items) == 3

      _ = Cache.delete_all()

      %{items: items, total: _total} = DatasetsDashboard.all()
      assert length(items) == 4
    end

    test "all() filter by topic" do
      _ = Cache.delete_all()

      %{items: items, total: _total} = DatasetsDashboard.all(%{"topic" => "twitch"})

      assert length(items) == 1

      %{items: items, total: _total} = DatasetsDashboard.all(%{"topic" => "memegen"})

      assert length(items) == 1

      %{
        alternate_text: "some",
        archived_url: "some",
        base_meme_name: "some",
        file_size: 41,
        md5_hash: "some",
        meme_id: 41,
        meme_page_url: "some"
      }
      |> TRC.Datasets.create_meme_gen()

      %{items: items, total: _total} = DatasetsDashboard.all(%{"topic" => "memegen"})

      assert length(items) == 1

      _ = Cache.delete_all()

      %{items: items, total: _total} = DatasetsDashboard.all(%{"topic" => "memegen"})

      assert length(items) == 2
    end

    test "all() filter by topic with cache test" do
      _ = Cache.delete_all()

      %{items: items, total: _total} = DatasetsDashboard.all(%{"topic" => "memegen"})

      assert length(items) == 1

      %{
        alternate_text: "some",
        archived_url: "some",
        base_meme_name: "some",
        file_size: 41,
        md5_hash: "some",
        meme_id: 41,
        meme_page_url: "some"
      }
      |> TRC.Datasets.create_meme_gen()

      _ = Cache.delete_all()

      %{items: items, total: _total} = DatasetsDashboard.all(%{"topic" => "memegen"})

      assert length(items) == 2
    end

    test "all() use pagination" do
      _ = Cache.delete_all()

      Enum.each(1..50, fn x ->
        %{
          alternate_text: "some#{x}",
          archived_url: "some#{x}",
          base_meme_name: "some#{x}",
          file_size: x,
          md5_hash: "some#{x}",
          meme_id: x,
          meme_page_url: "some#{x}"
        }
        |> TRC.Datasets.create_meme_gen()
      end)

      page = DatasetsDashboard.all(%{"page" => "2", "page_size" => "3"})

      assert page.page_size == 3
      assert page.page == 2
      assert page.total == 53
    end
  end
end
