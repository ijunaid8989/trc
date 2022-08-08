defmodule TRC.Streamer do
  use GenServer

  alias NimbleCSV.RFC4180, as: CSV

  alias TRC.Events

  @datasets [
    "datasets/collisionelectrondata/dielectron.csv",
    "datasets/memegenerator/memegenerator.csv",
    "datasets/twitchdata/twitchdata-update.csv"
  ]

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec init(any) :: {:ok, any, {:continue, :initialize}}
  def init(args) do
    {:ok, args, {:continue, :initialize}}
  end

  def handle_continue(:initialize, state) do
    datasets()
    {:noreply, state}
  end

  defp datasets() do
    @datasets
    |> Enum.each(fn dataset ->
      event(dataset)
      |> parse_csv(dataset)
    end)
  end

  defp parse_csv(event, path) do
    path
    |> File.stream!([:trim_bom])
    |> CSV.parse_stream(skip_headers: false)
    |> Stream.transform([], fn
      r, [] ->
        {[], r}

      r, acc ->
        {[
           acc
           |> Enum.zip(r)
           |> Map.new()
         ], acc}
    end)
    |> Stream.map(fn item ->
      payload = event_to_struct(event, item)
      Events.publish(event, payload)
    end)
    |> Stream.run()
  end

  defp event_to_struct("twitch", item) do
    %{
      channel: item["Channel"],
      language: item["Language"],
      mature: item["Mature"],
      partnered: item["Partnered"],
      metadata: %{
        watch_time: item["Watch time(Minutes)"],
        stream_time: item["Stream time(minutes)"],
        peak_viewers: item["Peak viewers"],
        average_viewers: item["Average viewers"],
        followers: item["Followers"],
        followers_gained: item["Followers gained"],
        views_gained: item["Views gained"]
      }
    }
  end

  defp event_to_struct("memegen", item) do
    %{
      alternate_text: item["Alternate Text"],
      archived_url: item["Archived URL"],
      base_meme_name: item["Base Meme Name"],
      file_size: item["File Size (In Bytes)"],
      md5_hash: item["MD5 Hash"],
      meme_id: item["Meme ID"],
      meme_page_url: item["Meme Page URL"]
    }
  end

  defp event_to_struct("collisionelectron", item) do
    %{
      event: item["Event"],
      run: item["Run"],
      energy: %{
        e1: item["E1"],
        e2: item["E2"]
      },
      momemtum: %{
        px1: item["px1"],
        py1: item["py1"],
        pz1: item["pz1"],
        px2: item["px2"],
        py2: item["py2"],
        pz2: item["pz2"]
      },
      transverse_momemtum: %{
        pt1: item["pt1"],
        pt2: item["pt2"]
      },
      pseudorapidity: %{
        eta1: item["eta1"],
        eta2: item["eta2"]
      },
      phi_angle: %{
        phi1: item["phi1"],
        phi2: item["phi2"]
      },
      charge: %{
        q1: item["Q1"],
        q2: item["Q2"]
      },
      invariant_mass: item["M"]
    }
  end

  defp event("datasets/collisionelectrondata/dielectron.csv"), do: "collisionelectron"
  defp event("datasets/memegenerator/memegenerator.csv"), do: "memegen"
  defp event("datasets/twitchdata/twitchdata-update.csv"), do: "twitch"
end
