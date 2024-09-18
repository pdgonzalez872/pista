# Pista


## What is Pista?

Pista started as a way for me to keep track of Padel. If you don't know what
Padel is, here is a good [link](https://www.linkedin.com/posts/alegalan96_padel-ugcPost-7233781762793889793-BUtv).
Well, it's not Pickleball. It's a very dynamic and currently my favorite racket
sport.


## What is Padel and how its growth impacted Pista dev

Padel has been growing a lot. There is a lot of interest for this sport to come
here to the US. One of my friends opened a club here in Chicago and it's been
great. This year saw a lot of changes as far as professional leagues go. At the
moment, there are 4 pro leagues. The history of all of this kind of takes away
from this project, but it is important to know that the whole sport is going
through big changes. Positive ones as well.

One of the shifts was to have 4 pro leagues. As you can imagine, it becomes
hard to follow the tournaments and even answer simple questions like: "Is there
a tournament this week?". This constant shift of the sport also impacted the
dev work I was doing.

Back in the day, it was hard to find a livestream on Youtube, so the
"Livestreams" feature came about. I thought we would want to persist those so
folks could watch them later, but it turns out that a lot of the channels
delete the videos after they are livestreamed, leaving you with weird a broken
link. At the moment, I persist things, but that's mostly legacy stuff and could
go away. It turns out that if it's not live, folks don't care about it. This is
the case because there is always something else live now :), one of the changes
happening in Padel now. It's not uncommon to see 15 different livestreams be
live at the same time on a Saturday.


## Architecture

As far as architecture, there are a few things I'd likely do differently now
that I know the problem a little bit more. I'd experimented with a few
different features only to see that nobody really cared for them :) That's dev.

Yes, I should use more Ecto enums, maybe use Oban, but, life is short. The app
performs flawlessly as it is and I shipped it. Shipping feels good.

Pista can be found here:
[https://www.pista.cloud](https://www.pista.cloud), it's
a small Fly app. So far, it has performed fairly well, no complaints. Plausible
has also been cool to understand the usage. Turns out that we have one pro
player at the highest (he is a family friend) that uses the app to sign up,
follow results. Folks at the academy he trains also are frequent users.


## Mobile First UI

I built Pista with mobile in mind, although I then learned that folks would
open it up in a big monitor and play the livestreams directly from their
computer. It looks ok on desktop, but it was built with mobile in mind.


## Development

To dev, this is a straight forward liveview app backed by postgres. The usual
steps apply here as well. To start your Phoenix server:

  * `mix setup`
  * `MIX_ENV=dev iex -S mix phx.server`, or `./dev_server_iex.sh`
  * seed the database -> run `Pista.OneTime.SeedsYoutubeLivestreams.call()`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Get an iex session and run `Pista.OneTime.SeedsYoutubeLivestreams.call()` to
get some YouTube livestreams in the db and then the worker will pick it up.

I say `we` in a codebase, mostly due to habit, even when I'm doing solo work.


## Future dev

There are a few features that would be interesting to build:

- Support the vastly used "Americano" format for group play (teaching pros use
  it often to organize games)
- Draw (brackets) creation for tournaments
- League management
- Continue working with pro tournament results and do something with the output
  - One interesting idea is to have a blob of results, get a just released draw
    and feed both the historical data and also the current matchups into some
    LLM and write "pre" tournament analysis pieces. Could generate some content
    like that, potentially sell it to the news folks in an automated way
