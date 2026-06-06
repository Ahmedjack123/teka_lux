import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/services/local_storage_service.dart';
import '../../domain/usecases/search_products.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchProductsUseCase searchProducts,
    required LocalStorageService localStorage,
  })  : _searchProducts = searchProducts,
        _localStorage = localStorage,
        super(const SearchState()) {
    _loadRecentSearches();
  }

  final SearchProductsUseCase _searchProducts;
  final LocalStorageService _localStorage;

  Timer? _debounceTimer;

  static const _recentSearchesKey = 'recent_searches';
  static const _maxRecentSearches = 10;

  void _loadRecentSearches() {
    final raw = _localStorage.getString(_recentSearchesKey);
    if (raw.isNotEmpty) {
      final list = raw.split(',').where((s) => s.isNotEmpty).toList();
      emit(state.copyWith(recentSearches: list));
    }
  }

  Future<void> _saveRecentSearches() async {
    final raw = state.recentSearches.join(',');
    await _localStorage.setString(_recentSearchesKey, raw);
  }

  void search(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      emit(state.copyWith(query: '', results: const [], isLoading: false));
      return;
    }

    emit(state.copyWith(query: query, isLoading: true));

    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      final result = await _searchProducts(query.trim());

      result.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          hasSearched: true,
          results: const [],
        )),
        (products) => emit(state.copyWith(
          isLoading: false,
          hasSearched: true,
          results: products,
        )),
      );
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    emit(state.copyWith(
      query: '',
      results: const [],
      isLoading: false,
      hasSearched: false,
    ));
  }

  void addRecentSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final updated = [
      trimmed,
      ...state.recentSearches.where((s) => s != trimmed),
    ].take(_maxRecentSearches).toList();

    emit(state.copyWith(recentSearches: updated));
    _saveRecentSearches();
  }

  Future<void> clearRecentSearches() async {
    emit(state.copyWith(recentSearches: const []));
    await _localStorage.remove(_recentSearchesKey);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
