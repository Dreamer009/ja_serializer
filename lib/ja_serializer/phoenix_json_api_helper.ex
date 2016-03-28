defmodule JaSerializer.PhoenixJsonApiHelper do
  @moduledoc """
  Use in your Phoenix controller to render jsonapi.org spec json.

  ## Usage example

      defmodule PhoenixExample.ArticlesController do
        use PhoenixExample.Web, :controller

        alias JaSerializer.PhoenixJsonApiHelper

        def index(conn, params) do
          articles = Article |> PhoenixJsonApiHelper.where_params(params) |> Repo.all
          render(conn, "index.json", data: articles)
        end

        def create(conn, %{"meta" => _meta, "data" => data = %{"type" => "article", "attributes" => article_params}}) do
          changeset = Article.changeset(%Article{}, PhoenixJsonApiHelper.to_params(article_params, data["relationships"]))

          case Repo.insert(changeset) do
            {:ok, article} ->
              conn
              |> put_status(:created)
              |> put_resp_header("location", article_path(conn, :show, article))
              |> render("show.json", data: article)
            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render(Ts.ChangesetView, "error.json", changeset: changeset)
          end
        end

      end

  """

  @doc """
  Creates an ecto query for a JSON API index controller action.

  ## Examples
      iex> JaSerializer.PhoenixJsonApiHelper.where_params(Post, %{})
      Post

      iex> JaSerializer.PhoenixJsonApiHelper.where_params(Post, %{"user_id" => 1})
      #Ecto.Query<from p in PhoenixExample.Post, where: p.user_id == ^1>

  If you use it in your controller index action:

  ## Controller
      alias JaSerializer.PhoenixJsonApiHelper

      def index(conn, params) do
        posts = Article |> PhoenixJsonApiHelper.where_params(params) |> Repo.all
        render(conn, "index.json", data: posts)
      end

  It allows your router to look like:

  ## Router
      resources "/posts", PostController do
        get "/users", UserController, :index
      end
  """
  def where_params(type, params) when is_map(params) do
    do_where_params(type, params, Enum.count(params))
  end

  defp do_where_params(type, _params, size) when size == 0, do: type
  defp do_where_params(type, params, _size) do
    params = keys_to_symbols(params)
    k = params |> Map.keys |> hd
    v = Map.get(params, k)

    type |> Ecto.Query.where(^[{k, v}])
  end

  @doc """
  Combines JSON API attributes and relationship params into a single param hash.

  ## Examples
      iex> JaSerializer.PhoenixJsonApiHelper.to_params(%{"title" => "Title", "description" => "Description"}, nil)
      %{description: "Description", title: "Title"}

      iex> JaSerializer.PhoenixJsonApiHelper.to_params(%{"title" => "Title", "description" => "Description"}, %{
             "user" => %{
               "data" => %{
                 "type" => "user",
                 "id" => 1
               }
             }
           })
      %{description: "Description", title: "Title", user_id: 1}
  """
  def to_params(attributes, relationships) when relationships == nil do
    keys_to_symbols(attributes)
  end

  def to_params(attributes, relationships) do
    Map.merge(relationships_to_params(relationships), keys_to_symbols(attributes))
  end

  defp keys_to_symbols(obj) when is_map(obj) do
    for k <- Map.keys(obj), into: %{} do
      v = Map.get(obj, k)

      {key_to_atom(k), v}
    end
  end

  defp key_to_atom(key) when is_atom(key),      do: key
  defp key_to_atom(key) when is_bitstring(key), do: String.to_atom(key)

  defp relationships_to_params(relationships) do
    list = for k <- Map.keys(relationships), into: [] do
      relationship = Map.get(relationships, k)

      data_to_params(relationship["data"])
    end

    list
    |> List.flatten
    |> Enum.filter(fn(x) -> !is_nil(x) end)
    |> Enum.into(%{})
  end

  defp data_to_params(data) when is_map(data),  do: {String.to_atom(data["type"] <> "_id"), data["id"]}
  defp data_to_params(data) when is_list(data), do: Enum.map data, &(data_to_params(&1))
  defp data_to_params(data) when is_nil(data),  do: nil

end
