import 'package:drift/drift.dart';

// User Settings Table
@DataClassName('UserSettings')
class UserSettingsTable extends Table {
  IntColumn get id => integer().primary();
  TextColumn get currency => text().withDefault(const Constant('₹'));
  TextColumn get currencyCode => text().withDefault(const Constant('INR'));
  TextColumn get dateFormat => text().withDefault(const Constant('dd/MM/yyyy'));
  TextColumn get theme => text().withDefault(const Constant('system'));
  TextColumn get language => text().withDefault(const Constant('en'));
  IntColumn get firstDayOfWeek => integer().withDefault(const Constant(1));
  BoolColumn get enableBiometric => boolean().withDefault(const Constant(false));
  BoolColumn get enablePin => boolean().withDefault(const Constant(false));
  IntColumn get autoLockDuration => integer().withDefault(const Constant(5));
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// Category Table
@DataClassName('Category')
class CategoryTable extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get name => text().unique();
  TextColumn get icon => text();
  IntColumn get color => integer();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false));
  BoolColumn get isActive => boolean().withDefault(const Constant(true));
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// Payment Method Table
@DataClassName('PaymentMethod')
class PaymentMethodTable extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get name => text().unique();
  TextColumn get icon => text();
  BoolColumn get isActive => boolean().withDefault(const Constant(true));
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// Transaction Table
@DataClassName('Transaction')
class TransactionTable extends Table {
  IntColumn get id => integer().autoIncrement();
  RealColumn get amount => real();
  IntColumn get categoryId => integer().references(CategoryTable, #id);
  IntColumn get paymentMethodId => integer().references(PaymentMethodTable, #id);
  TextColumn get description => text().nullable();
  TextColumn get merchant => text().nullable();
  TextColumn get notes => text().nullable();
  DateTimeColumn get transactionDate => dateTime();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false));
  IntColumn get receiptId => integer().nullable().references(ReceiptTable, #id);
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (categoryId) REFERENCES category(id) ON DELETE RESTRICT',
    'FOREIGN KEY (paymentMethodId) REFERENCES payment_method(id) ON DELETE RESTRICT',
  ];
}

// Budget Table
@DataClassName('Budget')
class BudgetTable extends Table {
  IntColumn get id => integer().autoIncrement();
  IntColumn get categoryId => integer().nullable().references(CategoryTable, #id);
  RealColumn get amount => real();
  DateTimeColumn get startDate => dateTime();
  DateTimeColumn get endDate => dateTime();
  IntColumn get warningPercentage => integer().withDefault(const Constant(80));
  BoolColumn get isActive => boolean().withDefault(const Constant(true));
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// Recurring Transaction Table
@DataClassName('RecurringTransaction')
class RecurringTransactionTable extends Table {
  IntColumn get id => integer().autoIncrement();
  RealColumn get amount => real();
  IntColumn get categoryId => integer().references(CategoryTable, #id);
  IntColumn get paymentMethodId => integer().references(PaymentMethodTable, #id);
  TextColumn get description => text().nullable();
  TextColumn get merchant => text().nullable();
  DateTimeColumn get startDate => dateTime();
  DateTimeColumn get endDate => dateTime().nullable();
  TextColumn get frequency => text(); // daily, weekly, monthly, quarterly, half-yearly, yearly
  BoolColumn get isIncome => boolean().withDefault(const Constant(false));
  BoolColumn get isActive => boolean().withDefault(const Constant(true));
  IntColumn get reminderDays => integer().withDefault(const Constant(1));
  DateTimeColumn get lastGeneratedDate => dateTime().nullable();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// Credit Card Table
@DataClassName('CreditCard')
class CreditCardTable extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get cardName => text();
  TextColumn get bank => text();
  TextColumn get lastFourDigits => text();
  RealColumn get creditLimit => real();
  RealColumn get currentOutstanding => real().withDefault(const Constant(0));
  IntColumn get billingCycleDate => integer();
  IntColumn get paymentDueDate => integer();
  IntColumn get cardColor => integer();
  TextColumn get cardIcon => text();
  BoolColumn get isActive => boolean().withDefault(const Constant(true));
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// Credit Card Transaction Mapping
@DataClassName('CreditCardTransactionMapping')
class CreditCardTransactionMappingTable extends Table {
  IntColumn get id => integer().autoIncrement();
  IntColumn get transactionId => integer().references(TransactionTable, #id);
  IntColumn get creditCardId => integer().references(CreditCardTable, #id);
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  
  @override
  List<String> get customConstraints => [
    'UNIQUE(transactionId, creditCardId)',
  ];
}

// EMI Table
@DataClassName('EMI')
class EMITable extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get emiName => text();
  TextColumn get provider => text();
  RealColumn get principalAmount => real();
  RealColumn get rateOfInterest => real();
  IntColumn get tenure => integer(); // in months
  RealColumn get emiAmount => real();
  RealColumn get processingFee => real().withDefault(const Constant(0));
  DateTimeColumn get startDate => dateTime();
  DateTimeColumn get endDate => dateTime();
  IntColumn get paymentDate => integer();
  TextColumn get type => text(); // personal_loan, home_loan, car_loan, consumer_emi, credit_card_emi, other
  TextColumn get notes => text().nullable();
  BoolColumn get isActive => boolean().withDefault(const Constant(true));
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// EMI Installment Table
@DataClassName('EMIInstallment')
class EMIInstallmentTable extends Table {
  IntColumn get id => integer().autoIncrement();
  IntColumn get emiId => integer().references(EMITable, #id);
  IntColumn get installmentNumber => integer();
  RealColumn get principalAmount => real();
  RealColumn get interestAmount => real();
  RealColumn get totalAmount => real();
  DateTimeColumn get dueDate => dateTime();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false));
  DateTimeColumn get paidDate => dateTime().nullable();
  IntColumn get transactionId => integer().nullable().references(TransactionTable, #id);
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// Receipt Table
@DataClassName('Receipt')
class ReceiptTable extends Table {
  IntColumn get id => integer().autoIncrement();
  IntColumn get transactionId => integer().nullable().references(TransactionTable, #id);
  TextColumn get imagePath => text();
  RealColumn get fileSize => real().nullable();
  DateTimeColumn get uploadedAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}

// Tag Table
@DataClassName('Tag')
class TagTable extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get name => text().unique();
  TextColumn get color => text();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
}

// Transaction Tag Mapping
@DataClassName('TransactionTag')
class TransactionTagTable extends Table {
  IntColumn get id => integer().autoIncrement();
  IntColumn get transactionId => integer().references(TransactionTable, #id);
  IntColumn get tagId => integer().references(TagTable, #id);
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  
  @override
  List<String> get customConstraints => [
    'UNIQUE(transactionId, tagId)',
  ];
}

// Notification Settings Table
@DataClassName('NotificationSetting')
class NotificationSettingTable extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get notificationType => text().unique(); // budget_alert, emi_reminder, etc
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true));
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime);
}
