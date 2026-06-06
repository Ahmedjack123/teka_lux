import '../../domain/usecases/search_products.dart';

const _unset = Object();

class SearchState {
  const SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.hasSearched = false,
    this.recentSearches = const [],
  });

  final String query;
  final List<Product> results;
  final bool isLoading;
  final bool hasSearched;
  final List<String> recentSearches;

  SearchState copyWith({
    Object? query = _unset,
    Object? results = _unset,
    Object? isLoading = _unset,
    Object? hasSearched = _unset,
    Object? recentSearches = _unset,
  }) {
    return SearchState(
      query: query == _unset ? this.query : query as String,
      results: results == _unset ? this.results : results as List<Product>,
      isLoading: isLoading == _unset ? this.isLoading : isLoading as bool,
      hasSearched:
          hasSearched == _unset ? this.hasSearched : hasSearched as bool,
      recentSearches: recentSearches == _unset
          ? this.recentSearches
          : recentSearches as List<String>,
    );
  }
}
