defmodule JaSerializer.Post do
  use Ecto.Schema

  import Ecto.Changeset

  schema "posts" do
    field :name, :string
    field :user_id, :integer

    timestamps
  end
  @required_fields ~w(user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end

defmodule JaSerializer.PhoenixJsonApiHelperTest do
  use ExUnit.Case

  alias JaSerializer.PhoenixJsonApiHelper
  alias JaSerializer.Post

  test "where_params returns the type object when given an empty params hash " do
    type = Post
    where_params = PhoenixJsonApiHelper.where_params(type, %{})
    assert where_params == type
  end

  test "where_params returns an ecto query when given an non empty params hash " do
    where_params = PhoenixJsonApiHelper.where_params(Post, %{"user_id" => 1})
    assert where_params.__struct__ == Ecto.Query
  end

  test "to_params returns the attributes hash with atom keys when the relationship hash is nil" do
    params = PhoenixJsonApiHelper.to_params(%{"title" => "Title", "description" => "Description"}, nil)
    assert params == %{description: "Description", title: "Title"}
  end

  test "to_params returns the attributes hash with parsed relationship attributes when the relationship hash is not nil" do
    params = PhoenixJsonApiHelper.to_params(%{"title" => "Title", "description" => "Description"}, %{
               "user" => %{
                 "data" => %{
                   "type" => "user",
                   "id" => 1
                 }
               }
             })
             
    assert params == %{description: "Description", title: "Title", user_id: 1}
  end

end
