request           = require "request"
config            = require "./config"
async             = require "async"
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

      discussions = @_filter discussions
      @_resolveDiscussions discussions, cb

  _filter: (discussions) ->
    result = []

    now = +new Date / 1000

    for d in discussions
      if d.last_author_email not in config.staffEmails
        continue

      timeThen = +new Date(d.last_updated_at) / 1000

      if now - timeThen < 86400 * config.numDays
        continue

      result.push d

    return result

  _resolveDiscussions: (discussions, cb) ->
    if discussions.length == 0
      return cb()

    q = async.queue @_resolve.bind(this), 1
    q.drain = cb

    index = 1
    for d in discussions
      obj =
        index      : index++
        total      : discussions.length
        discussion : d
      q.push obj

  _resolve: (obj, cb) ->
    discussion = obj.discussion
    index      = obj.index
    total      = obj.total

    url = discussion.comments_href.replace /\{\?page\}/, ""
    opts =
      url     : url
      form    : config.formData
      headers :
        "X-Tender-Auth" : config.tender.apiKey
        "Accept"        : "application/vnd.tender-v1+json"
        "Content-Type"  : "application/json"

    request.post opts, (err, resp, body) ->
      if err
        throw err

      console.log "#{index} / #{total}: Resolved #{discussion.href}"
      cb()

module.exports = DiscussionResolver
