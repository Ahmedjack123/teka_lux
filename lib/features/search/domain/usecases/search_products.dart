import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.price,
    this.category,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final double price;
  final String? category;
}

class SearchProductsUseCase extends UseCase<List<Product>, String> {
  const SearchProductsUseCase();

  static final List<Product> _mockProducts = [
    const Product(
      id: '1',
      name: 'Classic Black Tee',
      imageUrl: null,
      price: 29.99,
      category: 'Basics',
    ),
    const Product(
      id: '2',
      name: 'Premium White Tee',
      imageUrl: null,
      price: 34.99,
      category: 'Basics',
    ),
    const Product(
      id: '3',
      name: 'Oversized Fit Tee',
      imageUrl: null,
      price: 39.99,
      category: 'Trending',
    ),
    const Product(
      id: '4',
      name: 'Vintage Wash Tee',
      imageUrl: null,
      price: 44.99,
      category: 'Trending',
    ),
    const Product(
      id: '5',
      name: 'Graphic Print Tee',
      imageUrl: null,
      price: 49.99,
      category: 'Graphics',
    ),
    const Product(
      id: '6',
      name: 'Minimal Logo Tee',
      imageUrl: null,
      price: 32.99,
      category: 'Basics',
    ),
  ];

  @override
  Future<Result<List<Product>>> call(String query) async {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return const Result.success([]);
    }

    final results = _mockProducts.where((product) {
      return product.name.toLowerCase().contains(normalizedQuery) ||
          (product.category?.toLowerCase().contains(normalizedQuery) ?? false);
    }).toList();

    return Result.success(results);
  }
}
