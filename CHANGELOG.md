# Changelog

## v0.9.0 - pre release
* Features
  * Allow type to be set dynamically #94 (@benfalk)
  * Add JaSerializer.Params.to_attributes/1 for merging relationships and attributes
* Bugfixes
  * Don't render all pagination links when only one page of results #96 (@adamboas)
  * Relax Ecto and Plug dependencies.

## v0.8.1
* Performance
  * Improved performance of included (sideloaded) relationships. #86 (@dgvncsz0f)

## v0.8.0
* **Breaking**
  * You must now set the Phoenix :format_encoder for json-api to Poison in
    config.exs. Phoenix now handles conversion from map to json string.
    See README for details.
* Features
  * Allow Poison 2.0
* Bugfixes
  * Allow application/*, */* and empty accept headers without returning 406.
  * Count errors now display full message in description.
  * Fixed serializing lists - [#78](https://github.com/AgilionApps/ja_serializer/pull/78)

## v0.7.1
* Features
  * Param parsing now happens via a protocol for extensibility.

## v0.7.0
* **Breaking**
  * Pagination, sorting, filtering query param keys are now formatted with the
    configured key_format. This means the API outputs and expects dasherized by default. (@linstula)
* Features
  * Deprecations messages now consitently formatted and contain a stack trace. (@derekprior)

## v0.6.3
* Features
  * Type is now formatted as underscore or dasherized, same as your key setting. (@linstula)

## v0.6.2
* Features
  * Updates error serializer to include field name in description. (@cjbell)
* Bugfixes
  * Retain type information when deserializing. (@linstula)
  * Fix pipe warning in Elixir 1.2 (@bortevik)

## v0.6.1
* Features
  * Allow query params in link formatting. (@simonprev)
  * Deps added to application for exrm. (@dmarkow)
* Bugfixes
  * fomat_key typo in ecto_error_serializer (@gordonbisner)

## v0.6.0
* Features
  * Support json-api spec `include` query param. (@green-arrow)
  * Support json-api spec `fields` query param. (@green-arrow)
  * Add meta info support

## v0.5.0
* Features:
  * Support custom ids in relationships. (@green-arrow)
  * Adds error rendering support to Phoenix view.
* Deprecations:
  * Use key `serializer` instead of `include` when defining relationships.
* Dependencies:
  * Ecto is now a required (non-optional) dependency.

## v0.4.0
* Features:
  * Adds support for pagination links w/ Scrivener or via opts. (@vysakh0)
* Bugfixes:
  * Properly serialize empty relationships. (@dmarkow)

## v0.3.1

* Bugfixes
  * Adds optional Ecto dependency to fix compliation issue.

## v0.3.0

* **Breaking**:
  * Raises exception if ecto relationship is not pre-fetched.
* Features:
  * Adds JaSerializer.ErrorSerializer
  * Adds JaSerializer.EctoErrorSerializer
  * Pre-defines formats for Ecto built in types.

## v0.2.0

* Features:
  * Add Phoenix integration w/ JaSerializer.PhoenixView.
  * Infer type from module name.
  * Add `attributes/2` callback w/ default implementation based on `attributes/1` macro.
  * Add JaSerializer.ContentTypeNegotiation plug for setting content type.
  * Add JaSerializer.Deserializer plug for param normalization.
* Deprecations:
  * Remove `serialize` macro in favor of `type/0` callback.

## v0.1.2

* Bugfix
  * Added non-fallback formatters for simple data types to improve out of the box performance.

## v0.1.1

* Bugfixes:
  * Fix issues w/ include chains that resulted in infinite loops.

## v0.1.0

* Features:
  * Add config option for formatting keys as underscored or dasherized.
* Bugfixes:
  * Serialize include chains w/o duplicates.

## v0.0.1

* Initial release.
