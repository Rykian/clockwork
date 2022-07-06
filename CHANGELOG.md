## 4.0.0

- BREAKING CHANGE: `error_handler` now receives job as first parameter

## 3.0.0

- BREAKING CHANGE: drop Rubinius support
- add Ruby 3.0 support (65d71f)
- fix a bug with OpenStruct (15eb030)
- allow `:skip_first_run` in database events (429bc0a)
- add rescue to prevent hung up by exception (cc1b7c9)
- fix CI errors (16b4e19 & e4480ea)
- fix a compatibility bug with Rails 7 (5907bc7)
- Add "Finished" log with duration and error summary (66419ab)

## 2.0.4

- Reverts the breaking changes in PR #18 that went out in patch 2.0.3

  _Javier Julio_

## 2.0.3 (February 15, 2018)

- [See the version release](https://github.com/Rykian/clockwork/releases) for the commits that were included.
