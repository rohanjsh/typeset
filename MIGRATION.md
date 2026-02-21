# Migration guide: 2.x to 3.0.0

This guide covers all required updates from `2.x` to `3.0.0`.

## Summary

Version `3.0.0` keeps TypeSet simple to adopt while moving customization into explicit config objects.

- **Quick adoption**: continue using `TypeSet('text')`.
- **Advanced control**: use `TypeSetConfig`, `TypeSetStyle`, and `TypeSetAutoLinkConfig`.

## 1) Underline syntax changed

Update message content:

- Old: `#text#`
- New: `__text__`

If your backend stores formatted strings, migrate underline markers in stored templates/messages.

## 2) `TypeSet` customization moved into `config`

### Before (2.x)

```dart
TypeSet(
  'Open https://flutter.dev',
  linkRecognizerBuilder: (text, url) => TapGestureRecognizer()..onTap = () {},
  linkStyle: const TextStyle(color: Colors.blue),
  monospaceStyle: const TextStyle(fontFamily: 'Courier'),
  boldStyle: const TextStyle(fontWeight: FontWeight.bold),
)
```

### After (3.0.0)

```dart
TypeSet(
  'Open https://flutter.dev',
  config: TypeSetConfig(
    style: const TypeSetStyle(
      linkStyle: TextStyle(color: Colors.blue),
      monospaceStyle: TextStyle(fontFamily: 'Courier'),
      boldStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
    autoLinkConfig: TypeSetAutoLinkConfig(
      linkRecognizerBuilder: _buildRecognizer,
    ),
  ),
)
```

## 3) `TypeSetEditingController` customization moved into `config`

### Before (2.x)

```dart
final controller = TypeSetEditingController(
  text: 'Hello *world*',
  markerColor: Colors.grey,
  linkStyle: const TextStyle(color: Colors.blue),
  monospaceStyle: const TextStyle(fontFamily: 'Courier'),
  boldStyle: const TextStyle(fontWeight: FontWeight.bold),
  linkRecognizerBuilder: (text, url) => TapGestureRecognizer()..onTap = () {},
);
```

### After (3.0.0)

```dart
final controller = TypeSetEditingController(
  text: 'Hello *world*',
  config: TypeSetConfig(
    style: const TypeSetStyle(
      markerColor: Colors.grey,
      linkStyle: TextStyle(color: Colors.blue),
      monospaceStyle: TextStyle(fontFamily: 'Courier'),
      boldStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
    autoLinkConfig: TypeSetAutoLinkConfig(
      linkRecognizerBuilder: _buildRecognizer,
    ),
  ),
);
```

## 4) Context menu link option removed

`StyleTypeEnum.link` is no longer available.

For links, TypeSet now focuses on AutoLink detection (`http`, `https`, `www`) and controlled recognizer behavior through `TypeSetAutoLinkConfig`.

## 5) Configure once for a subtree or entire app

### Scoped configuration

```dart
TypeSetConfigProvider(
  config: TypeSetConfig.defaults().copyWith(
    autoLinkConfig: TypeSetAutoLinkConfig.httpsOnly,
  ),
  child: const TypeSet('Docs: https://dart.dev'),
)
```

### Global configuration

```dart
TypeSetGlobalConfig.instance = TypeSetConfig(
  autoLinkConfig: TypeSetAutoLinkConfig.httpsOnly,
);
```

## Migration checklist

- [ ] Replace underline `#...#` with `__...__` in all input sources.
- [ ] Move `TypeSet` style/link params into `TypeSetConfig`.
- [ ] Move `TypeSetEditingController` style/link params into `TypeSetConfig`.
- [ ] Remove `StyleTypeEnum.link` usage.
- [ ] Add/update `TypeSetAutoLinkConfig` policy for allowed schemes/domains.
- [ ] Run `flutter analyze` and tests.
