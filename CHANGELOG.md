# Changelog

All notable changes to this project are documented in this file.

## 3.0.0-beta.1

> Breaking release focused on parser/renderer architecture, configuration
> standardization, and safer AutoLink controls.
>
> Pre-release notice: this is a beta version intended for validation before stable `3.0.0`.

### Added

- `TypeSetConfig` for centralized widget/controller configuration.
- `TypeSetStyle` for style-level customization.
- `TypeSetAutoLinkConfig` with scheme allowlist, domain allowlist, and custom URL validator.
- `TypeSetConfigProvider` for subtree-scoped configuration.
- `TypeSetGlobalConfig` for app-level defaults.
- Parser/renderer AST pipeline (`TypesetParser`, `TypesetRenderer`, typed nodes).

### Changed

- `TypeSet` now reads behavior from `config`, then scoped provider config, then global defaults.
- `TypeSetEditingController` now accepts `config` instead of individual style parameters.
- Underline delimiter is standardized as `__text__`.
- Public exports were reorganized to include the new config model API.

### Removed

- Legacy parser/controller internals from public architecture.
- Legacy per-widget and per-controller style parameters replaced by config objects.
- Legacy explicit link marker syntax parsing in widget/controller APIs.

### Breaking changes

- `TypeSet` constructor parameters removed:
  - `linkRecognizerBuilder`
  - `linkStyle`
  - `monospaceStyle`
  - `boldStyle`
- `TypeSetEditingController` constructor parameters removed:
  - `linkStyle`
  - `linkRecognizerBuilder`
  - `monospaceStyle`
  - `boldStyle`
  - `markerColor`
- `StyleTypeEnum.link` was removed from context menu options.
- Underline syntax changed from `#text#` to `__text__`.

See [MIGRATION.md](MIGRATION.md) for step-by-step updates.

## 2.3.0

### Added

- `TypeSetEditingController` for editing with inline formatting preview.
- Updated example app to include editing and context menu flows.

### Changed

- Added default URL launcher behavior for links.

## 2.2.0

### Added

- Link recognition callback support.

### Breaking changes

- `recognizer` renamed to `linkRecognizerBuilder`.

## 2.1.2

### Changed

- Dependency updates.

## 2.1.1

### Fixed

- Moved `mocktail` to `dev_dependencies`.

## 2.1.0

### Added

- `getTypesetContextMenus()` helper for text selection toolbars.

### Changed

- Default monospace font set to `Courier`.

### Breaking changes

- `TypeSet(inputText: "Foo")` changed to `TypeSet("Foo")`.

## 2.0.0

### Added

- Dynamic font sizing support.
- Explicit literal escaping support.

### Fixed

- Formatting behavior for strings with spaces.

### Breaking changes

- Underline marker changed from `//` to `#`.
- Link marker changed from `[]` style to `§text|url§`.
- Reserved-character escaping behavior updated.

## 1.0.3

### Changed

- Dependency updates.

## 1.0.2

### Changed

- Dependency and CI updates.

## 1.0.1+1

### Added

- `linkStyle`, `monospaceStyle`, and `recognizer` options.

## 1.0.0+4

### Changed

- README updates.

## 1.0.0+1

### Added

- First stable release.

## 0.1.0+23

### Added

- Asterisk-based bold support.

## 0.1.0+22

### Changed

- Screenshot update.

## 0.1.0+21

### Changed

- License set to Apache-2.0.

## 0.1.0+20

### Added

- `textAlign` support.

## 0.1.0+19

### Added

- String extension API.

## 0.1.0+18

### Added

- Initial WhatsApp-style formatting support.
