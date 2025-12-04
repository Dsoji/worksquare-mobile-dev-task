# Worksquare Senior Mobile App Developer Vetting Task

Welcome to the vetting assessment for **Senior Mobile App Developers** at Worksquare.

This task is meant to assess your skills in building a modern, mobile-first housing listings interface. We're particularly interested in your ability to structure mobile apps, manage state effectively, and design an intuitive user experience.

---

##  Objective

Build a housing listings app using either **React Native** (with or without Expo) or **Flutter**.  
The app should display a list of available properties in a user-friendly format, with support for filtering by **location** and **property type**.



##  Project Structure & Architecture

This implementation uses a **feature-first** Flutter architecture with clear separation between UI, state, and utilities.

- **Top-level**
  - `lib/main.dart` – app entry, global `ThemeData`, and `ProviderScope`.
  - `assets/` – images, icons, JSON data (including `assets/json/listing.json`).
- **Common modules**
  - `lib/common/res/`
    - `base.dart` – base asset paths and API URLs.
    - `assets.dart` – strongly typed asset paths (e.g. `ImageAssets.logo`).
    - `app_spacing.dart` – spacing constants used across the UI.
    - `app_typography.dart` – shared text-style helpers.
- **Features**
  - `lib/features/splash/`
    - `splash_screen.dart` – splash that routes to `HomeScreen`.
  - `lib/features/home/`
    - `home_screen.dart` – main listings grid, filters UI, and shimmer states.
    - `listing_details.dart` – property details view.
    - `model/`
      - `listing_model.dart` – `Listing` data model parsed from JSON.
      - `filter_config.dart` – immutable filter configuration passed to the sheet.
    - `providers/`
      - `listings_provider.dart` – Riverpod `FutureProvider` loading the JSON listings.
    - `utils/`
      - `listing_utils.dart` – helpers for price parsing, location extraction, hero tags.
    - `widgets/`
      - `listing_grid_item.dart` – animated listing card + hero transition.
      - `home_filter_sheet.dart` – bottom sheet for filters (type, price, bedrooms).

### State Management

- **Library**: `hooks_riverpod` + `flutter_hooks`.
- **Reasoning**:
  - `FutureProvider` cleanly encapsulates async JSON loading and error/loading states.
  - Hooks (`useState`) keep local UI state (filters, visible count) scoped to the screen.
  - Riverpod’s immutability and testability support scaling to more features.

### UI / UX Decisions

- Listings are shown in a **staggered 2-column grid** with:
  - Shimmer placeholders that mirror the final card layout to reduce layout shift.
  - **Staggered entrance animations** (fade, lift, scale) for each card.
  - **Hero animation** between the grid image and the detail header.
- Filters:
  - A **bottom-sheet filter** for property type, price range, and minimum bedrooms.
  - A **persistent location dropdown** above the grid using `dropdown_button2` so location is always visible and easy to change.
- Details screen:
  - Emphasizes hero image, price chip, and key attributes (beds/baths) with clear hierarchy.
- Accessibility:
  - `Semantics` wrappers for listing cards and the filter button.
  - Color choices tuned for better contrast in dark mode (e.g. price chip background vs. text).
- Screenshots:

  <p align="center">
    <img src="assets/screenshot/Simulator Screenshot - iPhone 16 - 2025-12-04 at 08.11.05.png" alt="Worksquare app screenshot 1" width="250" />
    <img src="assets/screenshot/Simulator Screenshot - iPhone 16 - 2025-12-04 at 08.11.10.png" alt="Worksquare app screenshot 2" width="250" />
    <img src="assets/screenshot/Simulator Screenshot - iPhone 16 - 2025-12-04 at 08.11.14.png" alt="Worksquare app screenshot 3" width="250" />
    <img src="assets/screenshot/Simulator Screenshot - iPhone 16 - 2025-12-04 at 08.11.20.png" alt="Worksquare app screenshot 4" width="250" />
  </p>

---

##  How to Run the App

1. **Install Flutter**
   - Ensure Flutter (3.8.x+ compatible with `sdk: ^3.8.1`) is installed and on your PATH.
2. **Get dependencies**
   - From the project root:
     - `flutter pub get`
3. **Run on a device or emulator**
   - `flutter run`  
   - Select your desired simulator/emulator or connected device.

The app will start on the splash screen, then navigate to the home listings grid.

---

##  Tools & Libraries Used

- **Core**
  - Flutter (Material 3)
  - `hooks_riverpod` – state management.
  - `flutter_hooks` – hook-based widget lifecycle/helpers.
- **UI / UX**
  - `staggered_grid_view` – staggered grid layout for listings.
  - `shimmer` – loading skeletons for cards.
  - `dropdown_button2` – enhanced dropdown for location selection.
- **Other**
  - Built-in `Navigator` and `MaterialPageRoute` for navigation.

---

##  Approach & Thought Process

- Started with **data loading and modeling**: parse JSON into a strongly typed `Listing` model and expose it through a `FutureProvider`.
- Designed a **feature-first folder structure** so each feature (`home`, `splash`) owns its models, providers, utils, and widgets.
- Focused on **separation of concerns**:
  - `home_screen.dart` handles layout and wiring.
  - Providers handle data fetching.
  - Utils provide pure transformation functions.
  - Widgets encapsulate reusable UI (card, filter sheet).
- Iteratively improved UX:
  - Added shimmer while loading and nice empty/error states.
  - Introduced filters and then refactored them into a dedicated sheet and `FilterConfig`.
  - Polished card animations and added hero transitions for a premium feel.

---

##  Submission Summary

### Component Structure & Organization
- **Feature-first layout** keeps each flow self-contained: `lib/features/home` hosts its models, providers, utils, and widgets; `lib/features/splash` owns splash-only logic.
- **Common resources** (spacing, typography, asset helpers) live under `lib/common/res`, ensuring UI consistency without duplicating constants.
- **Entry point** `lib/main.dart` wires Material 3 theme data, color scheme, and a global `ProviderScope`, while assets (JSON, screenshots) sit in `assets/`.

### State Management
- Uses **`hooks_riverpod` + `flutter_hooks`**:
  - `FutureProvider<List<Listing>>` (`listings_provider.dart`) handles async JSON parsing with built-in loading/error states.
  - Hook state (`useState`, `useMemoized`) keeps transient UI interactions—like active filters, sheet visibility, staggered animation offsets—local to `HomeScreen`.
- Reasoning: Riverpod’s immutable providers and test-friendly architecture scale better than `setState` or `Provider`, while hooks keep widget trees lean and declarative without boilerplate.

### UI / UX Decisions
- **Home listings grid** uses `flutter_staggered_grid_view` for a masonry feel, shimmer placeholders to avoid layout shifts, and staggered fade/scale animations for perceived performance.
- **Filters** live in a reusable bottom sheet (`home_filter_sheet.dart`) with chip-style toggles, sliders, and dropdowns so criteria are discoverable but non-intrusive; location stays as a persistent dropdown for quick changes.
- **Detail view** leans on hero transitions, price chips, and concise attribute rows (beds/baths/sqft) to establish hierarchy and readability.
- **Accessibility** considerations include `Semantics` wrappers around cards/buttons, color contrast tuned for dark mode, and larger tap targets on filter controls.

### Screenshots / Inspiration
- High-fidelity mocks were inspired by modern housing apps (Airbnb, Zillow) emphasizing immersive imagery and clean typography.
- Reference screenshots are stored in `assets/screenshot/` and showcased earlier in this README for quick visual context.

---

##  Limitations & Future Improvements

- The detail screen uses a generated description; a real backend would provide richer content (amenities, square footage, etc.).
- Filters are all client-side on the JSON; a real app would likely integrate server-side filtering and pagination.
- Only one theme variant is tuned (dark-first); more time could be spent on light theme polish and accessibility audits.
- No offline caching or error retry UI yet.

---

##  AI Usage

- AI assistance (ChatGPT/Cursor) was used to:
  - Suggest UX enhancements (hero animations, shimmer layout, filter refactor).
  - Generate some boilerplate for providers, utils, and this README documentation.
- All generated code and text were reviewed and adjusted to fit the project’s architecture and requirements.

---

---

##  Submission Instructions

1. **Fork this repository**
2. Set up your mobile app project inside the fork (no starter files are provided)
3. Work in a branch named after your **GitHub handle**
4. Push your final code to GitHub
5. Send us an email with the following:
   - GitHub repository link
   - Live demo link (e.g. Expo, APK file, or TestFlight)
   - Any relevant notes or context about your work

---

