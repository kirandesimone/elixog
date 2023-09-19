defmodule ElixogWeb.PostHTML do
  alias Elixog.Accounts
  alias Elixog.Tags
  use ElixogWeb, :html

  embed_templates "post_html/*"

  @doc """
  Renders a post form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :current_user, Accounts.User, required: true
  attr :tag_options, Tags.Tag

  def post_form(assigns)
end
