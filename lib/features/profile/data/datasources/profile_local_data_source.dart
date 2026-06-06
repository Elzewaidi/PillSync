import 'package:hive_ce/hive.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheProfile(ProfileModel profile);
  Future<ProfileModel?> getCachedProfile();
  Future<void> clearCache();
  Future<bool> hasCachedProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  late final Box<ProfileModel> _profileBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProfileModelAdapter());
    }

    _profileBox = await Hive.openBox<ProfileModel>('profile');
    _isInitialized = true;
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    await _ensureInitialized();
    await _profileBox.put('current_profile', profile);
  }

  @override
  Future<ProfileModel?> getCachedProfile() async {
    await _ensureInitialized();
    return _profileBox.get('current_profile');
  }

  @override
  Future<void> clearCache() async {
    await _ensureInitialized();
    await _profileBox.delete('current_profile');
  }

  @override
  Future<bool> hasCachedProfile() async {
    await _ensureInitialized();
    return _profileBox.containsKey('current_profile');
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}
