defmodule ElixogWeb.PostHTML do
  use ElixogWeb, :html

  embed_templates "post_html/*"

  @doc """
  Renders a post form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def post_form(assigns)
end
