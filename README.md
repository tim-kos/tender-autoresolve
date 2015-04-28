Tender Autoresolve
============================

Auto resolves old Tender tickets.


# Installation

`npm install --save tender-autoresolve`

or

* Clone or fork this repo
* Run `npm install .`

# Execution

You can supply all credentials over the command line:

```
./bin/tender_autoresolve --tenderapikey YOUR_TENDER_API_KEY --tendersitename YOUR_TENDER_SITENAME
```

... or you can supply them through environment variables. Just copy **env.default.sh** into an **env.sh** file, fill out all the credentials there and then run:


```
source env.sh && ./bin/tender_autoresolve
```

Cli arguments take precedence over the env variables if you provide both.


# TODO

- [] Write some tests
