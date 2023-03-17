defmodule DiscussWeb.Router do
  use DiscussWeb, :router

  pipeline :browser do
    plug Ueberauth
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DiscussWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :secured do
    plug DiscussWeb.AuthController
  end

  scope "/", DiscussWeb do
    pipe_through :browser

    # # "/"の時、TopicControllerのindex関数を動かす
    # get "/", TopicController, :index
    # get "/topics/new", TopicController, :new
    # #/topicsに対するユーザーからのリクエスト
    # post "/topics", TopicController, :create
    # get "/topics/:id/edit", TopicController, :edit
    # #データを置き換える際のみput（他の場合はpost）
    # put "/topics/:id", TopicController, :update
    resources "/", TopicController #Controllerが規約に従っていればURLを自動生成
  end

  scope "/auth", DiscussWeb do
    pipe_through [:browser, :secured]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiscussWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DiscussWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
