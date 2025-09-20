class SupabaseConfig {
  static const String url = 'https://aakecfoesogyokxqaroo.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFha2VjZm9lc29neW9reHFhcm9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwNzUwMTEsImV4cCI6MjA3MzY1MTAxMX0.2PsfBo_-hoh9uCBDeulgvRADhPdxrJHt_bwTXcqbmuM';

  // Database table names
  static const String usersTable = 'users';
  static const String productsTable = 'products';
  static const String purchasesTable = 'purchases';
  static const String salesTable = 'sales';
  static const String stockTable = 'stock';
  static const String stockMovementsTable = 'stock_movements';

  // Storage bucket names
  static const String documentsBucket = 'documents';
  static const String imagesBucket = 'images';
}
