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

* Two Tabs (Tab 1 and Tab 2) realized as LiveComponent (!)
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

