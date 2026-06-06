import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/theming.dart';
import '../../../../injection.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../../../shared/widgets/animations/animated_favorite_button.dart';
import '../../../../shared/widgets/animations/hero_image.dart';
import '../../../../shared/widgets/animations/shimmer_loader.dart';
import '../../../../shared/widgets/forms/app_text_field.dart';
import '../../domain/usecases/search_products.dart';
import '../bloc/search_cubit.dart';
import '../bloc/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(
        searchProducts: const SearchProductsUseCase(),
        localStorage: sl<LocalStorageService>(),
      ),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    context.read<SearchCubit>().search(value);
  }

  void _onSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      context.read<SearchCubit>().addRecentSearch(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          children: [
            BlocBuilder<SearchCubit, SearchState>(
              buildWhen: (previous, current) => previous.query != current.query,
              builder: (context, state) {
                return AppTextField(
                  controller: _controller,
                  hint: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: state.query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            context.read<SearchCubit>().clearSearch();
                          },
                        )
                      : null,
                  onChanged: _onSearch,
                  onSubmitted: _onSubmitted,
                  textInputAction: TextInputAction.search,
                );
              },
            ),
            const SizedBox(height: AppSizes.md),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return _buildShimmerGrid();
                  }

                  if (state.query.isEmpty) {
                    return _buildRecentSearches(context, state);
                  }

                  if (state.hasSearched && state.results.isEmpty) {
                    return const _EmptyState(
                      icon: Icons.search_off,
                      message: 'No products found',
                    );
                  }

                  if (state.results.isNotEmpty) {
                    return _buildResultsGrid(state.results);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches(BuildContext context, SearchState state) {
    if (state.recentSearches.isEmpty) {
      return const _EmptyState(
        icon: Icons.history,
        message: 'No recent searches',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
            ),
            TextButton(
              onPressed: () {
                context.read<SearchCubit>().clearRecentSearches();
              },
              child: const Text('Clear'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: state.recentSearches.map((query) {
            return ActionChip(
              label: Text(query),
              onPressed: () {
                _controller.text = query;
                _controller.selection = TextSelection.collapsed(
                  offset: query.length,
                );
                _onSearch(query);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResultsGrid(List<Product> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.md,
        crossAxisSpacing: AppSizes.md,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(product: product);
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.md,
        crossAxisSpacing: AppSizes.md,
        childAspectRatio: 0.75,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return ShimmerLoader(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusMd),
              ),
              child: HeroImage(
                tag: 'product-${product.id}',
                imageUrl: product.imageUrl,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.xxs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: AppTextStyles.priceLg,
                    ),
                    AnimatedFavoriteButton(
                      isFavorite: false,
                      onToggle: () {},
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: AppSizes.md),
          Text(
            message,
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
