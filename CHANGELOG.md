
# Changelog

# 2.1.2
### Chore
- Dependency updates

# 2.1.1
### Bug Fixes
- Moved `mocktail` to `dev_dependencies` to avoid conflicts with other packages and build configs.

# 2.1.0
### New
- Introducing context menus, use `getTypesetContextMenus()` to get the context menus for the text.
- Change default monospace font to `Courier`, as provided by the operating system.

### Breaking
- `TypeSet(inputText: "Foo")` is now `TypeSet("Foo")` to match semantics of `Text("Foo")`

### Other
- Remove `google_fonts` dependency
- 95% test coverage
- Deprecated parser removed

# 2.0.0
### New Features
- **Dynamic Font Sizing:** Font size can now be applied dynamically, enhancing visual hierarchy and readability.
- **Literal Character Rendering:** Introducing the literal symbol `¦` to unambiguously represent reserved characters in text formatting, ensuring clarity in rendered output.

### Bug Fixes
- **Spacing in Strings:** Corrected an issue where strings containing spaces were not formatted correctly, improving the robustness and reliability of the text display.

### Breaking Changes
- **Underline Style Update:** The syntax for underlining text has changed. The previous `//` markers are now replaced with `#`. This shift streamlines the styling process and aligns with common markdown practices.
- **Link Style Update:** The syntax for link text has changed. The previous `[]` markers are now replaced with `§`. A link text would look like this `§rohanjsh|https://rohanjsh.dev§`
- **Reserved Character Escaping:** Incorporating the new literal `¦` necessitates the explicit marking of reserved characters to be treated as literals. This modifies how users will work with text that includes characters previously used for formatting.

# 1.0.3
- chore: update dependencies

# 1.0.2
- chore: update dependencies, ci flows

# 1.0.1+1
- feat: 3 new properties added `linkStyle`, `monospaceStyle`, `recognizer` 💙

# 1.0.0+4
- chore: readme update

# 1.0.0+1
🎉🎉🎉 It's time to celebrate! Our first stable release is finally here! 🎉🎉🎉


- Make text formatting backend driven (if needed) with one widget!!
- Whatsapp like formatting with some addons!!
(input looks something like this)

**Usage**
- BOLD → Hello, \*World!*
- ITALIC → Hello,  \_World!_ 
- STRIKETHROUGH → Hello, \~World!~
- UNDERLINE → Hello, //World!// 
- MONOSPACE → Hello, \`World!`
- LINK → [google.com|https://google.com]

Thanks for choosing our text formatting widget for all your formatting needs. We hope these updates make your experience even more enjoyable! 🤗

# 0.1.0+23
- feat: make asterisk bold
# 0.1.0+22
- chore: update screenshot
# 0.1.0+21
- docs: license to Apache 2.0

# 0.1.0+20
- feat: added property `textAlign`🎉

# 0.1.0+19

- feat: added extension method for typeset 🎉
# 0.1.0+18

- feat: WhatsApp like formatting for you all!🎉


Thank you for being part of our journey. Your feedback is the beacon that guides our innovation. 
*Please note that all changes included in beta releases are for testing purposes and may change before the final release.* 
