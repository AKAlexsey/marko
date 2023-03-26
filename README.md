# Project setup

To run the project please run the following commands. (it's assumes that you manage elixir versions using ASDF)

```
asdf install
mix deps.get
mix do ecto.create, ecto.migrate
mix phx.server
```

Than you can visit `https://localhost:4000`.
Page contains description and links to tracking and monitoring pages.

# Solution architecture

There are two mechanisms used to track user involvement:

1. Using plugs for saving session in cookie and tracking user agent
2. Using LiveView `live_session` feature for tracking time spent on concrete LiveView page.~~~~

## Solution plugs

For session creation and fetching user agent using two modules:

1. MarkoWeb.Plugs.PutSession - tries to fetch session data from the cookie. 
   If not found - creates new session in database and assign it into cookie.

2. MarkoWeb.Plugs.PutTrackingData - Fetch user session data from Plug.Conn and assigns it into session.
   Currently it's only "user-agent" request header. But task told that it can be potentially anything else.
   Extending of tracking data can be done adding functions to this module

## Live session

Phoenix LiveView allows to run callback `#on_mount/4` during switching between live views.

We are using this callback for track time spent on each page.

Tracking logic implemented in the only one module `MarkoWeb.Tracking.TrackPagesVisited`

Module contains all logic related to the `tracking domain`.
Functions common for all tracking views, applied on different stages of the LiveView component lifecycle.
For further data please take a look at the module.

### Tracking page visible data

Task requires track data only when page is visible. I implemented it the following way:

1. Added common form `visibility_form` with one input the the common layout for tracking pages
2. Added necessary JavaScript `visibilitychange` event handler for all tracking pages. 
   After changing of visibility - event handler updates input `visibility_form` value to current visibility status.
   Then triggers submit event on form
3. Handle submit using LiveView event handler

# Testing

To run tests please run:

`mix test`

Test coverage ~45%. But ALL business logic are covered. The rest was considered as not important for test task.~~~~

# Task description

## Setup

* Generate a new repo with Phoenix 1.7 and Liveview 0.18
* Setup Phoenix

## Pages

Create 3 LiveView Controller (Pages), of which the last one (Page C) consists of two tabs.

**Page A**

* Route: /page_a
* Title: "Page A"
* Content: Links to Page B and Page C, Tab 1

**Page B**

* Route: /page_b
* Title: "Page B"
* Content: Links to Page A and Page C, Tab 2

**Page C (Tabs)**

* Routes: /page_c, /page_c/tab_1 and /page_c/tab_2.
* Title: "Page C, Tab 1" or "Page C, Tab 2"

**Content:**

* Two Tabs (Tab 1 and Tab 2) implemented as LiveComponent (!)
* Tab 1 has a link to Page B, Tab 2 has a link to Page A.

You should be able to switch between the tabs.
Switching between Tabs, changes the URL.

Route `/page_c` should randomly forward to one tab.
Route `/page_c/tab_1` shows Tab 1
Route `/page_c/tab_b` shows Tab 2

#### Task

We want to track session (aka Browser Session) and pageviews without it having a performance penalty on the user request.

**Session**

For every new visitor, you create a session and store details in the database in the table tracking_session with the following fields. Create a long-lasting cookie with a unique id to track the same client over multiple sessions.

* Browser Agent
* Unique ID from your cookie

**Pageview**

Now, we want to track user engagement. We store for every pageview the following data.

* Session ID
* Phoenix.LiveView.Socket.View (Module Name as String)
* Additional Identify Information

**Engagement Time**

What is a pageview?

* Viewing Page A or Page B` triggers a pageview.
* Viewing Tab 1 or Tab 2 on Page C triggers a pageview.

What is the engagement_time
We are interested in how much time is spent on a page to understand the behaviour better.
Track how many seconds the page content may be at least partially visible. This means that the page is in a foreground tab of a non-minimized window.
