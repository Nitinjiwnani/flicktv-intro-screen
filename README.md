# FlickTV Intro Screen

### Flutter UI/UX Animation Assignment · Nitin Jiwnani

A high-fidelity Flutter implementation of the provided dark-themed Blinkit Money reference screen, built as a take-home assignment for FlickTV.

The project focuses on polished UI, smooth staged animations, custom native confetti, scroll-aware behavior, and maintainable Flutter code without third-party animation packages.

---

## Demo

* 🎥 [Simulator Screen Recording](https://drive.google.com/file/d/1g0FCVgRq0k0Pe1w3jw67vW4FYWa_jObD/view?usp=sharing)
* 🎥 [Android APK Screen Recording](https://drive.google.com/file/d/1CuUHPKfJY8rWCAwjuW-AZudEpC3r8xIO/view?usp=sharing)
* 📱 [Download APK](https://drive.google.com/file/d/1f7SpU4TSQV1gZ_lqwxXKtQAy4grGnwGW/view?usp=sharing)

---

## Assignment Summary

The task was to design and develop a screen similar to the provided reference video.

Required deliverables:

* GitHub repository link
* Screen recording of the implementation
* APK file

Assignment requirements:

* Package name: `flicktv.nitinjiwnani`
* App name: `Nitin Jiwnani`
* Relevant fonts, icons, and images allowed
* No third-party packages

---

## Key Features

* Dark premium UI matching the provided assignment reference
* Wallet entrance animation with subtle continuous wobble
* Native package-free confetti burst
* `blinkit MONEY` title reveal
* Smooth upward header transition
* Staggered feature card animations
* Add Money CTA reveal
* Gift card row reveal
* Bottom ghost tagline and muted watermark
* Scroll-based `Blinkit Money` app bar title reveal
* Top-edge scroll fade to avoid hard clipping

---

## Technical Highlights

| Area                    | Implementation                                                             |
| ----------------------- | -------------------------------------------------------------------------- |
| Animation orchestration | `AnimationController`, `CurvedAnimation`, `Interval`                       |
| Confetti                | Custom `CustomPainter` + particle model                                    |
| Wallet motion           | Scale entrance + continuous subtle wobble                                  |
| Staggered UI reveal     | Cards, CTA, gift row, and tagline reveal through interval-based animations |
| Scroll behavior         | `SingleChildScrollView` with scroll-based app bar title reveal             |
| Top fade effect         | `ShaderMask` with `LinearGradient`                                         |
| State management        | `StatefulWidget` + dedicated animation controller                          |

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_assets.dart
│   │   └── confetti_constants.dart
│   └── theme/
│       ├── app_colors.dart
│       └── app_text_styles.dart
├── features/
│   └── intro/
│       ├── animation/
│       │   └── intro_animation_controller.dart
│       ├── widgets/
│       │   ├── add_money_button.dart
│       │   ├── background_dots.dart
│       │   ├── bottom_tagline.dart
│       │   ├── confetti_overlay.dart
│       │   ├── feature_card.dart
│       │   ├── feature_card_list.dart
│       │   ├── gift_card_row.dart
│       │   ├── intro_top_bar.dart
│       │   ├── title_block.dart
│       │   └── wallet_widget.dart
│       └── intro_screen.dart
├── painters/
│   ├── confetti_painter.dart
│   └── particle.dart
└── main.dart
```

---

## Architecture Notes

The screen is animation-heavy but has no shared business state. For that reason, the implementation uses a `StatefulWidget` with a dedicated `IntroAnimationController` instead of external state management.

`IntroAnimationController` owns:

* Master animation controller
* Wallet wobble controller
* Confetti controller
* Interval-based animation values
* Particle spawning for the confetti burst

The UI widgets remain mostly presentational. They receive plain `double` progress values and render based on those values.

Confetti is isolated using:

* Separate `AnimatedBuilder`
* `RepaintBoundary`
* `IgnorePointer`
* Custom `CustomPainter`

This keeps the main UI from rebuilding on every confetti frame.

---

## Requirements

Make sure Flutter is installed and configured.

```bash
flutter doctor
```

Recommended:

```text
Flutter stable channel
Android device/emulator for APK testing
```

---

## Run Locally

Clone the repository:

```bash
git clone https://github.com/Nitinjiwnani/flicktv-intro-screen.git
cd flicktv-intro-screen
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

---

## Build APK

Create a release APK:

```bash
flutter build apk --release
```

APK output path:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Verification Checklist

Before submission:

* [x] `flutter analyze` passes with zero issues
* [x] App launches directly into the intro screen
* [x] App name is `Nitin Jiwnani`
* [x] Package name is `flicktv.nitinjiwnani`
* [x] No debug banner is visible
* [x] Wallet entrance animation plays smoothly
* [x] Confetti starts early and fades out naturally
* [x] `blinkit MONEY` reveal works correctly
* [x] Feature cards reveal one by one
* [x] Add Money button and Gift Card row reveal smoothly
* [x] Scroll behavior works after animation
* [x] `Blinkit Money` title appears in app bar on scroll
* [x] No overflow, missing asset, or layout errors

---

## Assets & Attribution

Full attribution is available in [`ASSET_SOURCES.md`](./ASSET_SOURCES.md).

| Asset              | Usage                                  | Source                                          |
| ------------------ | -------------------------------------- | ----------------------------------------------- |
| Inter font         | App typography                         | Google Fonts, Open Font License                 |
| `wallet.png`       | Hero wallet and muted bottom watermark | Generated using Claude Design                   |
| `gift_card.png`    | Gift card row thumbnail                | Freepik / Flaticon                              |
| Feature card icons | Feature card visuals                   | Flutter Material Icons bundled with Flutter SDK |

---

## Notes

This project intentionally avoids third-party animation/UI packages. Although package-based options could have been used for effects like confetti, the implementation uses vanilla Flutter primitives to demonstrate animation fundamentals and performance-conscious UI composition.
