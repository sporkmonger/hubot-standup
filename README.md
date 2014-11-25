# hubot-standup

A hubot script that tracks what users are working on

See [`src/standup.coffee`](src/standup.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-standup --save`

Then add **hubot-standup** to your `external-scripts.json`:

```json
["hubot-standup"]
```

## Sample Interaction

```
user3>> hubot standup Uncoiling the widgets
hubot>> user3 is now 'Uncoiling the widgets'
user1>> hubot standup
hubot>> user1: Oscillating the widgets (3 hours ago)
hubot>> user2: Degaussing the widgets (12 days ago)
hubot>> user3: Uncoiling the widgets (47 seconds ago)
hubot>> user4: Remagnetizing the widgets (1 hour ago)
```
