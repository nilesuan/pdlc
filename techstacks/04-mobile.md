---
name: mobile stack
description: Industry-standard mobile app stacks — native (SwiftUI, Jetpack Compose) and cross-platform (Flutter, React Native, KMP)
type: research
---

# Mobile

**Question:** What are the current industry-standard stacks for building mobile apps (iOS and Android) in 2026, and what evidence supports each claim?
**Status:** Draft.
**Last updated:** 2026-04-24.
**Scope:** Consumer and B2B mobile applications on iOS and Android. Embedded RTOS, automotive, and wearables outside iOS/watchOS/Wear OS are out of scope.

## Shape of the decision

Mobile has two structural realities that shape every choice:

1. **iOS and Android are the only platforms that matter at scale.** Apple's App Store and Google Play are the only two meaningful distribution channels for consumer apps [SYNTHESIS — treated as an axiom; ample market-share evidence exists outside this document].
2. **Every team picks native or cross-platform first.** That one choice determines 80% of everything else.

The live axes:

| Axis | Options |
|---|---|
| iOS UI | **SwiftUI (modern default)** or UIKit (legacy/complex cases) |
| Android UI | **Jetpack Compose (modern default)** or Android Views / XML (legacy) |
| Cross-platform | **Flutter**, **React Native**, **Kotlin Multiplatform + Compose Multiplatform**, or older options (.NET MAUI, Xamarin, Ionic/Capacitor) |
| Distribution and CI tooling | Xcode Cloud, Fastlane, Bitrise, etc. |

## Evidence base

From [[Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology)] (accessed 2026-04-24), "other frameworks and libraries" subsection, all-respondents usage [VERIFIED]:

- **Flutter** — 9.4% (all respondents), 9.4% professional, 11.1% learning-to-code
- **React Native** — 8.4% (all respondents), 9.0% professional, 6.7% learning-to-code
- **SwiftUI** — 4.3% (all respondents)
- **.NET MAUI** — 3.1% (all respondents)
- **Xamarin** — 2.9% (all respondents)
- **Ionic** — 2.5% (all respondents)

Stack Overflow 2025 did not publish a comparable mobile-frameworks breakdown in the technology section [VERIFIED — I fetched the 2025 technology page and the mobile frameworks are not broken out with percentages there].

Jetpack Compose was not listed as a separate row in the Stack Overflow 2024 "other frameworks" list that I extracted. That does not mean it lacks adoption; Stack Overflow's framing groups Android development under the broader "Android" platform category rather than listing Compose explicitly.

## Native: SwiftUI and Jetpack Compose

### iOS: SwiftUI is the modern default

**Standing.** SwiftUI is Apple's declarative UI framework, introduced at WWDC 2019. It is the framework Apple directs new iOS development toward in its own documentation and tutorials [UNVERIFIED in this session — Apple's developer.apple.com positioning is widely repeated but I did not fetch the current doc pages directly].

**What it replaced / did not replace.** UIKit remains shipped, maintained, and used heavily for complex screens, for apps with a deep UIKit codebase, and for surfaces SwiftUI still doesn't cover well. Many iOS apps in 2026 are hybrid SwiftUI + UIKit. [SYNTHESIS — universally reported; not a single primary citation in this session.]

**Language.** Swift (Apple's 2014 language) is the industry-standard iOS language; Objective-C is legacy.

### Android: Jetpack Compose is the modern default

**Standing.** Jetpack Compose is Google's declarative UI framework for Android, reached 1.0 in July 2021. Google has positioned Compose as the recommended approach for new Android UI. [UNVERIFIED in this session — I did not fetch developer.android.com directly; this is consistent with secondary commentary cited throughout 2024-2025 and Google's public conference content.]

**Language.** Kotlin is the primary language for new Android development. The official Android developer site states: "Kotlin is a modern statically typed programming language used by over 60% of professional Android developers," Android Studio provides "first-class support for Kotlin," and the "modern UI toolkit" (Jetpack Compose) is "built on Kotlin" [[Android developers — Kotlin](https://developer.android.com/kotlin)] (accessed 2026-04-24) [VERIFIED]. The page does not use the exact phrase "preferred language" but positions Kotlin as the default for modern Android. Java still runs large swaths of existing Android code; all new Google Android samples/docs are Kotlin-first. [SYNTHESIS from Android developer docs and Jetpack Compose positioning.]

### Why native is still the default for high-end consumer apps

- **Platform features arrive first in native.** Widgets, Live Activities, Lock Screen widgets, watchOS, Dynamic Island, iPad multitasking, Android-specific intents — all ship in native SDKs first; cross-platform frameworks wrap them with a lag. [SYNTHESIS, not a single citation.]
- **Accessibility, internationalization, and platform idioms** are best supported natively.
- **App quality** (animation smoothness, memory profile, startup time) is structurally easier to achieve in native code.

## Cross-platform: Flutter, React Native, KMP+CMP

### Flutter

**Standing.** Flutter is Google's cross-platform UI framework using the Dart language. In Stack Overflow 2024, Flutter was the most-used cross-platform framework at 9.4% [[SO 2024 Technology](https://survey.stackoverflow.co/2024/technology)] [VERIFIED].

**Approach.** Flutter renders its own UI through Skia/Impeller, not through the native UI toolkits, which gives consistent rendering across platforms but means widgets do not look 100% native unless explicitly styled to match. Dart (Google's language, 2011) compiles ahead-of-time to native code on mobile.

**Trade-off:** pixel-perfect consistency and strong performance vs. non-native feel on iOS in particular, and a smaller hiring pool (Dart is not widely used outside Flutter).

### React Native

**Standing.** React Native is Meta's cross-platform UI framework using React and JavaScript/TypeScript. Stack Overflow 2024: 8.4% all respondents, 9.0% professional [VERIFIED].

**Approach.** Unlike Flutter, React Native renders to native platform widgets. The "New Architecture" (Fabric renderer, TurboModules, JSI) shipped through 2023–2024 and is the default for new RN projects as of late 2024. [UNVERIFIED in this session — the React Native team's blog covers this; I did not fetch it directly.]

**Trade-off:** closer-to-native feel, shared talent pool with web React engineers, very large ecosystem — but performance is bounded by the JS runtime and bridge, and UI consistency across iOS/Android requires work.

**Expo.** Expo is the managed workflow layer on top of React Native; in practice most new React Native projects start from Expo rather than bare React Native. [UNVERIFIED in this session — Expo's adoption is widely reported; I did not fetch a primary stats source.]

### Kotlin Multiplatform + Compose Multiplatform (KMP + CMP)

**Standing.** KMP is JetBrains/Google's approach for sharing Kotlin code across iOS, Android, desktop, and web. Compose Multiplatform extends Jetpack Compose to non-Android targets.

**Maturity.** Compose Multiplatform's iOS target reached **Stable** status in the **Compose Multiplatform 1.8.0** release, announced on the JetBrains blog: "the release of Compose Multiplatform 1.8.0, which brings Compose for iOS to Stable"; "All major APIs are now officially stable" with compatibility guarantees [[JetBrains — Compose Multiplatform 1.8.0 release (May 2025)](https://blog.jetbrains.com/kotlin/2025/05/compose-multiplatform-1-8-0-release/)] (accessed 2026-04-24) [VERIFIED].

**Trade-off:** share business logic cleanly in Kotlin (often with native UI on iOS), or share UI too via Compose Multiplatform at the cost of some native feel. Adoption is still smaller than Flutter or React Native, but growing; IDE support (IntelliJ/Android Studio) is first-class because JetBrains owns the toolchain.

### .NET MAUI and Xamarin

Stack Overflow 2024: .NET MAUI 3.1%, Xamarin 2.9% [[SO 2024 Technology](https://survey.stackoverflow.co/2024/technology)] [VERIFIED]. MAUI is the successor to Xamarin for .NET developers. Primarily used by shops already on .NET.

### Ionic / Capacitor and Cordova (WebView-based)

Stack Overflow 2024: Ionic 2.5% [[SO 2024](https://survey.stackoverflow.co/2024/technology)] [VERIFIED]. WebView-based apps (a native shell hosting HTML/CSS/JS) are a long-standing option for teams that want to maximize code reuse with their web product. Quality ceiling is lower than Flutter or React Native but development is faster for web-native teams.

## The "Flutter vs React Native" question

Both frameworks are stable, enterprise-used, and actively developed. The cited numbers above show them effectively tied on adoption among professional developers in Stack Overflow 2024 (9.4% vs 9.0%).

Choice usually comes down to:

- **Have a React/TypeScript web team already?** → React Native reuses that talent.
- **Want the most pixel-perfect cross-platform UI?** → Flutter's own rendering gives tighter consistency.
- **Care about hiring pool?** → React Native (JS) > Flutter (Dart) in absolute pool size; Flutter has lower internal competition.
- **Want to minimize bridge overhead?** → Flutter has a structurally simpler model; React Native's New Architecture closed much of the gap.

[SYNTHESIS — the trade-off bullets are widely repeated in industry commentary but no single primary source lays them out exactly as above.]

## CI / build / release tooling

- **Xcode Cloud** — Apple's managed CI for iOS; has grown but Fastlane + GitHub Actions / Bitrise remains the most common combo. [UNVERIFIED.]
- **Fastlane** — the de facto open-source tool for App Store + Play Store releases (code signing, screenshots, beta distribution). Used from either a developer laptop or any CI. [UNVERIFIED specific adoption numbers; Fastlane's role is widely taken as default in native mobile pipelines.]
- **Bitrise, Codemagic** — mobile-specialized managed CI with first-class iOS/Android signing.
- **GitHub Actions and GitLab CI** — generic CI, fully capable of mobile builds with macOS runners; dominant in new projects.

## Putting the stack together (typical 2026 defaults)

- **Greenfield iOS app:** Swift + SwiftUI (UIKit interop where needed). Xcode + GitHub Actions / Xcode Cloud + Fastlane.
- **Greenfield Android app:** Kotlin + Jetpack Compose. Android Studio + GitHub Actions + Fastlane or Gradle + Play Publisher.
- **Cross-platform, small team, web-team spillover:** React Native + Expo + TypeScript.
- **Cross-platform, pixel-perfect UI priority:** Flutter + Dart.
- **Shared-logic cross-platform with native UIs:** Kotlin Multiplatform (business logic) + SwiftUI + Jetpack Compose.
- **Hybrid WebView (quickest route from existing web app):** Capacitor (Ionic) or just a native shell around a web app.

## Sources (accessed 2026-04-24)

- [Stack Overflow Developer Survey 2024 — Technology](https://survey.stackoverflow.co/2024/technology)
- [Stack Overflow Developer Survey 2025 — Technology](https://survey.stackoverflow.co/2025/technology/)
- [JetBrains State of Developer Ecosystem 2024](https://www.jetbrains.com/lp/devecosystem-2024/)
- [Android developers — Kotlin](https://developer.android.com/kotlin)
- [JetBrains — Compose Multiplatform 1.8.0 release (May 2025)](https://blog.jetbrains.com/kotlin/2025/05/compose-multiplatform-1-8-0-release/)

## Open questions

- **Jetpack Compose specific adoption %.** Not broken out in Stack Overflow 2024/2025; would need to fetch Google's Android developer blog and the JetBrains Kotlin Developer Ecosystem report.
- **SwiftUI vs UIKit mix in production apps.** Widely reported as "hybrid" but no recent quantified survey data located.
- **Expo share of React Native projects.** Expo Application Services grew substantially 2023–2025 but I did not locate a primary stat.
- **W3Techs-style data on "what current mobile apps are built with."** Not located in this session.
