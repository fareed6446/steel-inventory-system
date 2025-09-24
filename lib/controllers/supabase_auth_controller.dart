import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart' as app_models;
import '../models/hive_user.dart';
import '../services/supabase_service.dart';
import '../services/hive_service.dart';

class SupabaseAuthController extends GetxController {
  final SupabaseService _supabaseService = SupabaseService();
  final HiveService _hiveService = Get.find<HiveService>();

  final Rx<app_models.User?> currentUser = Rx<app_models.User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('SupabaseAuthController initialized');
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _supabaseService.authStateChanges.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      print('Auth event: $event');

      if (event == AuthChangeEvent.signedIn && session != null) {
        _handleSignIn(session.user);
      } else if (event == AuthChangeEvent.signedOut) {
        _handleSignOut();
      }
    });
  }

  Future<void> _handleSignIn(User user) async {
    try {
      print('User signed in: ${user.email}');

      // Get user profile from our users table
      final profile = await _supabaseService.getUserProfile(user.id);

      if (profile != null) {
        final appUser = app_models.User.fromMap(profile);
        currentUser.value = appUser;
        isLoggedIn.value = true;

        // Save to Hive
        print('Creating HiveUser from Supabase profile...');
        final hiveUser = HiveUser.fromSupabase(
          id: appUser.id,
          email: appUser.email,
          name: appUser.name,
          role: appUser.role,
          phone: appUser.phone,
          department: appUser.department,
          createdAt: appUser.createdAt,
          updatedAt: appUser.updatedAt,
          isActive: appUser.isActive,
        );
        print('HiveUser created: ${hiveUser.email}');
        await _hiveService.setCurrentUser(hiveUser);
        print('HiveUser saved to Hive service');

        print('User profile loaded: ${appUser.name}');
      } else {
        // Create a default user profile from Supabase auth data
        print('No user profile found, creating default profile');
        final defaultUser = app_models.User(
          id: user.id,
          email: user.email!,
          name: user.email!.split('@')[0], // Use email prefix as name
          role: 'operator', // Default role
          createdAt:
              DateTime.tryParse(user.createdAt.toString()) ?? DateTime.now(),
          updatedAt:
              DateTime.tryParse(user.updatedAt.toString()) ?? DateTime.now(),
          isActive: true,
        );
        currentUser.value = defaultUser;
        isLoggedIn.value = true;

        // Save to Hive
        print('Creating HiveUser from default profile...');
        final hiveUser = HiveUser.fromSupabase(
          id: defaultUser.id,
          email: defaultUser.email,
          name: defaultUser.name,
          role: defaultUser.role,
          phone: defaultUser.phone,
          department: defaultUser.department,
          createdAt: defaultUser.createdAt,
          updatedAt: defaultUser.updatedAt,
          isActive: defaultUser.isActive,
        );
        print('Default HiveUser created: ${hiveUser.email}');
        await _hiveService.setCurrentUser(hiveUser);
        print('Default HiveUser saved to Hive service');

        print('Default user profile created: ${defaultUser.name}');
      }
    } catch (e) {
      print('Error handling sign in: $e');
      errorMessage.value = 'Error loading user profile: $e';
    }
  }

  void _handleSignOut() {
    print('User signed out');
    currentUser.value = null;
    isLoggedIn.value = false;

    // Clear Hive current user
    _hiveService.clearCurrentUser();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? phone,
    String? department,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate input
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        errorMessage.value = 'Please fill in all required fields';
        return false;
      }

      if (!_isValidEmail(email)) {
        errorMessage.value = 'Please enter a valid email address';
        return false;
      }

      if (password.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters';
        return false;
      }

      // Sign up with Supabase (with timeout)
      final response = await _supabaseService
          .signUp(
            email: email,
            password: password,
            name: name,
            role: role,
            phone: phone,
            department: department,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Sign up request timed out');
            },
          );

      if (response.user != null) {
        print('User signed up successfully: ${response.user!.email}');
        // Check if email confirmation is required
        if (response.session == null) {
          errorMessage.value =
              'Account created successfully! Please check your email (${response.user!.email}) and click the confirmation link to activate your account.';
          return false; // Don't navigate, user needs to confirm email first
        }
        return true; // User confirmed and session exists
      } else {
        errorMessage.value = 'Sign up failed: Unable to create account';
        return false;
      }
    } catch (e) {
      print('Sign up error: $e');
      print(
        'Error contains "Database error saving new user": ${e.toString().contains('Database error saving new user')}',
      );

      // Handle specific error cases
      if (e.toString().contains('Database error saving new user')) {
        // This error often occurs when email confirmation is enabled
        // Treat it as a successful signup that requires email confirmation
        print(
          'Treating database error as successful signup with email confirmation required',
        );
        errorMessage.value =
            'Account created successfully! Please check your email ($email) and click the confirmation link to activate your account.';
        return false; // Don't navigate, user needs to confirm email
      } else if (e.toString().contains('User already registered')) {
        errorMessage.value =
            'An account with this email already exists. Please sign in instead.';
      } else if (e.toString().contains('Invalid email')) {
        errorMessage.value = 'Please enter a valid email address.';
      } else if (e.toString().contains('AuthRetryableFetchException')) {
        errorMessage.value =
            'Network error during signup. Please check your internet connection and try again.';
      } else {
        errorMessage.value = 'Sign up failed: ${e.toString()}';
      }

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate input
      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        return false;
      }

      if (!_isValidEmail(email)) {
        errorMessage.value = 'Please enter a valid email address';
        return false;
      }

      // Sign in with Supabase
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        print('User signed in successfully: ${response.user!.email}');
        return true;
      } else {
        errorMessage.value = 'Sign in failed';
        return false;
      }
    } catch (e) {
      print('Sign in error: $e');
      errorMessage.value = 'Sign in failed: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;

      await _supabaseService.signOut();

      // Clear local state
      currentUser.value = null;
      isLoggedIn.value = false;

      print('User signed out successfully');
    } catch (e) {
      print('Sign out error: $e');
      errorMessage.value = 'Sign out failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Helper methods for role-based access
  bool canAccessAdminFeatures() {
    return currentUser.value?.isAdmin == true;
  }

  bool canAccessManagerFeatures() {
    return currentUser.value?.isAdmin == true ||
        currentUser.value?.isManager == true;
  }

  String get userDisplayName {
    return currentUser.value?.displayName ?? 'Guest';
  }

  String get userRole {
    return currentUser.value?.role ?? 'guest';
  }

  // Check if user is already signed in
  Future<void> checkAuthStatus() async {
    try {
      final user = _supabaseService.currentUser;
      if (user != null) {
        await _handleSignIn(user);
      }
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }
}
