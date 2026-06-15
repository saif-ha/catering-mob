class AppConstants {
  AppConstants._();

  static const String appName = 'Platter Catering';
  static const String appTagline = 'Premium Corporate Catering & Meal Prep';

  // Auth
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';

  // Roles
  static const String roleClient = 'client';
  static const String roleCompany = 'company';
  static const String roleAdmin = 'admin';

  // Company Status
  static const String companyPending = 'pending';
  static const String companyApproved = 'approved';
  static const String companyRejected = 'rejected';
  static const String companySuspended = 'suspended';

  // Order Statuses
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderPreparing = 'preparing';
  static const String orderReady = 'ready';
  static const String orderOutForDelivery = 'out_for_delivery';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';

  // Group Order Statuses
  static const String groupOrderDraft = 'draft';
  static const String groupOrderOpen = 'open';
  static const String groupOrderClosed = 'closed';
  static const String groupOrderWaitingPayment = 'waiting_payment';
  static const String groupOrderConfirmed = 'confirmed';
  static const String groupOrderPreparing = 'preparing';
  static const String groupOrderOutForDelivery = 'out_for_delivery';
  static const String groupOrderDelivered = 'delivered';
  static const String groupOrderCancelled = 'cancelled';

  // Catering Request Statuses
  static const String cateringPending = 'pending';
  static const String cateringQuoted = 'quoted';
  static const String cateringAccepted = 'accepted';
  static const String cateringRejected = 'rejected';
  static const String cateringConfirmed = 'confirmed';
  static const String cateringInPreparation = 'in_preparation';
  static const String cateringDelivered = 'delivered';
  static const String cateringCompleted = 'completed';
  static const String cateringCancelled = 'cancelled';

  // Meal Prep Statuses
  static const String mealPrepDraft = 'draft';
  static const String mealPrepActive = 'active';
  static const String mealPrepPaused = 'paused';
  static const String mealPrepCancelled = 'cancelled';
  static const String mealPrepCompleted = 'completed';

  // Invoice Statuses
  static const String invoicePending = 'pending';
  static const String invoicePaid = 'paid';
  static const String invoiceOverdue = 'overdue';
  static const String invoiceCancelled = 'cancelled';

  // Dietary Tags
  static const List<String> dietaryTags = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'High Protein',
    'Low Carb',
    'Healthy',
    'Spicy',
    'Halal',
  ];

  // Service Types
  static const List<String> serviceTypes = [
    'Delivery Only',
    'Delivery + Setup',
    'Full-Service Catering',
    'Buffet',
    'Coffee Break',
    'Business Lunch',
    'Custom Corporate Event',
  ];

  // Event Types
  static const List<String> eventTypes = [
    'Corporate Meeting',
    'Team Lunch',
    'Training Day',
    'Conference',
    'Company Event',
    'Client Entertainment',
    'Product Launch',
    'Annual Celebration',
    'Holiday Party',
    'Board Meeting',
  ];

  // Budget Ranges
  static const List<String> budgetRanges = [
    'Under \$500',
    '\$500 – \$1,000',
    '\$1,000 – \$2,500',
    '\$2,500 – \$5,000',
    '\$5,000 – \$10,000',
    'Over \$10,000',
    'To be discussed',
  ];

  // Guest Count Options
  static const List<String> guestRanges = [
    '1–10',
    '11–25',
    '26–50',
    '51–100',
    '101–200',
    '200+',
  ];

  // Allergens
  static const List<String> allergens = [
    'Nuts',
    'Dairy',
    'Gluten',
    'Eggs',
    'Soy',
    'Shellfish',
    'Fish',
    'Sesame',
  ];
}
