defmodule IpxWeb.Router do
  use IpxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", IpxWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", IpxWeb do
    pipe_through :api

    get "/:ip", IpController, :show
    get "/:lang/:ip", IpController, :show
  end
end
