defmodule MarkoWeb.Tracking.TrackPagesVisitedTest do
  use MarkoWeb.ConnCase, async: false

  alias MarkoWeb.Tracking.TrackPagesVisited

  alias Marko.Monitoring.Activity
  alias Marko.Repo

  import Marko.MonitoringFixtures
  import Phoenix.Component

  describe "#on_mount/4" do
    test "Fetches data from user session. Assigns necessary for time tracking data to socket." do
      session_id = 23
      user_agent = "Test chromium agent"
      session = %{"session_id" => session_id, "user_agent" => user_agent}

      assert {:cont,
              %Phoenix.LiveView.Socket{
                assigns: %{
                  form: %Phoenix.HTML.Form{},
                  milliseconds_spent: 0,
                  session_id: ^session_id,
                  user_agent: ^user_agent,
                  visibility: "visible",
                  visit_started: %NaiveDateTime{}
                }
              }} = TrackPagesVisited.on_mount(:activity_tracking, %{}, session, socket_fixture())
    end
  end

  describe "#visibility_changed/2" do
    setup do
      page_visible = "visible"
      page_hidden = "hidden"

      visit_started = NaiveDateTime.utc_now()
      milliseconds_spent = 1700

      visible_socket =
        socket_fixture(%{}, %{
          visibility: page_visible,
          milliseconds_spent: milliseconds_spent,
          visit_started: visit_started
        })

      hidden_socket =
        socket_fixture(%{}, %{visibility: page_hidden, milliseconds_spent: milliseconds_spent})

      {:ok,
       page_visible: page_visible,
       page_hidden: page_hidden,
       visible_socket: visible_socket,
       hidden_socket: hidden_socket,
       visit_started: visit_started,
       milliseconds_spent: milliseconds_spent}
    end

    test "Returns given socket if visibility state not changed", %{
      page_visible: page_visible,
      page_hidden: page_hidden,
      visible_socket: visible_socket,
      hidden_socket: hidden_socket
    } do
      assert {:noreply, visible_socket} ==
               TrackPagesVisited.visibility_changed(visible_socket, %{
                 "visibility" => page_visible
               })

      assert {:noreply, hidden_socket} ==
               TrackPagesVisited.visibility_changed(hidden_socket, %{"visibility" => page_hidden})
    end

    test "Calculates ans assigns time spend if page become hidden", %{
      page_hidden: page_hidden,
      visible_socket: visible_socket,
      visit_started: visit_started,
      milliseconds_spent: milliseconds_spent
    } do
      current_session_duration = 2600
      current_datetime = NaiveDateTime.add(visit_started, current_session_duration, :millisecond)

      total_milliseconds_spent = milliseconds_spent + current_session_duration

      assert {:noreply,
              %Phoenix.LiveView.Socket{
                assigns: %{
                  visibility: ^page_hidden,
                  visit_started: nil,
                  milliseconds_spent: ^total_milliseconds_spent
                }
              }} =
               TrackPagesVisited.visibility_changed(
                 visible_socket,
                 %{"visibility" => page_hidden},
                 current_datetime
               )
    end

    test "Assigns visit start datetime if page become visible", %{
      page_visible: page_visible,
      hidden_socket: hidden_socket,
      milliseconds_spent: milliseconds_spent
    } do
      assert {:noreply,
              %Phoenix.LiveView.Socket{
                assigns: %{
                  visibility: ^page_visible,
                  visit_started: %NaiveDateTime{},
                  milliseconds_spent: ^milliseconds_spent
                }
              }} =
               TrackPagesVisited.visibility_changed(hidden_socket, %{"visibility" => page_visible})
    end
  end

  describe "#on_terminate/1" do
    test "Send tracking data to the Monitoring system." do
      %{id: session_id} = sessions_fixture()

      user_agent = "Test chromium agent"

      visit_started = NaiveDateTime.utc_now()
      milliseconds_spent = 1900
      path = "/page_test"
      view = "PageTest"

      this_visit_duration = 600
      current_datetime = NaiveDateTime.add(visit_started, this_visit_duration, :millisecond)

      socket =
        socket_fixture(%{view: view}, %{
          path: path,
          session_id: session_id,
          milliseconds_spent: milliseconds_spent,
          visit_started: visit_started,
          user_agent: user_agent
        })

      assert socket == TrackPagesVisited.on_terminate(socket, current_datetime)

      assert %Activity{
               metadata: %{"user_agent" => ^user_agent},
               session_id: ^session_id,
               path: ^path,
               view: ^view,
               seconds_spent: 2
             } = Repo.get_by(Activity, %{session_id: session_id})
    end
  end

  describe "#assign_page_path/2" do
    test "Parses given URI and assign it's path to the socket" do
      path = "/page_xyx"
      socket = socket_fixture()
      uri = "https://localhost#{path}"

      assert %Phoenix.LiveView.Socket{assigns: %{path: ^path}} =
               TrackPagesVisited.assign_page_path(socket, uri)
    end
  end

  describe "#calculate_total_milliseconds_spend/1" do
    test "Calculates datetime based on assigned data" do
      visit_started = NaiveDateTime.utc_now()
      this_visit_duration = 600
      current_datetime = NaiveDateTime.add(visit_started, this_visit_duration, :millisecond)
      milliseconds_spent_already = 1800

      assigns = %{
        visit_started: NaiveDateTime.utc_now(),
        milliseconds_spent: milliseconds_spent_already
      }

      assert this_visit_duration + milliseconds_spent_already ==
               TrackPagesVisited.calculate_total_milliseconds_spend(assigns, current_datetime)
    end
  end

  def socket_fixture(params \\ %{}, assigns \\ %{}) do
    %Phoenix.LiveView.Socket{}
    |> struct(params)
    |> assign(assigns)
  end
end
