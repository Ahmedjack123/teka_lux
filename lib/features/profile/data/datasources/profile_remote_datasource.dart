import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/errors/auth_error_code.dart';
import '../../../../core/errors/exceptions.dart' as app;
import '../../../../core/errors/supabase_exceptions.dart';

abstract interface class ProfileRemoteDatasource {
  Future<Map<String, dynamic>?> getProfile();
  Future<void> updateProfile(String uid, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getAddresses(String uid);
  Future<void> saveAddress(String uid, Map<String, dynamic> data);
  Future<void> deleteAddress(String addressId);
}

final class SupabaseProfileRemoteDatasource implements ProfileRemoteDatasource {
  SupabaseProfileRemoteDatasource({
    required FirebaseAuth firebaseAuth,
    required sb.SupabaseClient? supabaseClient,
  })  : _firebaseAuth = firebaseAuth,
        _supabaseClient = supabaseClient;

  final FirebaseAuth _firebaseAuth;
  final sb.SupabaseClient? _supabaseClient;

  String? get _currentUid => _firebaseAuth.currentUser?.uid;

  @override
  Future<Map<String, dynamic>?> getProfile() async {
    final uid = _currentUid;
    if (uid == null) return null;

    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', uid)
          .maybeSingle();

      return response;
    } on sb.PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _supabase.from('users').upsert({
        ...data,
        'id': uid,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'id');
    } on sb.PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAddresses(String uid) async {
    try {
      final response =
          await _supabase.from('addresses').select().eq('user_id', uid);
      return List<Map<String, dynamic>>.from(response);
    } on sb.PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<void> saveAddress(String uid, Map<String, dynamic> data) async {
    try {
      await _supabase.from('addresses').upsert({
        ...data,
        'user_id': uid,
      }, onConflict: 'id');
    } on sb.PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      await _supabase.from('addresses').delete().eq('id', addressId);
    } on sb.PostgrestException catch (exception, stackTrace) {
      throw SupabaseExceptionMapper.toAuthException(exception, stackTrace);
    }
  }

  sb.SupabaseClient get _supabase {
    final client = _supabaseClient;
    if (client == null) {
      throw const app.AuthException(
        errorCode: AuthErrorCode.profileSyncUnavailable,
        firebaseCode: 'profile-sync-unavailable',
        debugMessage:
            'Supabase is not configured. Provide SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }
    return client;
  }
}
