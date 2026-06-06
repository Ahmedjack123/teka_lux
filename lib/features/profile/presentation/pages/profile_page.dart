import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theming/theming.dart';
import '../../../../core/utils/device_helper.dart';
import '../../../../injection.dart';
import '../../../../shared/widgets/buttons/secondary_button.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../widgets/address_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadProfile()..loadAddresses(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: AppSizes.lg,
                    ),
                    child: _ProfileHeader(profile: state.profile),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: _SectionTitle(title: 'My Addresses'),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: _AddressesList(
                    addresses: state.addresses,
                    isLoading: state.isLoading,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.lg),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: _SectionTitle(title: 'Settings'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: _SettingsSection(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSizes.xl),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({this.profile});

  final UserProfile? profile;

  String get _initials {
    final name = profile?.name ?? '';
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.primary,
          backgroundImage:
              profile?.hasPhoto == true ? NetworkImage(profile!.photoUrl!) : null,
          child: profile?.hasPhoto != true
              ? Text(
                  _initials,
                  style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                )
              : null,
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          profile?.name ?? 'Guest',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          profile?.email ?? '',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSizes.md),
        OutlinedButton(
          onPressed: () {
            // TODO: Navigate to edit profile
          },
          style: AppButtonStyles.secondary(radius: AppSizes.radiusPill).copyWith(
            foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
            side: WidgetStateProperty.all(
              const BorderSide(color: AppColors.divider),
            ),
          ),
          child: const Text('Edit Profile'),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

class _AddressesList extends StatelessWidget {
  const _AddressesList({
    required this.addresses,
    required this.isLoading,
  });

  final List<Address> addresses;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading && addresses.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.lg),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (addresses.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
          child: Center(
            child: Text(
              'No addresses yet',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final address = addresses[index];
          return AddressCard(
            address: address,
            onDelete: () => context.read<ProfileCubit>().removeAddress(address.id),
          );
        },
        childCount: addresses.length,
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.dark_mode_outlined, color: AppColors.textBody),
          title: Text(
            'Dark Mode',
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
          trailing: Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (_) {
              // TODO: Toggle theme
            },
            activeThumbColor: AppColors.primary,
          ),
        ),
        const Divider(height: 1, color: AppColors.divider),
        const SizedBox(height: AppSizes.md),
        SecondaryButton(
          label: 'Logout',
          icon: Icons.logout,
          onPressed: () {
            // TODO: Trigger logout via auth use-case or navigate
          },
        ),
      ],
    );
  }
}
