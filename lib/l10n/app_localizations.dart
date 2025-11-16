// lib/l10n/app_localizations.dart
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'app_name': 'Money Tracker',
      'loading': 'Loading...',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'error': 'Error',
      'success': 'Success',

      // Auth
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      'register_now': 'Register Now',
      'login_now': 'Login Now',

      // Dashboard
      'dashboard': 'Dashboard',
      'welcome_back': 'Welcome Back',
      'income': 'Income',
      'expense': 'Expense',
      'balance': 'Balance',
      'recent_transactions': 'Recent Transactions',
      'view_all': 'View All',
      'no_transactions': 'No transactions yet',
      'today': 'Today',
      'week': 'Week',
      'month': 'Month',
      'all': 'All',

      // Transactions
      'add_transaction': 'Add Transaction',
      'new_transaction': 'New Transaction',
      'description': 'Description',
      'amount': 'Amount',
      'category': 'Category',
      'date': 'Date',
      'type': 'Type',
      'select_category': 'Select Category',

      // Categories
      'salary': 'Salary',
      'investment': 'Investment',
      'freelance': 'Freelance',
      'sales': 'Sales',
      'gift': 'Gift',
      'food': 'Food',
      'transport': 'Transport',
      'shopping': 'Shopping',
      'entertainment': 'Entertainment',
      'bills': 'Bills',
      'health': 'Health',
      'education': 'Education',
      'clothing': 'Clothing',
      'other': 'Other',

      // Calendar
      'calendar': 'Calendar',
      'monthly_summary': 'Monthly Summary',
      'no_events': 'No transactions on this day',

      // Charts
      'charts': 'Charts',
      'statistics': 'Statistics',
      'income_expense_distribution': 'Income/Expense Distribution',
      'expense_categories': 'Expense Categories',
      'weekly_expense_trend': 'Weekly Expense Trend',
      'trend_analysis': 'Trend Analysis',
      'category_analysis': 'Category Analysis',
      'pie_chart': 'Pie Chart',
      'insufficient_data': 'Insufficient data',
      'total': 'Total',

      // Statistics (YENİ)
      'general_info': 'General Information',
      'total_transactions': 'Total Transactions',
      'average_expenses': 'Average Expenses',
      'daily_average': 'Daily Average',
      'weekly_average': 'Weekly Average',
      'this_month_total': 'This Month Total',
      'month_comparison': 'This Month vs Last Month',
      'this_month': 'This Month',
      'last_month': 'Last Month',
      'increase': 'Increase',
      'decrease': 'Decrease',
      'biggest_transactions': 'Biggest Transactions',
      'biggest_income': 'Biggest Income',
      'biggest_expense': 'Biggest Expense',
      'top_expense_categories': 'Top Expense Categories',
      'no_category_data': 'No category data yet',
      'transactions_count': 'transactions',

      // Profile
      'profile': 'Profile',
      'profile_settings': 'Profile & Settings',
      'profile_info': 'Profile Information',
      'change_password': 'Change Password',
      'settings': 'Settings',
      'danger_zone': 'Danger Zone',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm Password',
      'update_profile': 'Update Profile',
      'notifications': 'Notifications',
      'push_notifications': 'Receive push notifications',
      'language': 'Language',
      'delete_account': 'Delete Account',
      'delete_account_warning':
      'Deleting your account is irreversible. All your data will be permanently deleted.',
      'delete_account_confirm':
      'Are you sure you want to delete your account? This cannot be undone!',
      'logout_confirm': 'Are you sure you want to logout?',

      // Messages
      'profile_updated': 'Profile updated successfully',
      'password_changed': 'Password changed successfully',
      'account_deleted': 'Account deleted successfully',
      'transaction_added': 'Transaction added successfully',
      'transaction_updated': 'Transaction updated successfully',
      'transaction_deleted': 'Transaction deleted successfully',
      'passwords_not_match': 'Passwords do not match',
      'select_category_error': 'Please select a category',
      'notifications_enabled': 'Notifications enabled',
      'notifications_disabled': 'Notifications disabled',
      'language_changed': 'Language changed',

      // Validation
      'enter_description': 'Please enter a description',
      'enter_amount': 'Please enter an amount',
      'enter_valid_amount': 'Please enter a valid amount',
      'enter_email': 'Please enter your email',
      'enter_password': 'Please enter your password',
      'enter_name': 'Please enter your name',
    },
    'tr': {
      // Common
      'app_name': 'Para Takip',
      'loading': 'Yükleniyor...',
      'save': 'Kaydet',
      'cancel': 'İptal',
      'delete': 'Sil',
      'edit': 'Düzenle',
      'confirm': 'Onayla',
      'yes': 'Evet',
      'no': 'Hayır',
      'error': 'Hata',
      'success': 'Başarılı',

      // Auth
      'login': 'Giriş Yap',
      'register': 'Kayıt Ol',
      'logout': 'Çıkış Yap',
      'email': 'E-posta',
      'password': 'Şifre',
      'name': 'Ad Soyad',
      'forgot_password': 'Şifremi Unuttum?',
      'dont_have_account': 'Hesabınız yok mu?',
      'already_have_account': 'Zaten hesabınız var mı?',
      'register_now': 'Hemen Kayıt Ol',
      'login_now': 'Giriş Yap',

      // Dashboard
      'dashboard': 'Ana Sayfa',
      'welcome_back': 'Tekrar Hoş Geldin',
      'income': 'Gelir',
      'expense': 'Gider',
      'balance': 'Bakiye',
      'recent_transactions': 'Son İşlemler',
      'view_all': 'Tümünü Gör',
      'no_transactions': 'Henüz işlem yok',
      'today': 'Bugün',
      'week': 'Hafta',
      'month': 'Ay',
      'all': 'Tümü',

      // Transactions
      'add_transaction': 'İşlem Ekle',
      'new_transaction': 'Yeni İşlem',
      'description': 'Açıklama',
      'amount': 'Tutar',
      'category': 'Kategori',
      'date': 'Tarih',
      'type': 'Tür',
      'select_category': 'Kategori Seç',

      // Categories
      'salary': 'Maaş',
      'investment': 'Yatırım',
      'freelance': 'Freelance',
      'sales': 'Satış',
      'gift': 'Hediye',
      'food': 'Yemek',
      'transport': 'Ulaşım',
      'shopping': 'Market',
      'entertainment': 'Eğlence',
      'bills': 'Faturalar',
      'health': 'Sağlık',
      'education': 'Eğitim',
      'clothing': 'Giyim',
      'other': 'Diğer',

      // Calendar
      'calendar': 'Takvim',
      'monthly_summary': 'Aylık Özet',
      'no_events': 'Bu günde işlem yok',

      // Charts
      'charts': 'Grafikler',
      'statistics': 'İstatistikler',
      'income_expense_distribution': 'Gelir/Gider Dağılımı',
      'expense_categories': 'Gider Kategorileri',
      'weekly_expense_trend': 'Haftalık Gider Trendi',
      'trend_analysis': 'Trend Analizi',
      'category_analysis': 'Kategori Analizi',
      'pie_chart': 'Pasta Grafik',
      'insufficient_data': 'Yeterli veri yok',
      'total': 'Toplam',

      // Statistics (YENİ)
      'general_info': 'Genel Bilgiler',
      'total_transactions': 'Toplam İşlem',
      'average_expenses': 'Ortalama Harcamalar',
      'daily_average': 'Günlük Ortalama',
      'weekly_average': 'Haftalık Ortalama',
      'this_month_total': 'Bu Ay Toplam',
      'month_comparison': 'Bu Ay vs Geçen Ay',
      'this_month': 'Bu Ay',
      'last_month': 'Geçen Ay',
      'increase': 'Artış',
      'decrease': 'Azalış',
      'biggest_transactions': 'En Büyük İşlemler',
      'biggest_income': 'En Büyük Gelir',
      'biggest_expense': 'En Büyük Gider',
      'top_expense_categories': 'En Çok Harcanan Kategoriler',
      'no_category_data': 'Henüz kategori verisi yok',
      'transactions_count': 'işlem',

      // Profile
      'profile': 'Profil',
      'profile_settings': 'Profil & Ayarlar',
      'profile_info': 'Profil Bilgileri',
      'change_password': 'Şifre Değiştir',
      'settings': 'Ayarlar',
      'danger_zone': 'Tehlikeli Bölge',
      'current_password': 'Mevcut Şifre',
      'new_password': 'Yeni Şifre',
      'confirm_password': 'Yeni Şifre (Tekrar)',
      'update_profile': 'Profili Güncelle',
      'notifications': 'Bildirimler',
      'push_notifications': 'Push bildirimleri al',
      'language': 'Dil',
      'delete_account': 'Hesabı Sil',
      'delete_account_warning':
      'Hesabınızı silmek geri alınamaz bir işlemdir. Tüm verileriniz kalıcı olarak silinecektir.',
      'delete_account_confirm':
      'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz!',
      'logout_confirm': 'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',

      // Messages
      'profile_updated': 'Profil başarıyla güncellendi',
      'password_changed': 'Şifre başarıyla değiştirildi',
      'account_deleted': 'Hesap başarıyla silindi',
      'transaction_added': 'İşlem başarıyla eklendi',
      'transaction_updated': 'İşlem başarıyla güncellendi',
      'transaction_deleted': 'İşlem başarıyla silindi',
      'passwords_not_match': 'Şifreler eşleşmiyor',
      'select_category_error': 'Lütfen bir kategori seçin',
      'notifications_enabled': 'Bildirimler açıldı',
      'notifications_disabled': 'Bildirimler kapatıldı',
      'language_changed': 'Dil değiştirildi',

      // Validation
      'enter_description': 'Lütfen açıklama girin',
      'enter_amount': 'Lütfen tutar girin',
      'enter_valid_amount': 'Geçerli bir tutar girin',
      'enter_email': 'Lütfen e-posta adresinizi girin',
      'enter_password': 'Lütfen şifrenizi girin',
      'enter_name': 'Lütfen adınızı girin',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }

  // Kısayol metodlar
  String get appName => translate('app_name');
  String get loading => translate('loading');
  String get save => translate('save');
  String get cancel => translate('cancel');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get confirm => translate('confirm');
  String get yes => translate('yes');
  String get no => translate('no');
  String get error => translate('error');
  String get success => translate('success');

  // Auth
  String get login => translate('login');
  String get register => translate('register');
  String get logout => translate('logout');
  String get email => translate('email');
  String get password => translate('password');
  String get name => translate('name');
  String get forgotPassword => translate('forgot_password');
  String get dontHaveAccount => translate('dont_have_account');
  String get alreadyHaveAccount => translate('already_have_account');
  String get registerNow => translate('register_now');
  String get loginNow => translate('login_now');

  // Dashboard
  String get dashboard => translate('dashboard');
  String get welcomeBack => translate('welcome_back');
  String get income => translate('income');
  String get expense => translate('expense');
  String get balance => translate('balance');
  String get recentTransactions => translate('recent_transactions');
  String get viewAll => translate('view_all');
  String get noTransactions => translate('no_transactions');
  String get today => translate('today');
  String get week => translate('week');
  String get month => translate('month');
  String get all => translate('all');

  // Transactions
  String get addTransaction => translate('add_transaction');
  String get newTransaction => translate('new_transaction');
  String get description => translate('description');
  String get amount => translate('amount');
  String get category => translate('category');
  String get date => translate('date');
  String get type => translate('type');
  String get selectCategory => translate('select_category');

  // Categories
  String get salary => translate('salary');
  String get investment => translate('investment');
  String get freelance => translate('freelance');
  String get sales => translate('sales');
  String get gift => translate('gift');
  String get food => translate('food');
  String get transport => translate('transport');
  String get shopping => translate('shopping');
  String get entertainment => translate('entertainment');
  String get bills => translate('bills');
  String get health => translate('health');
  String get education => translate('education');
  String get clothing => translate('clothing');
  String get other => translate('other');

  // Calendar
  String get calendar => translate('calendar');
  String get monthlySummary => translate('monthly_summary');
  String get noEvents => translate('no_events');

  // Charts
  String get charts => translate('charts');
  String get statistics => translate('statistics');
  String get incomeExpenseDistribution => translate('income_expense_distribution');
  String get expenseCategories => translate('expense_categories');
  String get weeklyExpenseTrend => translate('weekly_expense_trend');
  String get trendAnalysis => translate('trend_analysis');
  String get categoryAnalysis => translate('category_analysis');
  String get pieChart => translate('pie_chart');
  String get insufficientData => translate('insufficient_data');
  String get total => translate('total');

  // Statistics (YENİ GETTER METODLAR)
  String get generalInfo => translate('general_info');
  String get totalTransactions => translate('total_transactions');
  String get averageExpenses => translate('average_expenses');
  String get dailyAverage => translate('daily_average');
  String get weeklyAverage => translate('weekly_average');
  String get thisMonthTotal => translate('this_month_total');
  String get monthComparison => translate('month_comparison');
  String get thisMonth => translate('this_month');
  String get lastMonth => translate('last_month');
  String get increase => translate('increase');
  String get decrease => translate('decrease');
  String get biggestTransactions => translate('biggest_transactions');
  String get biggestIncome => translate('biggest_income');
  String get biggestExpense => translate('biggest_expense');
  String get topExpenseCategories => translate('top_expense_categories');
  String get noCategoryData => translate('no_category_data');
  String get transactionsCount => translate('transactions_count');

  // Profile
  String get profile => translate('profile');
  String get profileSettings => translate('profile_settings');
  String get profileInfo => translate('profile_info');
  String get changePassword => translate('change_password');
  String get settings => translate('settings');
  String get dangerZone => translate('danger_zone');
  String get currentPassword => translate('current_password');
  String get newPassword => translate('new_password');
  String get confirmPassword => translate('confirm_password');
  String get updateProfile => translate('update_profile');
  String get notifications => translate('notifications');
  String get pushNotifications => translate('push_notifications');
  String get language => translate('language');
  String get deleteAccount => translate('delete_account');
  String get deleteAccountWarning => translate('delete_account_warning');
  String get deleteAccountConfirm => translate('delete_account_confirm');
  String get logoutConfirm => translate('logout_confirm');

  // Messages
  String get profileUpdated => translate('profile_updated');
  String get passwordChanged => translate('password_changed');
  String get accountDeleted => translate('account_deleted');
  String get transactionAdded => translate('transaction_added');
  String get transactionUpdated => translate('transaction_updated');
  String get transactionDeleted => translate('transaction_deleted');
  String get passwordsNotMatch => translate('passwords_not_match');
  String get selectCategoryError => translate('select_category_error');
  String get notificationsEnabled => translate('notifications_enabled');
  String get notificationsDisabled => translate('notifications_disabled');
  String get languageChanged => translate('language_changed');

  // Validation
  String get enterDescription => translate('enter_description');
  String get enterAmount => translate('enter_amount');
  String get enterValidAmount => translate('enter_valid_amount');
  String get enterEmail => translate('enter_email');
  String get enterPassword => translate('enter_password');
  String get enterName => translate('enter_name');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}