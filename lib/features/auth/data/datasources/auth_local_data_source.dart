import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
    Future<void> updateCachedUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> hasCachedUser();
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();

  /// Persist birthDate independently so it survives logout/clearCache.
  Future<void> saveBirthDate(String userId, String birthDate);
  Future<String?> getBirthDate(String userId);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  late final Box<UserModel> _userBox;
  late final Box<String> _extraBox;
  bool _isInitialized = false;

  static const _secureOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
  );

  static const _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
    accountName: 'flutter_auth_tokens',
  );

  AuthLocalDataSourceImpl(this._secureStorage);

  Future<void> init() async {
    if (_isInitialized) return;

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    _userBox = await Hive.openBox<UserModel>('auth_user');
    _extraBox = await Hive.openBox<String>('auth_extra');
    _isInitialized = true;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await _ensureInitialized();
    await _userBox.put('current_user', user);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    await _ensureInitialized();
    return _userBox.get('current_user');
  }
@override
  Future<void> updateCachedUser(UserModel user) async {
    await _userBox.put('current_user', user); 
  }
  @override
  Future<void> clearCache() async {
    await _ensureInitialized();
    await _userBox.delete('current_user');
    await _secureStorage.delete(
      key: 'auth_token',
      aOptions: _secureOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<bool> hasCachedUser() async {
    await _ensureInitialized();
    return _userBox.containsKey('current_user');
  }

  @override
  Future<void> cacheToken(String token) async {
    await _secureStorage.write(
      key: 'auth_token',
      value: token,
      aOptions: _secureOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<String?> getCachedToken() async {
    return await _secureStorage.read(
      key: 'auth_token',
      aOptions: _secureOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<void> saveBirthDate(String userId, String birthDate) async {
    await _ensureInitialized();
    await _extraBox.put('birthDate_$userId', birthDate);
  }

  @override
  Future<String?> getBirthDate(String userId) async {
    await _ensureInitialized();
    return _extraBox.get('birthDate_$userId');
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}
