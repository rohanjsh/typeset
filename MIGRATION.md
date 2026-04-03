# Migration Guide: v2.x → v3.0.0

> **Estimated effort:** 10–30 minutes for most projects.

---

## At a Glance

| What changed         | v2.x                     | v3.0                          | Impact                    |
| -------------------- | ------------------------ | ----------------------------- | ------------------------- |
| Underline syntax     | `#text#`                 | `__text__`                    | 🔴 Content/backend change |
| Escape character     | `¦` (broken bar)         | `\` (backslash)               | 🔴 Content/backend change |
| Link syntax          | `§text\|url§` (explicit) | AutoLink (auto-detected URLs) | 🔴 Content/backend change |
| Font size syntax     | `text<24>`               | Removed                       | 🟡 Remove usage           |
| Widget styling       | Individual params        | `TypeSetConfig` object        | 🟡 API change             |
| Controller styling   | Individual params        | `TypeSetConfig` object        | 🟡 API change             |
| Context menu enum    | `StyleTypeEnum`          | `TypesetFormatAction`         | 🟡 API change             |
| `StyleTypeEnum.link` | Available                | Removed                       | 🟡 Remove usage           |
| `url_launcher` dep   | Required                 | Not needed                    | 🟢 Lighter package        |
| Config scoping       | Per-widget only          | Global → Scoped → Local       | 🟢 New feature            |

> 🔴 = breaking &nbsp; 🟡 = requires code change &nbsp; 🟢 = no action needed

---

## Step-by-Step

### 1. Update `pubspec.yaml`

```yaml
dependencies:
  typeset: ^3.0.0 # was ^2.3.0
```

```bash
flutter pub get
```

---

### 2. Update Underline Syntax in Content

The underline delimiter changed from `#` to `__` (double underscore).

```diff
- Hello #underlined# world
+ Hello __underlined__ world
```

> [!IMPORTANT]
> If your backend stores formatted strings, **update stored templates and messages** to use `__` instead of `#`.

---

### 3. Update Escape Characters in Content

The escape character changed from `¦` (broken bar) to `\` (backslash).

```diff
- Use ¦* to show a literal asterisk
+ Use \* to show a literal asterisk
```

---

### 4. Migrate Link Syntax to AutoLink

Explicit link markers (`§text|url§`) have been replaced by automatic URL detection.

```diff
- §Visit Flutter|https://flutter.dev§
+ Visit https://flutter.dev
```

URLs starting with `http://`, `https://`, or `www.` are now detected automatically. To make links tappable, configure a recognizer:

```dart
TypeSetConfig(
  autoLinkConfig: TypeSetAutoLinkConfig(
    linkRecognizerBuilder: (text, url) =>
        TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse(url)),
  ),
);
```

---

### 5. Migrate `TypeSet` Widget Params → `TypeSetConfig`

Individual style parameters have been consolidated into a single `config` object.

<table>
<tr><th>v2.x</th><th>v3.0</th></tr>
<tr>
<td>

```dart
TypeSet(
  'Open https://flutter.dev',
  linkRecognizerBuilder: (text, url) =>
    TapGestureRecognizer()..onTap = () {},
  linkStyle: const TextStyle(
    color: Colors.blue,
  ),
  monospaceStyle: const TextStyle(
    fontFamily: 'Courier',
  ),
  boldStyle: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
)
```

</td>
<td>

```dart
TypeSet(
  'Open https://flutter.dev',
  config: TypeSetConfig(
    style: const TypeSetStyle(
      linkStyle: TextStyle(
        color: Colors.blue,
      ),
      monospaceStyle: TextStyle(
        fontFamily: 'Courier',
      ),
      boldStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    autoLinkConfig: TypeSetAutoLinkConfig(
      linkRecognizerBuilder: (text, url) =>
        TapGestureRecognizer()..onTap = () {},
    ),
  ),
)
```

</td>
</tr>
</table>

**Removed `TypeSet` parameters:**

| Removed parameter       | Moved to                                             |
| ----------------------- | ---------------------------------------------------- |
| `linkStyle`             | `TypeSetConfig.style.linkStyle`                      |
| `boldStyle`             | `TypeSetConfig.style.boldStyle`                      |
| `monospaceStyle`        | `TypeSetConfig.style.monospaceStyle`                 |
| `linkRecognizerBuilder` | `TypeSetConfig.autoLinkConfig.linkRecognizerBuilder` |

---

### 6. Migrate `TypeSetEditingController` Params → `TypeSetConfig`

<table>
<tr><th>v2.x</th><th>v3.0</th></tr>
<tr>
<td>

```dart
final controller = TypeSetEditingController(
  text: 'Hello *world*',
  markerColor: Colors.grey,
  linkStyle: const TextStyle(
    color: Colors.blue,
  ),
  monospaceStyle: const TextStyle(
    fontFamily: 'Courier',
  ),
  boldStyle: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
  linkRecognizerBuilder: (text, url) =>
    TapGestureRecognizer()..onTap = () {},
);
```

</td>
<td>

```dart
final controller = TypeSetEditingController(
  text: 'Hello *world*',
  config: TypeSetConfig(
    style: const TypeSetStyle(
      markerColor: Colors.grey,
      linkStyle: TextStyle(
        color: Colors.blue,
      ),
      monospaceStyle: TextStyle(
        fontFamily: 'Courier',
      ),
      boldStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    autoLinkConfig: TypeSetAutoLinkConfig(
      linkRecognizerBuilder: (text, url) =>
        TapGestureRecognizer()..onTap = () {},
    ),
  ),
);
```

</td>
</tr>
</table>

**Removed `TypeSetEditingController` parameters:**

| Removed parameter       | Moved to                                             |
| ----------------------- | ---------------------------------------------------- |
| `markerColor`           | `TypeSetConfig.style.markerColor`                    |
| `linkStyle`             | `TypeSetConfig.style.linkStyle`                      |
| `boldStyle`             | `TypeSetConfig.style.boldStyle`                      |
| `monospaceStyle`        | `TypeSetConfig.style.monospaceStyle`                 |
| `linkRecognizerBuilder` | `TypeSetConfig.autoLinkConfig.linkRecognizerBuilder` |

---

### 7. Update Context Menu Code

The enum `StyleTypeEnum` has been replaced with `TypesetFormatAction`, and `StyleTypeEnum.link` has been removed entirely.

<table>
<tr><th>v2.x</th><th>v3.0</th></tr>
<tr>
<td>

```dart
getTypesetContextMenus(
  editableTextState: editableTextState,
  styleTypes: [
    StyleTypeEnum.bold,
    StyleTypeEnum.italic,
    StyleTypeEnum.link,     // ❌ removed
  ],
)
```

</td>
<td>

```dart
getTypesetContextMenus(
  editableTextState: editableTextState,
  actions: [               // renamed param
    TypesetFormatAction.bold,
    TypesetFormatAction.italic,
    // link removed — use AutoLink
  ],
)
```

</td>
</tr>
</table>

---

### 8. Remove Font Size Syntax _(if used)_

Dynamic font sizing (`text<24>`) has been removed. If you used this feature, replace with standard Flutter `TextStyle` sizing or split into separate widgets.

```diff
- TypeSet('Important<24> notice')
+ TypeSet('*Important* notice', style: TextStyle(fontSize: 16))
```

---

### 9. Remove `url_launcher` Dependency

TypeSet v3.0 no longer depends on `url_launcher`. If `typeset` was the only package pulling it in, you can remove it:

```bash
flutter pub remove url_launcher
```

If you still need `url_launcher` for your own link handling (e.g., inside `linkRecognizerBuilder`), keep it — but it's no longer a transitive dependency of TypeSet.

---

### 10. (Optional) Set Up Config Scoping

v3.0 introduces config cascading — a new feature that lets you configure once for an entire subtree or app:

```dart
// App-wide defaults
void main() {
  TypeSetGlobalConfig.current = TypeSetConfig(
    autoLinkConfig: TypeSetAutoLinkConfig.httpsOnly,
  );
  runApp(const MyApp());
}

// Subtree override
TypeSetConfigProvider(
  config: TypeSetConfig.defaults().copyWith(
    style: const TypeSetStyle(markerColor: Color(0xFF9E9E9E)),
  ),
  child: const ChatScreen(),
);
```

---

## Migration Checklist

Use this checklist to track your progress:

- [ ] Update `pubspec.yaml` to `typeset: ^3.0.0`
- [ ] Replace underline `#...#` with `__...__` in all content sources
- [ ] Replace escape character `¦` with `\` in all content sources
- [ ] Replace explicit link syntax `§text|url§` with raw URLs
- [ ] Remove `text<size>` font size syntax (if used)
- [ ] Move `TypeSet` widget style/link params into `TypeSetConfig`
- [ ] Move `TypeSetEditingController` style/link params into `TypeSetConfig`
- [ ] Replace `StyleTypeEnum` with `TypesetFormatAction` in context menus
- [ ] Remove `StyleTypeEnum.link` usage
- [ ] Remove `url_launcher` if no longer needed
- [ ] (Optional) Set up `TypeSetGlobalConfig` or `TypeSetConfigProvider`
- [ ] Run `flutter analyze` — fix any remaining issues
- [ ] Run your test suite — update assertions if needed
