# shine_kit

The shared design kit of the **myShine** (patients, Shine teal) and **drShine** (clinics, indigo) apps by SmileLabs.
Direction C: the aligner is the hero, big tight display type, white tiles on light grey, pill buttons, one accent per app.
Mockups: https://claude.ai/artifact/4JuqvRd5CyLioSs6Sh1y6N (row C).

## Use

```yaml
dependencies:
  shine_kit:
    path: ../shine-kit
```

```dart
MaterialApp(theme: kitTheme(KitAccent.myShine, Brightness.light), darkTheme: kitTheme(KitAccent.myShine, Brightness.dark));
final p = context.kit; // colours for the current app and mode
```

## Pieces

| Piece | What it is |
|---|---|
| `KitArchHero` | The aligner on an upper arch in soft light (a drawing until the patient's own scan replaces it) |
| `KitType.display` | Hero numbers and headlines: "Aligner 04/08", "€100" |
| `KitHeadline` | Eyebrow, title with a grey second line, body |
| `KitTile`, `KitStat`, `KitIconBadge` | White tiles, number tiles, accent icons |
| `KitPanel` | The white panel that rises over the hero |
| `KitButton`, `KitButton.secondary`, `KitRoundButton` | Black and white pills, round 44 pt buttons |
| `KitListGroup`, `KitListRow` | Inset grouped rows with state and chevron |
| `KitTabBar` | The floating pill tab bar |
| `KitSlideToConfirm` | Slide to send, for actions that can't be undone (a plain button for screen readers) |
| `KitWordmark` | "my"/"dr" in the accent, "Shine" in ink |

Fonts: Inter and Inter Display, shipped in `fonts/` (SIL Open Font License). No third-party packages.

## Check

```
flutter analyze && flutter test
cd example && flutter build web   # the gallery: every piece, both apps, light and dark
```
