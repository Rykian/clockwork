## 4.0.1 ##

* Update ACTIVE_SUPPORT_VERSION default to 8.1 (81b6cd2)
* Drop test-unit dependency with migrated test (eac1064)
* Remove unused base64, bigdecimal and ostruct dependencies (f171d8f)

## 4.0.0 ##

* BREAKING CHANGE: Drop EOL versions of Ruby and ActiveSupport, drop JRuby support (4f0d4a7)
* Add Spring DST fix for Issue 60 with tests (89f15ed)

## 3.0.2 ##

* Fixing clockworkd on Ruby 3.2 (a73a9d5)

## 3.0.1 ##

* Notify error using error handler if configured (49075c2)

## 3.0.0 ##

* BREAKING CHANGE: drop Rubinius support
* add Ruby 3.0 support (65d71f)
* fix a bug with OpenStruct (15eb030)
* allow `:skip_first_run` in database events (429bc0a)
* add rescue to prevent hung up by exception (cc1b7c9)
* fix CI errors (16b4e19 & e4480ea)
* fix a compatibility bug with Rails 7 (5907bc7)
* Add "Finished" log with duration and error summary (66419ab)

## 2.0.4 ##

*   Reverts the breaking changes in PR #18 that went out in patch 2.0.3

    *Javier Julio*

## 2.0.3 (February 15, 2018) ##

*   [See the version release](https://github.com/Rykian/clockwork/releases) for the commits that were included.
