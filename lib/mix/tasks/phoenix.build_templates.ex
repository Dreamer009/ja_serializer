defmodule Mix.Tasks.Phoenix.BuildTemplates do
  use Mix.Task

  @shortdoc "Assembles the updated configurations for this build"

  @moduledoc """
    Call this to setup your database, run migrations, and apply the seed data. If
    :drop is passed in then the database is first dropped
  """

  def run(_) do
    Mix.shell.info "==== Updating Configuration Templates ===="
    # result = System.cmd "mix", ["run", "priv/repo/dev_seeds.exs"]
    result = process_task

    case result do
      1 -> Mix.raise("task failed to execute")
      _ -> :ok
    end
  end

  defp process_task do
    version = String.strip(File.read! "VERSION")
    file_name = "rel/ts/releases/#{version}/sys.config"

    case File.exists? file_name do
      nil ->
        Mix.shell.error "Failure: could not find #{inspect file_name}"
        1
      _ ->
        Mix.shell.info "> Found #{inspect file_name}"
        file = File.read! file_name
        http_only = String.replace(file, ~r/({https,[ \n\t\[\]{}a-zA-Z,<>%\"_\/\.]*>>}\]},\n)/, "")

        Mix.shell.info "> Writing to sys.config.templ and sys.config.templ.http_only"
        File.write!("sys.config.templ", file)
        File.write!("sys.config.templ.http_only", http_only)
        Mix.shell.info "> Done!"
        0
    end
  end
end
