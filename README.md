# Wholesale ERP & POS (Offline-First)

Internal store ERP + POS system built with Flutter + Firebase Cloud Firestore
(offline persistence enabled) and Riverpod.

## Status
🚧 **Foundation stage** — Clean Architecture skeleton, core entities (Customer,
Product, Transaction), theming, and CI build pipeline are in place. Feature
UI/logic modules (Dashboard, POS, Debt Ledger, Inventory, Reports) are built
one at a time.

## Getting Started

1. `flutter pub get`
2. Run `flutterfire configure` to generate `lib/firebase_options.dart` and
   platform config files (these are gitignored — do NOT commit them).
3. Uncomment the `options:` line in `lib/main.dart` once step 2 is done.
4. `flutter run`

## Architecture

Clean Architecture with a `core/` (cross-cutting), `shared/` (cross-feature
domain: Customer/Product/Transaction), and `features/` (one folder per
module: dashboard, pos, debt_ledger, inventory, reports) split. Each feature
has its own `data / domain / presentation` layers.

- **State management:** Riverpod. Firestore-backed lists use
  `StreamProvider` (via `.snapshots()`) so cached data renders instantly,
  even offline. Ephemeral UI state (e.g. the POS cart) uses
  `StateNotifierProvider` and is only written to Firestore once, atomically,
  at checkout.
- **Offline persistence:** enabled in `core/services/firestore_service.dart`,
  called once in `main()` before `runApp`.

## CI

`.github/workflows/build.yml` builds a debug APK on every push to
`main`/`develop` and uploads it as a workflow artifact.
