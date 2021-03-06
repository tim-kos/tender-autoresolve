config = exports

# Only do open tickets for now, which are tickets where support staff
# replied, but not the customer
config.state = "open"

config.staffEmails = [
  "tim.koschuetzki@transloadit.com",
  "kevin@transloadit.com",
  "marius@transloadit.com",
  "joe@transloadit.com"
]

# number of days that need to pass for a ticket to be closed
config.numDays = 30

body = "This discussion has been inactive for 30 days and has"
body += " been marked as resolved automatically.\n"
body += "Feel free to reply to this ticket to re-open it and we"
body += " will continue the investigation.\n\n"
body += "Kind regards,\nTim\n\nCo-Founder Transloadit"

config.formData =
  authorName:  "Tim Koschützki"
  authorEmail: "tim@transloadit.com"
  body:         body
  resolution:   true
  skip_spam:    true

config.tender =
  siteName : process.env.TENDER_SITENAME
  apiKey   : process.env.TENDER_APIKEY
  project  : process.env.TENDER_PROJECT
