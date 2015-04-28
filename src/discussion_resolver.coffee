request           = require "request"
config            = require "./config"
DiscussionFetcher = require "./discussion_fetcher"

class DiscussionResolver
  start: (cb) ->
    if !config.tender.siteName || !config.tender.apiKey
      throw new Error "You need to supply Tender credentials!"

    opts =
      site   : config.tender.siteName
      apiKey : config.tender.apiKey
      state  : config.state

    fetcher = new DiscussionFetcher opts
    fetcher.fetch (err, discussions) =>
      if err
        throw err

      console.log ">> do filter"
      discussions = @_filter discussions

      if discussions.length > 0
        console.log discussions

        @_resolve discussions, cb

  _filter: (discussions) ->
    result = []

    now = +new Date / 1000

    for d in discussions
      if d.last_author_email not in config.staffEmails
        continue

      timeThen = +new Date(d.last_updated_at) / 1000
      # console.log d.last_updated_at, timeThen, now
      console.log d.last_updated_at

      if now - timeThen < 86400 * config.numDays
        continue

  _resolve: (discussions, cb) ->
    msg = "Found #{discussions.length} discussions:\n"

    cb null

module.exports = DiscussionResolver
