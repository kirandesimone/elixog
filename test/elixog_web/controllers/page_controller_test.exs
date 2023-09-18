defmodule ElixogWeb.PageControllerTest do
  use ElixogWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == ~p"/users/log_in"
  end
end
