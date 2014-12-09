# Description:
#   A hubot script that tracks what users are working on.
#
# Commands:
#   hubot standup <task> - register current task
#   hubot standup - list all current tasks
#
# Configuration:
#   HUBOT_STANDUP_TIMEAGO - If set, last updated times will be relative
#
# Author:
#   Bob Aman <bob@sporkmonger.com>

config =
  use_timeago: process.env.HUBOT_STANDUP_TIMEAGO

class Standup
  constructor: (@robot) ->
    @cache = {}

    @robot.brain.on 'loaded', @load
    if @robot.brain.data.users.length
      @load()

  load: =>
    if @robot.brain.data.standup
      @cache = @robot.brain.data.standup
    else
      @robot.brain.data.standup = @cache

  add: (user, taskDescription) ->
    task =
      description: taskDescription
      timestamp: new Date() - 0
    @cache[user.id] = task

  last: (user) ->
    @cache[user.id] ? {}

module.exports = (robot) ->
  standup = new Standup robot

  robot.respond /standup$/, (msg) ->
    overdue = []
    for own key, user of robot.brain.data.users
      task = standup.last user
      dateString = if task && task.timestamp
        if config.use_timeago?
          timeago = require 'timeago'
          timeago(new Date(task.timestamp))
        else
          "at #{new Date(task.timestamp)}"
      else
        "not yet"

      threeDays = 1000 * 60 * 60 * 24 * 3
      if (task && task.description && task.timestamp &&
          new Date(task.timestamp + threeDays) > new Date())
        # If it's been less than three days, show the last status.
        descString = if task && task.description
          task.description
        else
          'Not working on anything'

        msg.send "#{user.name}: #{descString} (#{dateString})"
      else
        overdue.push(user)
    if overdue.length > 0
      overdueList = ("@#{user.name}" for user in overdue).join(', ')
      setTimeout(->
        msg.send "#{overdueList}: Please update your status."
      , 1000)

  robot.respond /standup (.+)/, (msg) ->
    user = msg.message.user
    standup.add user, msg.match[1]
    msg.send "#{user.name} is now '#{msg.match[1]}'"
