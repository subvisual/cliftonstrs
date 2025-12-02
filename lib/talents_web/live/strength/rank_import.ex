defmodule TalentsWeb.Strength.RankImportComponent do
  use TalentsWeb, :live_component
  alias PdfExtractor

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mb-6">
      <p>Enter the local path to your PDF file:</p>
      <form phx-submit="parse" phx-target={@myself} class="flex gap-2 mt-2">
        <input
          type="text"
          name="pdf_path"
          placeholder="/path/to/file.pdf"
          class="border p-2 rounded flex-1"
        />
        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded">Parse PDF</button>
      </form>
    </div>
    """
  end

  def mount(_params, socket), do: {:ok, socket}

  @impl true
  def handle_event("parse", %{"pdf_path" => path}, socket) do
    # Page 19, the section with the ranks
    areas = %{18 => {0, 150, 180, 750}}

    case PdfExtractor.extract_text(path, areas) do
      {:ok, page} ->
        rankings =
          page
          |> Map.get(18, "")
          |> String.split("\n")
          |> Enum.map(&String.trim/1)
          |> Enum.reduce(%{}, fn line, acc ->
            case Regex.run(~r/^(\d{1,2})\.\s+(.+)$/, line) do
              [_, pos, name] -> Map.put(acc, name, pos)
              _ -> acc
            end
          end)

        send(self(), {:rankings_imported, rankings})
        {:noreply, put_flash(socket, :info, "PDF extracted!")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "PDF extraction failed: #{reason}")}
    end
  end
end
