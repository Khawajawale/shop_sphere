/// Centralized accessibility labels for screen readers.
class AccessibilityLabels {
  AccessibilityLabels._();

  // Navigation
  static const homeTab = 'Home tab';
  static const wishlistTab = 'Wishlist tab';
  static const cartTab = 'Cart tab';
  static const ordersTab = 'Orders tab';
  static const profileTab = 'Profile tab';

  // Home
  static const searchProducts = 'Search products';
  static const openNotifications = 'Open notifications';
  static const openCart = 'Open cart';
  static const openProfile = 'Open profile';

  // Product
  static String productCard(String name, double price) =>
      '$name, price \$${price.toStringAsFixed(2)}';

  static String addToCart(String name) => 'Add $name to cart';

  static String toggleWishlist(String name, bool isFavorite) =>
      isFavorite ? 'Remove $name from wishlist' : 'Add $name to wishlist';

  // Cart
  static const emptyCart = 'Your cart is empty';
  static const proceedCheckout = 'Proceed to checkout';

  // Wishlist
  static const emptyWishlist = 'No favorites yet';

  // Orders
  static const emptyOrders = 'No orders placed yet';
}
