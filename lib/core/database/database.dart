import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:expensewise/core/database/tables/tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  UserSettingsTable,
  CategoryTable,
  PaymentMethodTable,
  TransactionTable,
  BudgetTable,
  RecurringTransactionTable,
  CreditCardTable,
  CreditCardTransactionMappingTable,
  EMITable,
  EMIInstallmentTable,
  ReceiptTable,
  TagTable,
  TransactionTagTable,
  NotificationSettingTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here
      },
    );
  }

  Future<void> initialize() async {
    // Initialize default data
    await _initializeDefaults();
  }

  Future<void> _initializeDefaults() async {
    // Check if defaults already exist
    final existingSettings = await select(userSettingsTable).getSingleOrNull();
    if (existingSettings != null) return;

    // Create default settings
    await into(userSettingsTable).insert(
      const UserSettingsTableCompanion(
        id: Value(1),
        currency: Value('₹'),
        currencyCode: Value('INR'),
        dateFormat: Value('dd/MM/yyyy'),
        theme: Value('system'),
        language: Value('en'),
        firstDayOfWeek: Value(1),
        enableBiometric: Value(false),
        enablePin: Value(false),
        autoLockDuration: Value(5),
      ),
    );

    // Create default categories
    await _createDefaultCategories();
    await _createDefaultPaymentMethods();
  }

  Future<void> _createDefaultCategories() async {
    final expenseCategories = [
      ('Food', '🍔', 0xFFFF6B6B),
      ('Groceries', '🛒', 0xFF4ECDC4),
      ('Rent', '🏠', 0xFF45B7D1),
      ('Utilities', '💡', 0xFFFFA07A),
      ('Transport', '🚗', 0xFF98D8C8),
      ('Fuel', '⛽', 0xFFF7DC6F),
      ('Shopping', '👕', 0xFFBB8FCE),
      ('Entertainment', '🎬', 0xFF85C1E2),
      ('Medical', '⚕️', 0xFFFF6B9D),
      ('Travel', '✈️', 0xFFC7ECEE),
      ('Education', '📚', 0xFFA9DFBF'),
      ('Subscriptions', '📱', 0xFFF8B88B'),
      ('Personal Care', '💅', 0xFFD7BDE2'),
      ('Insurance', '🛡️', 0xFFAED6F1'),
      ('Bills', '📄', 0xFFFAD7A0'),
      ('Other', '📌', 0xFFD5D8DC'),
    ];

    for (final (name, emoji, color) in expenseCategories) {
      await into(categoryTable).insert(
        CategoryTableCompanion(
          name: Value(name),
          icon: Value(emoji),
          color: Value(color),
          isIncome: Value(false),
          isActive: Value(true),
        ),
      );
    }

    final incomeCategories = [
      ('Salary', '💼', 0xFF52BE80),
      ('Bonus', '🎁', 0xFF16A085),
      ('Freelance', '💻', 0xFF1ABC9C),
      ('Business', '🏢', 0xFF117864'),
      ('Interest', '📈', 0xFF0E6251'),
      ('Refund', '💰', 0xFF58D68D'),
      ('Other', '📌', 0xFF95A5A6),
    ];

    for (final (name, emoji, color) in incomeCategories) {
      await into(categoryTable).insert(
        CategoryTableCompanion(
          name: Value(name),
          icon: Value(emoji),
          color: Value(color),
          isIncome: Value(true),
          isActive: Value(true),
        ),
      );
    }
  }

  Future<void> _createDefaultPaymentMethods() async {
    final methods = [
      ('Cash', '💵'),
      ('UPI', '📱'),
      ('Debit Card', '💳'),
      ('Credit Card', '💳'),
      ('Bank Transfer', '🏦'),
      ('Wallet', '👛'),
      ('Other', '📌'),
    ];

    for (final (name, icon) in methods) {
      await into(paymentMethodTable).insert(
        PaymentMethodTableCompanion(
          name: Value(name),
          icon: Value(icon),
          isActive: Value(true),
        ),
      );
    }
  }

  // Clear all data (for testing)
  Future<void> clearAllTables() async {
    await delete(transactionTable).go();
    await delete(budgetTable).go();
    await delete(recurringTransactionTable).go();
    await delete(creditCardTable).go();
    await delete(emiTable).go();
    await delete(receiptTable).go();
    await delete(tagTable).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'expensewise.db'));
    return NativeDatabase(file);
  });
}
