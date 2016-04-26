defmodule <%= module %>Controller do
  use <%= base %>.Web, :controller

  alias <%= module %>
  alias JaSerializer.Params

  plug :scrub_params, "meta" when action in [:create, :update]
  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, params) do
    <%= plural %> = Repo.all(<%= alias %>)
    render(conn, "index.json", data: <%= plural %>)
  end

  def create(conn, %{"meta" => _meta, "data" => data = %{"type" => <%= inspect singular %>, "attributes" => <%= singular %>_params}}) do
    changeset = <%= alias %>.changeset(%<%= alias %>{}, Params.to_params(data))

    case Repo.insert(changeset) do
      {:ok, <%= singular %>} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", <%= singular %>_path(conn, :show, <%= singular %>))
        |> render("show.json", data: <%= singular %>)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(<%= base %>.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    <%= singular %> = <%= alias %> |> Ecto.Query.where(id: ^id) |> Repo.one!
    render(conn, "show.json", data: <%= singular %>)
  end

  def update(conn, %{"id" => id, "meta" => _meta, "data" => data = %{"type" => <%= inspect singular %>, "attributes" => <%= singular %>_params}}) do
    <%= singular %> = <%= alias %> |> Ecto.Query.where(id: ^id) |> Repo.one!
    changeset = <%= alias %>.changeset(<%= singular %>, Params.to_params(data))

    case Repo.update(changeset) do
      {:ok, <%= singular %>} ->
        render(conn, "show.json", data: <%= singular %>)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(<%= base %>.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    <%= singular %> = <%= alias %> |> Ecto.Query.where(id: ^id) |> Repo.one!

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(<%= singular %>)

    send_resp(conn, :no_content, "")
  end

end
