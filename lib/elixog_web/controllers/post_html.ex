defmodule ElixogWeb.PostHTML do
  alias Elixog.Accounts
  use ElixogWeb, :html

  embed_templates "post_html/*"

  @doc """
  Renders a post form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :current_user, Accounts.User, required: true

  def post_form(assigns)
end
