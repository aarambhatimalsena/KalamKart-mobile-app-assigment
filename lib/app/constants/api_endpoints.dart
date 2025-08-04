class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);

  // Server Base URLs
  // For Android Emulator - use 10.0.2.2 to access localhost
  static const String serverAddress = "http://192.168.100.66:5000";
  // For iOS Simulator or local dev
  // static const String serverAddress = "http://localhost:5000";

  static const String baseUrl = "$serverAddress/api";
  static const String imageUrl = "$baseUrl/uploads/";

  // ====================== AUTH ======================
  static const String login = "/users/login";
  static const String register = "/users/register";
  static const String googleAuth = "/users/google-auth";
  static const String forgotPassword = "/users/forgot-password";
  static const String resetPassword = "/users/reset-password";
  static const String userProfile = "/users/profile";
  static const String updateUserProfile = "/users/profile";
  static const String uploadProfileImage = "/users/profile/upload";
  static const String deleteProfileImage = "/users/profile/image";

  // ====================== PRODUCTS ======================
  static const String allProducts = "/products";
  static const String productById = "/products/"; // append :id
  static const String productsByCategory = "/products/category/"; // append :categoryName
  static const String adminAddProduct = "/products/admin";
  static const String adminUpdateProduct = "/products/admin/"; // append :id
  static const String adminDeleteProduct = "/products/admin/"; // append :id

  // ====================== CART ======================
  static const String cart = "/cart";
  static const String cartItem = "/cart/"; // append :itemId
  static const String clearCart = "/cart/clear";

  // ====================== WISHLIST ======================
  static const String wishlist = "/wishlist";
  static const String removeFromWishlist = "/wishlist/"; // append :productId

  // ====================== ORDERS ======================
  static const String placeOrder = "/orders/place";
  static const String myOrders = "/orders/my-orders";
  static const String getInvoice = "/orders/invoice/"; // append :orderId

  // ====================== REVIEWS ======================
  static const String reviews = "/reviews";
  static const String productReviews = "/reviews/"; // append :productId
  static const String deleteReview = "/reviews/"; // append :productId/:reviewId

  // ====================== PAYMENTS ======================
  static const String esewaSuccess = "/payments/esewa/success";
  static const String esewaFailure = "/payments/esewa/failure";
  static const String khaltiVerify = "/payments/khalti/verify";

  // ====================== ADMIN ======================
  static const String adminLogin = "/admin/login";
  static const String adminStats = "/admin/stats";
  static const String adminProducts = "/admin/products";


  static const String adminBulkCategories = "/admin/categories/bulk";
  static const String adminAddCoupon = "/admin/coupons";
  static const String adminDeleteCoupon = "/admin/coupons/"; // append :code
  static const String adminGetCoupons = "/admin/coupons";

  static const String adminOrders = "/admin/orders";
  static const String adminOrderStatus = "/admin/orders/"; // append :id/status
  static const String adminMarkOrderPaid = "/admin/orders/"; // append :id/pay

  static const String adminUsers = "/admin/users";
  static const String adminDeleteUser = "/admin/users/"; // append :id
  static const String adminUpdateUser = "/admin/users/"; // append :id

  static const String adminReviews = "/admin/reviews";

  // ====================== CATEGORIES ======================
  static const String categories = "/categories";
  static const String updateCategory = "/categories/"; // append :id
  static const String deleteCategory = "/categories/"; // append :id
  static const String bulkCategories = "/categories/bulk";

  // ====================== COUPONS ======================
  static const String coupons = "/coupons";
  static const String couponByCode = "/coupons/"; // append :code
  static const String deleteCoupon = "/coupons/"; // append :code
}
