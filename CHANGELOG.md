# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](Https://conventionalcommits.org) for commit guidelines.

<!-- changelog -->

## [v1.1.0](https://github.com/TwistingTwists/pyq_ratta/compare/v1.0.0...v1.1.0) (2024-03-02)




### Features:

* questions are being sent in order now

* question numbers are in join table!

* buffered sender to send messages to telegram via a GenServer

* improvements in UserAttemptServer

* LoggerFileBackend now lgos in ./log/info.log and ./log/debug.log

* observability: setup openobserve, loggerfilebackend, json exporter

* test: add deps

### Bug Fixes:

* start quiz message format to comply with markdown

## [v1.0.0](https://github.com/TwistingTwists/pyq_ratta/compare/v0.2.0...v1.0.0) (2024-02-22)
### Breaking Changes:

* scraping: parser combinator for question



### Features:

* can create Quiz by posting a url in the telegram channel

* question has source field

* parse response

* can parse the quiz using peg grammars!

### Bug Fixes:

* upgrade elixir + move to bandit

* port from env_var

* show browser false = headless mode

## [v0.2.0](https://github.com/TwistingTwists/pyq_ratta/compare/v0.1.3...v0.2.0) (2024-02-07)




### Features:

* Can process the link and generate screenshots

* can run python script via elixir

* users response can be saved in db

### Bug Fixes:

* save function

## [v0.1.3](https://github.com/TwistingTwists/pyq_ratta/compare/v0.1.3...v0.1.3) (2024-01-28)



