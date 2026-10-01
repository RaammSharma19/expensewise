class AppConstants {
  // App Info
  static const String appName = 'ExpenseWise';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'expensewise.db';
  static const int databaseVersion = 1;
  
  // Currency
  static const String defaultCurrency = '₹';
  static const String defaultCurrencyCode = 'INR';
  
  // Validation
  static const double minAmount = 0.01;
  static const int maxDescriptionLength = 500;
  static const int maxNotesLength = 1000;
  
  // Budget
  static const int defaultBudgetWarningPercentage = 80;
  
  // Credit Card
  static const int creditCardDigitsToShow = 4;
  static const int maxCreditCardNameLength = 50;
  
  // Pagination
  static const int defaultPageSize = 50;
  static const int maxPageSize = 100;
  
  // Security
  static const int pinLength = 4;
  static const Duration autoLockDuration = Duration(minutes: 5);
  
  // Notifications
  static const int notificationChannelId = 1;
  static const String notificationChannelName = 'ExpenseWise Notifications';
  static const String notificationChannelDescription = 'Budget alerts and reminders';
}
