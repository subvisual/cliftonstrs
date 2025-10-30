defmodule TalentsWeb.PageController do
  use TalentsWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
