# Teka Luxe — Restructure Plan

> Clean Architecture + Better State Management for a Small-to-Medium E-Commerce Clothes App

---

## 1. Current State Assessment

### What's Good ✅
- **Theming**: Material 3, dark mode, responsive breakpoints, Google Fonts, design tokens
- **Error Handling**: Comprehensive Firebase + Supabase error mapping, localized
- **Auth Flow**: Email/password, Google Sign-In, verification, password reset — all implemented
- **Localization**: 149 ARB entries, fully wired
- **Custom Transitions**: Consistent page transitions with `go_router`
- **Network Guards**: Connectivity checks before remote calls
- **Transaction Safety**: Cleanup on auth failure (delete Firebase user, sign out)

### What's Broken 🔴
- **Compilation Error**: `AppDependencies` missing use case fields (`login`, `register`, etc.)
- **Architecture Drift**: Two parallel repository systems — old (`lib/data/`) vs new (`lib/features/`), old one is active
- **Old Repository**: Doesn't use `Result<T>` pattern that use cases expect
- **Incomplete Redirects**: Only `/home` is guarded; auth pages accessible while logged in
- **Dead Code**: `lib/providers/auth_provider.dart` is unused
- **No Deep Link Handling**: `teka-luxe://auth-callback` registered natively but not in router
- **Zero Tests**: No unit, widget, or integration tests

### What's Missing for E-Commerce 🛒
- Product catalog (browse, filter, search)
- Product details (images, sizes, colors, description)
- Cart (add, remove, quantity, persist)
- Favorites / Wishlist
- Orders (checkout, history, status tracking)
- User profile (addresses, payment methods, settings)
- Categories / Collections

---

## 2. Target Architecture

### 2.1 Folder Structure

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # MyApp + MaterialApp.router
├── injection.dart                     # GetIt service locator (replaces AppDependencies)
├── firebase_options.dart
│
├── core/
│   ├── config/
│   │   ├── supabase_config.dart
│   │   └── app_config.dart            # Feature flags, API endpoints
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── storage_keys.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   ├── failures.dart
│   │   ├── auth_error_code.dart
│   │   └── supabase_exceptions.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_button_styles.dart
│   │   ├── app_input_styles.dart
│   │   ├── app_sizes.dart
│   │   ├── app_breakpoints.dart
│   │   └── app_auth_palette.dart
│   ├── utils/
│   │   ├── result.dart
│   │   ├── validators.dart
│   │   ├── device_helper.dart
│   │   ├── system_ui_helper.dart
│   │   └── extensions/              # String, DateTime, BuildContext extensions
│   └── usecases/
│       └── usecase.dart               # Base UseCase<T, P> class
│
├── shared/
│   ├── widgets/
│   │   ├── buttons/
│   │   ├── forms/
│   │   ├── cards/
│   │   ├── images/
│   │   ├── loaders/
│   │   └── layouts/
│   └── services/
│       └── local_storage_service.dart
│
├── l10n/
│   ├── app_en.arb
│   └── generated/
│
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── auth_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── check_email_verified.dart
    │   │       ├── forgot_password.dart
    │   │       ├── get_current_user.dart
    │   │       ├── login.dart
    │   │       ├── logout.dart
    │   │       ├── register.dart
    │   │       ├── sign_in_with_google.dart
    │   │       └── verify_email.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_session_cubit.dart
    │       │   ├── auth_session_state.dart
    │       │   ├── login_cubit.dart
    │       │   ├── login_state.dart
    │       │   ├── register_cubit.dart
    │       │   ├── register_state.dart
    │       │   ├── forgot_password_cubit.dart
    │       │   ├── forgot_password_state.dart
    │       │   └── verify_email_cubit.dart
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   ├── register_page.dart
    │       │   ├── forgot_password_page.dart
    │       │   └── verify_email_page.dart
    │       └── widgets/
    │           └── auth_scaffold.dart
    │
    ├── startup/
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    │
    ├── home/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    │
    ├── products/                      # NEW
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── products_remote_datasource.dart
    │   │   │   └── products_local_datasource.dart   # Cache
    │   │   ├── models/
    │   │   │   ├── product_model.dart
    │   │   │   ├── category_model.dart
    │   │   │   └── review_model.dart
    │   │   └── repositories/
    │   │       └── products_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── product.dart
    │   │   │   ├── category.dart
    │   │   │   └── review.dart
    │   │   ├── repositories/
    │   │   │   └── products_repository.dart
    │   │   └── usecases/
    │   │       ├── get_products.dart
    │   │       ├── get_product_by_id.dart
    │   │       ├── get_categories.dart
    │   │       ├── search_products.dart
    │   │       └── filter_products.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── products_cubit.dart      # List/grid state
    │       │   ├── products_state.dart
    │       │   ├── product_detail_cubit.dart
    │       │   └── product_detail_state.dart
    │       ├── pages/
    │       │   ├── products_page.dart
    │       │   └── product_detail_page.dart
    │       └── widgets/
    │           ├── product_card.dart
    │           ├── product_grid.dart
    │           ├── category_chip.dart
    │           └── size_selector.dart
    │
    ├── cart/                          # NEW
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── cart_local_datasource.dart       # Hive or SharedPreferences
    │   │   ├── models/
    │   │   │   └── cart_item_model.dart
    │   │   └── repositories/
    │   │       └── cart_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── cart_item.dart
    │   │   ├── repositories/
    │   │   │   └── cart_repository.dart
    │   │   └── usecases/
    │   │       ├── get_cart.dart
    │   │       ├── add_to_cart.dart
    │   │       ├── remove_from_cart.dart
    │   │       ├── update_quantity.dart
    │   │       ├── clear_cart.dart
    │   │       └── get_cart_total.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── cart_cubit.dart
    │       │   └── cart_state.dart
    │       ├── pages/
    │       │   └── cart_page.dart
    │       └── widgets/
    │           ├── cart_item_tile.dart
    │           └── cart_summary.dart
    │
    ├── favorites/                     # NEW
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── favorites_local_datasource.dart
    │   │   ├── models/
    │   │   │   └── favorite_model.dart
    │   │   └── repositories/
    │   │       └── favorites_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── favorite.dart
    │   │   ├── repositories/
    │   │   │   └── favorites_repository.dart
    │   │   └── usecases/
    │   │       ├── get_favorites.dart
    │   │       ├── toggle_favorite.dart
    │   │       └── is_favorite.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── favorites_cubit.dart
    │       │   └── favorites_state.dart
    │       └── widgets/
    │           └── favorite_button.dart
    │
    ├── orders/                        # NEW (Phase 2)
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    └── profile/                       # NEW (Phase 2)
        ├── data/
        ├── domain/
        └── presentation/
```

### 2.2 Dependency Injection — GetIt

Replace manual `AppDependencies` factory with **GetIt** for clean, testable DI:

```dart
// lib/injection.dart
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => ConnectivityNetworkInfo(sl()));
  sl.registerLazySingleton<LocalStorageService>(() => LocalStorageServiceImpl());
  
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => Supabase.instance.client);
  
  // Auth Feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSource(
      firebaseAuth: sl(),
      googleSignIn: sl(),
      networkInfo: sl(),
      supabaseClient: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => LoginUseCase(sl()));
  sl.registerFactory(() => RegisterUseCase(sl()));
  // ... etc
  
  // Blocs/Cubits
  sl.registerFactory(() => AuthSessionCubit(sl()));
  sl.registerFactory(() => LoginCubit(loginUseCase: sl(), localStorage: sl()));
  // ... etc
}
```

**Why GetIt over manual DI:**
- Automatic lifecycle management (singletons vs factories)
- No boilerplate passing through widget tree
- Easy mocking for tests
- Standard in Flutter community

### 2.3 State Management — Cubit (Keep It)

**Keep `flutter_bloc` + Cubit.** It's already well-implemented. Just fix the issues:

| Current Issue | Fix |
|---|---|
| Missing DI fields | Wire GetIt, remove manual `AppDependencies` |
| `auth_form_cubits.dart` is one file | Split into `login_cubit.dart`, `register_cubit.dart`, etc. |
| `auth_form_state.dart` is one file | Split into `login_state.dart`, `register_state.dart`, etc. |
| States use generic `AuthFormState` | Each cubit gets its own sealed/immutable state class |

**State Pattern (per feature):**
```dart
// products_state.dart
sealed class ProductsState {}

class ProductsInitial extends ProductsState {}
class ProductsLoading extends ProductsState {}
class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<Category> categories;
  final String? selectedCategory;
  ProductsLoaded(this.products, this.categories, {this.selectedCategory});
}
class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}
```

**For Cart — Use `HydratedCubit`** (from `hydrated_bloc`):
- Cart must persist across app restarts
- `HydratedCubit` auto-serializes state to local storage
- No manual SharedPreferences calls needed

### 2.4 Navigation — GoRouter (Keep It)

**Fix redirect logic:**
```dart
String? _redirect(BuildContext context, GoRouterState state) {
  final authState = authSessionCubit.state;
  final isAuthRoute = state.matchedLocation == RouteNames.login ||
                      state.matchedLocation == RouteNames.register ||
                      state.matchedLocation == RouteNames.forgotPassword;
  final isHomeRoute = state.matchedLocation == RouteNames.home;
  final isVerifyRoute = state.matchedLocation == RouteNames.verifyEmail;
  
  // Unknown state — let it resolve
  if (authState.status == AuthStatus.unknown) return null;
  
  // Authenticated user trying to access auth pages → home
  if (authState.isAuthenticated && isAuthRoute) return RouteNames.home;
  
  // Unauthenticated user trying to access protected pages → login
  if (!authState.isAuthenticated && (isHomeRoute || isVerifyRoute)) {
    return RouteNames.login;
  }
  
  // Email not verified → verify email (except verify page itself)
  if (authState.isAuthenticated && 
      !authState.isEmailVerified && 
      !isVerifyRoute) {
    return RouteNames.verifyEmail;
  }
  
  return null;
}
```

**Add shell route for bottom nav:**
```dart
ShellRoute(
  builder: (context, state, child) => MainScaffold(body: child),
  routes: [
    GoRoute(path: RouteNames.home, builder: (_, __) => const HomePage()),
    GoRoute(path: RouteNames.products, builder: (_, __) => const ProductsPage()),
    GoRoute(path: RouteNames.cart, builder: (_, __) => const CartPage()),
    GoRoute(path: RouteNames.favorites, builder: (_, __) => const FavoritesPage()),
    GoRoute(path: RouteNames.profile, builder: (_, __) => const ProfilePage()),
  ],
)
```

### 2.5 Data Flow Pattern

```
UI (Page) 
  → Cubit (Business Logic)
    → Use Case (Orchestration)
      → Repository (Abstraction)
        → Data Source (Firebase/Supabase/API)
          → External Service

Error flows back:
  Data Source Exception
    → Repository catches → maps to Failure
      → Use Case returns Result.failure()
        → Cubit emits Error state
          → UI shows localized error
```

---

## 3. Implementation Phases

### Phase 0: Fix Current State (1-2 days)
- [ ] Add `get_it` to `pubspec.yaml`
- [ ] Create `lib/injection.dart` with GetIt setup
- [ ] Wire new `AuthRepositoryImpl` (the one with `Result<T>`)
- [ ] Delete old `lib/data/` folder (duplicate repositories, datasources, models)
- [ ] Delete `lib/providers/auth_provider.dart` (dead code)
- [ ] Split `auth_form_cubits.dart` → individual cubit files
- [ ] Split `auth_form_state.dart` → individual state files
- [ ] Fix `AppDependencies` or replace entirely with `sl<LoginCubit>()`
- [ ] Fix router redirects (guard all auth routes)
- [ ] Add deep link route for `teka-luxe://auth-callback`
- [ ] Run `flutter analyze` — zero issues
- [ ] Test auth flow end-to-end

### Phase 1: Core E-Commerce (1 week)
- [ ] **Products Feature**
  - Supabase table: `products` (id, name, description, price, images[], category_id, sizes[], colors[], stock)
  - Supabase table: `categories` (id, name, image)
  - Remote datasource + repository + use cases
  - ProductsCubit + ProductsPage (grid with filters)
  - ProductDetailCubit + ProductDetailPage
  - ProductCard widget (image, name, price, favorite toggle)
  
- [ ] **Cart Feature**
  - Local datasource (Hive for structured data, or SharedPreferences for simple)
  - CartRepository + use cases
  - CartCubit (HydratedCubit for persistence)
  - CartPage (item list, quantity controls, summary)
  - Cart badge on bottom nav
  
- [ ] **Favorites Feature**
  - Local datasource (same storage as cart)
  - FavoritesCubit (HydratedCubit)
  - FavoriteButton widget (heart icon, toggle animation)
  
- [ ] **Home Feature**
  - Hero banner carousel
  - Featured products section
  - Categories horizontal scroll
  - New arrivals section

### Phase 2: User Experience (3-4 days)
- [ ] **Profile Feature**
  - User info display/edit
  - Addresses management
  - Order history link
  - Settings (dark mode toggle, language, notifications)
  
- [ ] **Orders Feature**
  - Checkout flow (address, payment method placeholder, confirm)
  - Order confirmation page
  - Order history list
  - Order detail (items, status, tracking)
  
- [ ] **Search**
  - Search bar in app bar
  - Search results page
  - Recent searches (local)
  
- [ ] **Animations**
  - Hero transitions (product card → detail image)
  - Skeleton loaders for product grids
  - Favorite heart burst animation
  - Cart item add animation

### Phase 3: Polish & Testing (3-4 days)
- [ ] **Unit Tests**
  - Use cases (mock repositories)
  - Repositories (mock datasources)
  - Cubits (mock use cases with `bloc_test`)
  
- [ ] **Widget Tests**
  - ProductCard, CartItemTile, FavoriteButton
  - Login form validation
  
- [ ] **Integration Tests**
  - Auth flow: register → verify → login → logout
  - Shopping flow: browse → add to cart → checkout
  
- [ ] **Performance**
  - Image caching (cached_network_image)
  - List virtualization (ListView.builder)
  - Debounce search input
  
- [ ] **Accessibility**
  - Semantic labels
  - Contrast ratios
  - Screen reader support

---

## 4. Supabase Schema (New Tables)

```sql
-- Categories
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  image_url TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Products
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  compare_at_price DECIMAL(10,2),  -- Original price for sales
  images TEXT[] DEFAULT '{}',
  category_id UUID REFERENCES categories(id),
  sizes TEXT[] DEFAULT '{}',
  colors TEXT[] DEFAULT '{}',
  stock INT DEFAULT 0,
  is_featured BOOLEAN DEFAULT false,
  is_new_arrival BOOLEAN DEFAULT false,
  rating DECIMAL(2,1) DEFAULT 0,
  review_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Reviews (Phase 2)
CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Orders (Phase 2)
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending',
  total_amount DECIMAL(10,2) NOT NULL,
  shipping_address JSONB,
  items JSONB NOT NULL,  -- [{product_id, name, price, quantity, size, color}]
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- RLS Policies
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Everyone can read categories and products
CREATE POLICY "Categories are viewable by everyone" ON categories FOR SELECT USING (true);
CREATE POLICY "Products are viewable by everyone" ON products FOR SELECT USING (true);
CREATE POLICY "Reviews are viewable by everyone" ON reviews FOR SELECT USING (true);

-- Users can only see their own orders
CREATE POLICY "Users can view own orders" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create own orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can only create their own reviews
CREATE POLICY "Users can create reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
```

---

## 5. Key Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **DI** | GetIt | Simple, no code generation, testable |
| **State Management** | Cubit (flutter_bloc) | Already in project, proven, predictable |
| **Cart Persistence** | HydratedCubit | Auto-persist, no boilerplate |
| **Product Images** | `cached_network_image` | Caching, placeholders, error widgets |
| **Local DB for Cart** | Hive | Fast, typed, no SQL boilerplate |
| **Bottom Nav** | ShellRoute in GoRouter | Deep linkable tabs, proper back stack |
| **Image Carousel** | `carousel_slider` | Battle-tested, customizable |
| **Pull-to-Refresh** | `RefreshIndicator` (built-in) | Native feel |
| **Shimmer Loading** | `shimmer` package | Skeleton screens for products |

---

## 6. Files to Delete

```
lib/data/                          # Entire folder (old architecture)
lib/domain/                        # Entire folder (old architecture)
lib/providers/auth_provider.dart   # Dead code
lib/app_dependencies.dart          # Replaced by injection.dart
```

---

## 7. New Dependencies to Add

```yaml
dependencies:
  get_it: ^8.0.0                    # DI container
  hive: ^2.2.3                      # Local structured storage
  hive_flutter: ^1.1.0              # Hive Flutter integration
  cached_network_image: ^3.4.1      # Image caching
  carousel_slider: ^5.0.0           # Image carousels
  shimmer: ^3.0.0                   # Skeleton loaders
  equatable: ^2.0.7                 # Value equality (for states)
  
dev_dependencies:
  hive_generator: ^2.0.1            # Hive type adapters
  build_runner: ^2.4.15             # Code generation
  mocktail: ^1.0.4                  # Mocking for tests
  bloc_test: ^10.0.0                # Cubit testing utilities
```

---

## 8. Testing Strategy

### Unit Tests
```
test/
├── core/
│   └── utils/validators_test.dart
├── features/
│   ├── auth/
│   │   ├── domain/usecases/login_test.dart
│   │   └── presentation/bloc/login_cubit_test.dart
│   ├── products/
│   │   ├── domain/get_products_test.dart
│   │   └── presentation/products_cubit_test.dart
│   └── cart/
│       └── domain/add_to_cart_test.dart
```

### Widget Tests
```
test/
├── shared/
│   ├── widgets/product_card_test.dart
│   └── widgets/cart_item_tile_test.dart
└── features/
    └── auth/
        └── presentation/login_page_test.dart
```

### Integration Tests
```
integration_test/
├── auth_flow_test.dart
└── shopping_flow_test.dart
```

---

## 9. Migration Checklist

Before starting Phase 1, ensure:
- [ ] `flutter analyze` passes with zero issues
- [ ] Auth flow works: register → verify → login → home → logout
- [ ] Old `lib/data/` and `lib/domain/` deleted
- [ ] GetIt injection working for all auth features
- [ ] Router redirects working correctly
- [ ] No compilation errors
- [ ] Git commit with message: `chore: clean architecture foundation complete`

---

*Plan written for Teka Luxe v2.0 restructure.*
