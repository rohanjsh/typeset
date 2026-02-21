# Contributing

Thank you for contributing to TypeSet.

This project targets production Flutter applications, so consistency, test coverage, and API stability are required.

## Development setup

1. Install Flutter (stable channel).
2. Clone the repository.
3. Run:

```bash
flutter pub get
flutter test
flutter analyze
```

## Contribution guidelines

- Keep changes focused and minimal.
- Preserve backward compatibility unless a breaking change is explicitly intended.
- Add or update tests for behavior changes.
- Update documentation (`README.md`, `CHANGELOG.md`, `MIGRATION.md`) when APIs or behavior change.
- Follow lints from `very_good_analysis`.

## Pull request checklist

- [ ] Code compiles.
- [ ] Tests pass.
- [ ] Analyzer reports no issues.
- [ ] Public API is documented with dartdoc.
- [ ] Changelog entry added or updated.
- [ ] Migration notes added for breaking changes.

## Release process (maintainers)

1. Confirm version in `pubspec.yaml`.
2. Finalize changelog and migration notes.
3. Validate with:

```bash
flutter analyze
flutter test
dart pub publish --dry-run
```

4. Tag release (`vX.Y.Z`) after merge.
5. Publish to pub.dev.

## Reporting issues

Please open issues with:

- Environment details (Flutter/Dart version, platform).
- Minimal reproducible input.
- Expected vs actual behavior.
- Logs or stack traces when available.
