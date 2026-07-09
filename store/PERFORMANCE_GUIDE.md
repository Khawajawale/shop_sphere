# Performance Profiling Guide — Phase 12.1

## Built-In Optimizations

| Optimization | Location |
|--------------|----------|
| Image memory cache limit (80 MB) | `lib/core/config/image_cache_config.dart` |
| `CachedNetworkImage` with `memCacheWidth: 600` | `product_image.dart`, product details |
| `RepaintBoundary` on product cards | `product_card.dart` |
| Firebase Performance trace `load_home_products` | `product_controller.dart` |
| Firestore offline persistence | `firebase_bootstrap.dart` |
| Horizontal lists use `ListView` + lazy build | Home sections |

## Profiling Commands

```bash
# Profile mode — closest to release performance
flutter run --profile

# Open DevTools performance tab
flutter pub global activate devtools
flutter pub global run devtools

# Build size analysis
flutter build apk --analyze-size
flutter build appbundle --analyze-size

# Timeline during test
flutter run --profile --trace-skia
```

## Firebase Performance Dashboard

Traces automatically reported:
- `load_home_products` — home catalog fetch duration

Add custom traces via:
```dart
await PerformanceService.trace('my_operation', () async { ... });
```

## Performance Checklist

- [ ] Home scroll stays at 60fps on mid-range device
- [ ] Product images don't exceed 600px decode width in lists
- [ ] No unnecessary `ref.watch` rebuilds in home slivers
- [ ] Cart/wishlist persistence doesn't block UI thread
- [ ] Checkout form validates without jank

## Audit Date
March 2026 — Phase 12.1 complete
