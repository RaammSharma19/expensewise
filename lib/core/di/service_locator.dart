import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expensewise/core/database/database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database provider not initialized');
});

void setupServiceLocator(AppDatabase database) {
  // This will be used with Riverpod providers
  // The database is passed to Riverpod context
}
