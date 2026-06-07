# Teka Luxe — Agent Guide

> This file is written for AI coding agents. It describes the project architecture, conventions, and workflows so an agent can modify code safely without prior context.

## Project Overview

**Teka Luxe** is a premium T-shirt e-commerce Flutter application. It currently implements:

- Onboarding flow (first-run detection)
- Full authentication system (email/password, Google Sign-In, email verification, password reset)
- Responsive UI with custom theming
- Multi-platform support: Android, iOS, Web, macOS, Windows, Linux
- Deep-link handling for password reset (`teka-luxe://auth-callback`)

The app uses **Firebase Auth** as the primary authentication provider and **Supabase** as the database for user profile storage. A custom Netlify-hosted HTML page handles Firebase password reset outside the app.

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.27+ (Dart 3.6+) |
| State Management | `flutter_bloc` (Cubit pattern) |
| Navigation | `go_router` |
| Authentication | `firebase_auth`, `google_sign_in` |
| Database | Supabase (PostgreSQL via `supabase_flutter`) |
| Local Storage | `shared_preferences` |
| Network | `connectivity_plus` |
| Theming | Custom Material 3 theme with `google_fonts` |
| Icons | `lucide_icons` |
| Localization | Flutter gen-l10n (ARB files) |
| Dev Tools | `flutter_lints`, `flutter_native_splash` |

---

## Project Structure

```
lib/
├── main.dart                          # Entry point: Firebase + Supabase init
├── app.dart                           # MyApp: MaterialApp.router, auth session, redirects
├── app_dependencies.dart              # Service locator / dependency factory
├── firebase_options.dart              # FlutterFire-generated platform configs
├── core/
│   ├── config/
│   │   ├── stitch_config.dart         # STITCH_API_KEY from --dart-define
│   │   └── supabase_config.dart       # SUPABASE_URL / SUPABASE_ANON_KEY from --dart-define
│   ├── constants/
│   │   ├── app_constants.dart         # Asset paths
│   │   └── storage_keys.dart          # SharedPreferences keys
│   ├── errors/
│   │   ├── auth_error_code.dart       # Enum mapping Firebase/Supabase errors → localizable codes
│   │   ├── exceptions.dart            # AppException / AuthException hierarchy
│   │   ├── failures.dart              # Failure / AuthFailure hierarchy (domain layer)
│   │   └── supabase_exceptions.dart   # SupabaseExceptionMapper (Postgrest → AuthException)
│   ├── network/
│   │   └── network_info.dart          # ConnectivityNetworkInfo (connectivity + DNS lookup)
│   ├── router/
│   │   ├── app_router.dart            # GoRouter configuration with custom transitions
│   │   └── route_names.dart           # Route constants
│   ├── theming/
│   │   ├── app_theme.dart             # Light / dark ThemeData
│   │   ├── app_colors.dart            # Color palette
│   │   ├── app_text_styles.dart       # Google Fonts text styles (Bebas Neue + Space Grotesk)
│   │   ├── app_button_styles.dart     # Elevated / Outlined / Text button styles
│   │   ├── app_input_styles.dart      # InputDecorationTheme
│   │   ├── app_sizes.dart             # Spacing & sizing tokens
│   │   ├── app_breakpoints.dart       # Responsive breakpoints
│   │   └── theming.dart               # Barrel export
│   └── utils/
│       ├── device_helper.dart         # Responsive layout helpers
│       ├── result.dart                # Result<T> sealed class (Success / FailureResult)
│       ├── system_ui_helper.dart      # Fullscreen / immersive system UI
│       └── validators.dart            # Email, password, phone (Libyan), name validators
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart   # FirebaseAuthRemoteDatasource
│   │   │   ├── models/
│   │   │   │   └── user_model.dart               # UserModel from Firebase User
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart     # Guards exceptions → Result
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart                     # UserEntity
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart          # IAuthRepository interface
│   │   │   └── usecases/
│   │   │       ├── check_email_verified.dart
│   │   │       ├── forgot_password.dart
│   │   │       ├── get_current_user.dart
│   │   │       ├── login.dart
│   │   │       ├── logout.dart
│   │   │       ├── register.dart
│   │   │       ├── sign_in_with_google.dart
│   │   │       └── verify_email.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_form_cubits.dart         # LoginFormCubit, RegisterFormCubit, ForgotPasswordFormCubit
│   │       │   ├── auth_form_state.dart          # Immutable form states with copyWith
│   │       │   ├── auth_session_cubit.dart       # Global auth state stream
│   │       │   └── verify_email_cubit.dart       # Email verification polling
│   │       └── pages/
│   │           ├── forgot_password/
│   │           ├── login/
│   │           ├── sign_up/
│   │           └── verify_email/
│   ├── home/
│   │   └── presentation/
│   │       ├── bloc/home_cubit.dart
│   │       └── pages/home_page.dart
│   └── startup/
│       ├── data/
│       │   ├── datasources/startup_local_datasource.dart
│       │   ├── models/onboarding_slide_model.dart
│       │   └── repositories/startup_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── onboarding_slide.dart
│       │   │   └── startup_state.dart
│       │   ├── repositories/startup_repository.dart
│       │   └── usecases/
│       │       ├── check_first_run.dart
│       │       ├── complete_onboarding.dart
│       │       └── resolve_initial_route.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── onboarding_cubit.dart
│           │   └── startup_cubit.dart
│           ├── pages/
│           │   ├── onboarding_page.dart
│           │   └── startup_page.dart
│           └── widgets/
├── l10n/
│   ├── app_en.arb                     # English localization source
│   └── generated/                     # `flutter gen-l10n` output (DO NOT EDIT)
└── shared/
    ├── services/
    │   └── local_storage_service.dart   # SharedPreferences wrapper
    └── widgets/
        ├── buttons/
        │   ├── primary_button.dart
        │   └── secondary_button.dart
        └── forms/
            ├── app_text_field.dart
            └── archive_text_field.dart
```

### Architecture Rules

1. **Clean Architecture**: `data` → `domain` ← `presentation`. Domain has no Flutter dependencies.
2. **Dependency Injection**: `AppDependencies.create()` manually wires all objects. No code-generation DI.
3. **State Management**: Use `Cubit` (from `flutter_bloc`) for all feature states. Avoid `setState` for business logic.
4. **Navigation**: Use `go_router` only. Route names live in `RouteNames`.
5. **Error Handling**: Remote exceptions are caught in the repository, mapped to `Failure`, and returned as `Result<T>.failure`. UI layers display `failure.localizedMessage(l10n)`.
6. **Localization**: All user-facing strings must be in `lib/l10n/app_en.arb`. Run `flutter gen-l10n` after changes.

---

## Build & Run Commands

```bash
# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Analyze code
flutter analyze

# Run on a connected device
flutter run

# Run with custom Supabase credentials (recommended for production builds)
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Generate native splash (after changing flutter_native_splash config in pubspec.yaml)
dart run flutter_native_splash:create
```

---

## Configuration Files

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Flutter dependencies, assets, native splash config |
| `analysis_options.yaml` | Includes `package:flutter_lints/flutter.yaml` |
| `l10n.yaml` | gen-l10n config (ARB dir, template, output class) |
| `firebase.json` | FlutterFire platform mappings (Android/iOS) |
| `supabase/config.toml` | Supabase CLI local-dev configuration |
| `.env` | Local environment variables (API keys, etc.) |
| `devtools_options.yaml` | Dart DevTools extension settings |

---

## Localization

- Source file: `lib/l10n/app_en.arb`
- Generated output: `lib/l10n/generated/`
- **Do not edit generated files.**
- After modifying ARB, run:
  ```bash
  flutter gen-l10n
  ```
- Access in widgets:
  ```dart
  final l10n = AppLocalizations.of(context);
  l10n.loginTitle;
  ```

---

## Theming Conventions

- Colors are centralized in `AppColors`. Avoid hard-coding hex values in widgets.
- Text styles use `GoogleFonts.bebasNeue` (display/headings) and `GoogleFonts.spaceGrotesk` (body/labels).
- Use `DeviceHelper` for responsive values rather than `MediaQuery` directly.
- Buttons: prefer `PrimaryButton` / `SecondaryButton` from `shared/widgets/buttons/`.
- Inputs: prefer `AppTextField` from `shared/widgets/forms/`.

---

## Testing

**Current state:** The project has **no automated tests** yet (`test/` and `integration_test/` directories do not exist).

When adding tests, follow these conventions:

- Unit tests for use cases, repositories, and validators.
- Widget tests for shared components (`PrimaryButton`, `AppTextField`).
- Use `bloc_test` for Cubit testing.
- Mock external dependencies (Firebase, Supabase, Connectivity) with `mocktail` or `mockito`.

Run tests with:
```bash
flutter test
```

---

## Security Considerations

1. **Firebase API keys** are embedded in `firebase_options.dart` and `netlify/reset-password/index.html`. These are public client keys; restrict usage via Firebase App Check or API key restrictions in the Google Cloud Console.
2. **Supabase anon key** is embedded in `lib/core/config/supabase_config.dart` with a fallback value. Override via `--dart-define=SUPABASE_ANON_KEY=...` in CI/production builds.
3. **Deep link scheme** `teka-luxe://auth-callback` is registered in `AndroidManifest.xml` and `Info.plist`.
4. **Password reset** is handled by a standalone HTML page (`netlify/reset-password/index.html`) hosted on Netlify. It uses Firebase JS SDK to apply the reset code and then redirects back to the app.
5. **RLS policies** in Supabase are intentionally permissive for anon writes to the `users` table (to support the current Firebase Auth + Supabase anon-key flow). See migration files in `supabase/migrations/`.

---

## Deployment Notes

- **Android/iOS**: Standard Flutter build pipeline. Ensure `google-services.json` and `GoogleService-Info.plist` are up to date.
- **Web**: The `netlify/reset-password/` folder is deployed separately to Netlify for the password-reset flow.
- **Supabase**: Migrations are in `supabase/migrations/`. Apply with Supabase CLI:
  ```bash
  supabase db push
  ```
- **Native splash**: Configured in `pubspec.yaml` under `flutter_native_splash`. Regenerate after changes.

---

## Useful References

- `docs/guides/firebase_auth_backend_ai_guide.md` — Detailed backend/auth architecture guide used as a specification for the auth module.
- `supabase/migrations/` — SQL schema and RLS policy evolution.
