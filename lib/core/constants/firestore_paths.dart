/// Centralized Firestore collection names.
/// Keeping these as constants avoids typo bugs across repositories.
class FirestorePaths {
  FirestorePaths._();

  static const String customers = 'customers';
  static const String products = 'products';
  static const String transactions = 'transactions';
  static const String expenses = 'expenses';
  static const String dailyReports = 'daily_reports';
}
