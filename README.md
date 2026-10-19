# Zynth Browser — Android-First Web Browser

**Zynth Browser** is an independent, performance-focused, dark-first web browser built with Flutter and Android System WebView (Chromium core), featuring native integration with the **OM Search Engine** (as Zynth Search) and Google as a secondary search engine.

---

## 🚀 Key Features

- **Search Engine Sovereignty:**
  - **Zynth Search (Primary):** Powered by the independent OM Search Engine FastAPI backend (`http://127.0.0.1:8000` or `http://10.0.2.2:8000` on Android emulator).
  - **Google (Secondary):** Integrated standard web search fallback.
  - **Provider Shortcuts:** `@zynth <query>` or `@google <query>` for instant switching directly from the address bar.
  - **Persistent Engine Choice:** Remembers user's engine preference across restarts.
- **Smart URL & Search Router (`UrlParser`):**
  - Distinguishes direct URLs (`https://`, `http://`), bare domains (`example.com` → auto-upgraded to `https://`), IPs/localhost (`localhost:8000`), and natural language search queries.
  - Blocks unsafe protocols (`javascript:`, `file:`, `data:`, `intent:`).
  - Recognizes internal schemes (`about:home`, `about:blank`).
- **Android WebView Integration:**
  - Real website navigation using `webview_flutter`.
  - Android system back button integration via `PopScope` (history back before exiting).
  - Progress feedback, SSL lock indicator, and page title sync.
- **Privacy & Ad-Shield Guard:**
  - Intercepts and drops known telemetry/tracker endpoints (`doubleclick.net`, `googlesyndication.com`, etc.) at the network navigation phase.
- **Local Persistence:**
  - **Bookmarks:** SQLite database (`zynth_browser.db`) with title, URL, and timestamps.
  - **Preferences:** Lightweight persistence for default engine, custom OM Search URL, and shield toggles via `shared_preferences`.
- **Robust Error Handling:**
  - Dedicated offline & navigation error view with retry, quick switch to Google, and return to home.

---

## 📁 Architecture Overview

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # URLs, schemes, preferences keys
│   ├── theme/
│   │   ├── app_colors.dart             # Dark-first OLED palette
│   │   └── app_theme.dart              # Material 3 dark theme definitions
│   └── utils/
│       └── url_parser.dart             # Dedicated, testable URL & search parser
├── models/
│   ├── bookmark.dart                   # SQLite Bookmark data model
│   ├── om_search_result.dart           # Verified OM Search FastAPI schema
│   └── search_engine.dart              # SearchEngineType enum & metadata
├── services/
│   ├── database_service.dart           # SQLite helper with memory fallback
│   ├── preferences_service.dart        # SharedPreferences wrapper
│   └── search_service.dart             # Provider coordination & routing
├── features/
│   ├── browser/
│   │   ├── browser_controller.dart     # Central ChangeNotifier navigation state
│   │   └── presentation/
│   │       ├── browser_screen.dart     # Main scaffold & PopScope back handler
│   │       └── widgets/
│   │           ├── browser_app_bar.dart        # Address bar with provider badge
│   │           ├── browser_bottom_bar.dart     # Back, forward, home, bookmark, menu
│   │           ├── browser_home_view.dart      # Zynth branded home & shortcuts
│   │           ├── error_view.dart             # Offline & error state UI
│   │           └── provider_selector_sheet.dart# Bottom sheet engine selector
│   ├── bookmarks/
│   │   └── bookmarks_sheet.dart        # SQLite bookmarks manager
│   ├── search/
│   │   ├── search_provider.dart        # SearchProvider abstract contract
│   │   ├── search_provider_factory.dart# Provider singleton factory
│   │   ├── google_search_provider.dart # Google search engine provider
│   │   └── zynth_search_provider.dart  # OM Search backend integration
│   └── settings/
│       └── settings_sheet.dart         # Preferences, OM Search tester, shields
└── main.dart                           # Entry point initializing storage & app
```

---

## 🔍 Verified OM Search Contract

From `D:\Projects\Om Search Engine`:
- **Search API:** `GET /api/v1/search?q={query}&page={page}&size={size}`
- **Suggestions API:** `GET /api/v1/suggestions?q={prefix}&limit={n}`
- **Health Check:** `GET /api/v1/health`
- **Response Schema:** `OmSearchResponse` (query, total, page, size, total_pages, took_ms, results with id, url, title, snippet, score, highlights).

---

## 🛠️ Testing & Execution Commands

### Run Unit Tests
```bash
flutter test test/core/url_parser_test.dart
flutter test test/features/search/search_provider_test.dart
flutter test test/models/bookmark_test.dart
flutter test test/widget/browser_ui_test.dart
```

### Static Analysis
```bash
flutter analyze
```

### Run on Android Device / Emulator
```bash
flutter run -d android
```

### Build Debug APK
```bash
flutter build apk --debug
```

### Build Release Split APKs
```bash
flutter build apk --release --split-per-abi
```
