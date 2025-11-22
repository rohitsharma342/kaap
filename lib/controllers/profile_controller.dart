import 'package:flutter/material.dart';
import '../models/child_profile.dart';
import '../utils/constants.dart';

class ProfileController extends ChangeNotifier {
  List<ChildProfile> _profiles = [];
  ChildProfile? _selectedProfile;
  bool _isLoading = false;
  
  List<ChildProfile> get profiles => _profiles;
  ChildProfile? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;
  
  ProfileController() {
    _initializeProfiles();
  }
  
  void _initializeProfiles() {
    _profiles = [
      ChildProfile(
        id: '1',
        name: 'Arjun',
        avatarUrl: AppConstants.avatarUrls[0],
        age: 8,
        isPremium: true,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        preferences: ['Educational', 'Science'],
      ),
      ChildProfile(
        id: '2',
        name: 'Priya',
        avatarUrl: AppConstants.avatarUrls[1],
        age: 6,
        isPremium: false,
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        preferences: ['Fun', 'Music'],
      ),
    ];
    notifyListeners();
  }
  
  Future<void> selectProfile(ChildProfile profile) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 500));
    _selectedProfile = profile;
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> addProfile(ChildProfile profile) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 800));
    _profiles.add(profile);
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> updateProfile(ChildProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 500));
    final index = _profiles.indexWhere((p) => p.id == updatedProfile.id);
    if (index != -1) {
      _profiles[index] = updatedProfile;
      if (_selectedProfile?.id == updatedProfile.id) {
        _selectedProfile = updatedProfile;
      }
    }
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> deleteProfile(String profileId) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 500));
    _profiles.removeWhere((p) => p.id == profileId);
    if (_selectedProfile?.id == profileId) {
      _selectedProfile = null;
    }
    _isLoading = false;
    notifyListeners();
  }
  
  ChildProfile createNewProfile({
    required String name,
    required String avatarUrl,
    required int age,
    List<String>? preferences,
  }) {
    return ChildProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      avatarUrl: avatarUrl,
      age: age,
      isPremium: false,
      createdAt: DateTime.now(),
      preferences: preferences ?? [],
    );
  }
  
  void clearSelection() {
    _selectedProfile = null;
    notifyListeners();
  }
}