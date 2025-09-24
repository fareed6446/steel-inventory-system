import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import '../models/hive_user.dart';

class HiveService extends GetxService {
  static const String _usersBoxName = 'users';
  static const String _currentUserBoxName = 'current_user';
  static const String _settingsBoxName = 'app_settings';

  late Box<HiveUser> _usersBox;
  late Box<String> _currentUserBox;
  late Box<dynamic> _settingsBox;

  // Reactive variables
  final Rx<HiveUser?> currentUser = Rx<HiveUser?>(null);
  final RxList<HiveUser> allUsers = <HiveUser>[].obs;
  final RxBool isInitialized = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeHive();
  }

  Future<void> initializeHive() async {
    try {
      // Open boxes (adapters already registered in main.dart)
      _usersBox = await Hive.openBox<HiveUser>(_usersBoxName);
      _currentUserBox = await Hive.openBox<String>(_currentUserBoxName);
      _settingsBox = await Hive.openBox<dynamic>(_settingsBoxName);

      // Load current user
      await _loadCurrentUser();

      // Load all users
      await _loadAllUsers();

      isInitialized.value = true;
      print('Hive service initialized successfully');
      print('Current user loaded: ${currentUser.value?.email ?? 'None'}');
      print('Total users in storage: ${allUsers.length}');
    } catch (e) {
      print('Error initializing Hive service: $e');
      rethrow;
    }
  }

  // User Management Methods
  Future<void> saveUser(HiveUser user) async {
    try {
      await _usersBox.put(user.id, user);
      await _loadAllUsers();
      print('User saved: ${user.email}');
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(HiveUser user) async {
    try {
      final updatedUser = user.updateTimestamp();
      await _usersBox.put(user.id, updatedUser);
      await _loadAllUsers();

      // Update current user if it's the same user
      if (currentUser.value?.id == user.id) {
        currentUser.value = updatedUser;
      }

      print('User updated: ${user.email}');
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _usersBox.delete(userId);
      await _loadAllUsers();

      // Clear current user if it's the deleted user
      if (currentUser.value?.id == userId) {
        await clearCurrentUser();
      }

      print('User deleted: $userId');
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  HiveUser? getUserById(String userId) {
    return _usersBox.get(userId);
  }

  HiveUser? getUserByEmail(String email) {
    return allUsers.firstWhereOrNull((user) => user.email == email);
  }

  List<HiveUser> getUsersByRole(String role) {
    return allUsers
        .where((user) => user.role.toLowerCase() == role.toLowerCase())
        .toList();
  }

  List<HiveUser> getActiveUsers() {
    return allUsers.where((user) => user.isActive).toList();
  }

  // Current User Management
  Future<void> setCurrentUser(HiveUser user) async {
    try {
      print('Setting current user: ${user.email} (ID: ${user.id})');

      // Save user to users box first
      await _usersBox.put(user.id, user);
      print('User saved to users box: ${user.email}');

      // Set current user ID
      await _currentUserBox.put('current_user_id', user.id);
      print('Current user ID saved: ${user.id}');

      // Update reactive variable
      currentUser.value = user;
      print('Current user set successfully: ${user.email}');

      // Verify the save
      final savedUserId = _currentUserBox.get('current_user_id');
      final savedUser = _usersBox.get(user.id);
      print(
        'Verification - Saved user ID: $savedUserId, Saved user: ${savedUser?.email}',
      );
    } catch (e) {
      print('Error setting current user: $e');
      rethrow;
    }
  }

  Future<void> clearCurrentUser() async {
    try {
      await _currentUserBox.delete('current_user_id');
      currentUser.value = null;
      print('Current user cleared');
    } catch (e) {
      print('Error clearing current user: $e');
      rethrow;
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userId = _currentUserBox.get('current_user_id');
      print('Loading current user - User ID from box: $userId');

      if (userId != null) {
        final user = _usersBox.get(userId);
        print('User found in users box: ${user?.email ?? 'null'}');

        if (user != null) {
          currentUser.value = user;
          print('Current user loaded successfully: ${user.email}');
        } else {
          // User not found in users box, clear current user
          print('User not found in users box, clearing current user');
          await clearCurrentUser();
        }
      } else {
        print('No current user ID found in storage');
      }
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  Future<void> _loadAllUsers() async {
    try {
      allUsers.value = _usersBox.values.toList();
    } catch (e) {
      print('Error loading all users: $e');
    }
  }

  // Settings Management
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      await _settingsBox.put(key, value);
    } catch (e) {
      print('Error saving setting: $e');
      rethrow;
    }
  }

  T? getSetting<T>(String key) {
    try {
      return _settingsBox.get(key) as T?;
    } catch (e) {
      print('Error getting setting: $e');
      return null;
    }
  }

  Future<void> removeSetting(String key) async {
    try {
      await _settingsBox.delete(key);
    } catch (e) {
      print('Error removing setting: $e');
      rethrow;
    }
  }

  // User Preferences
  Future<void> updateUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    try {
      final user = getUserById(userId);
      if (user != null) {
        final updatedUser = user.copyWith(preferences: preferences);
        await updateUser(updatedUser);
      }
    } catch (e) {
      print('Error updating user preferences: $e');
      rethrow;
    }
  }

  Map<String, dynamic>? getUserPreferences(String userId) {
    final user = getUserById(userId);
    return user?.preferences;
  }

  // Statistics
  int get totalUsersCount => allUsers.length;
  int get activeUsersCount => getActiveUsers().length;
  int get adminUsersCount => getUsersByRole('admin').length;
  int get managerUsersCount => getUsersByRole('manager').length;
  int get operatorUsersCount => getUsersByRole('operator').length;

  // Search functionality
  List<HiveUser> searchUsers(String query) {
    if (query.isEmpty) return allUsers;

    final lowercaseQuery = query.toLowerCase();
    return allUsers.where((user) {
      return user.name.toLowerCase().contains(lowercaseQuery) ||
          user.email.toLowerCase().contains(lowercaseQuery) ||
          user.role.toLowerCase().contains(lowercaseQuery) ||
          (user.department?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // Debug Methods
  Future<void> debugHiveState() async {
    try {
      print('=== Hive Debug State ===');
      print('Is initialized: ${isInitialized.value}');
      print('Users box is open: ${_usersBox.isOpen}');
      print('Current user box is open: ${_currentUserBox.isOpen}');
      print('Settings box is open: ${_settingsBox.isOpen}');

      // Check current user ID
      final currentUserId = _currentUserBox.get('current_user_id');
      print('Current user ID in box: $currentUserId');

      // Check all users in box
      final allUsersInBox = _usersBox.values.toList();
      print('Users in box: ${allUsersInBox.length}');
      for (final user in allUsersInBox) {
        print('  - ${user.email} (ID: ${user.id})');
      }

      // Check reactive variables
      print('Reactive current user: ${currentUser.value?.email ?? 'None'}');
      print('Reactive all users count: ${allUsers.length}');
      print('========================');
    } catch (e) {
      print('Error in debug state: $e');
    }
  }

  // Cleanup
  Future<void> clearAllData() async {
    try {
      await _usersBox.clear();
      await _currentUserBox.clear();
      await _settingsBox.clear();
      currentUser.value = null;
      allUsers.clear();
      print('All Hive data cleared');
    } catch (e) {
      print('Error clearing all data: $e');
      rethrow;
    }
  }

  // Close boxes
  Future<void> closeBoxes() async {
    try {
      await _usersBox.close();
      await _currentUserBox.close();
      await _settingsBox.close();
      print('Hive boxes closed');
    } catch (e) {
      print('Error closing boxes: $e');
    }
  }

  @override
  void onClose() {
    closeBoxes();
    super.onClose();
  }
}
