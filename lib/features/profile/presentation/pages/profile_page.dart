import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theming/noir_account_hub_theme.dart';
import '../../../../core/utils/device_helper.dart';
import '../../../../injection.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../widgets/noir_account_hub_menu_tile.dart';
import '../widgets/noir_bottom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadProfile(),
      child: const _NoirAccountHubView(),
    );
  }
}

class _NoirAccountHubView extends StatelessWidget {
  const _NoirAccountHubView();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = DeviceHelper.horizontalPadding(context);

    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.signOutStatus != current.signOutStatus,
      listener: (context, state) {
        if (state.signOutStatus == ProfileSignOutStatus.signedOut) {
          context.goNamed(RouteNames.login);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: NoirAccountHubTheme.background,
          appBar: _NoirAppBar(),
          bottomNavigationBar: NoirBottomNavBar(
            currentIndex: 3,
            onTap: (index) => _onBottomNavTap(context, index),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  _ProfileHeader(profile: state.profile),
                  const SizedBox(height: 32),
                  _NavigationMenu(
                    onOrders: () => context.pushNamed(RouteNames.orders),
                    onWishlist: () => _showComingSoon(context, 'Wishlist'),
                    onAddresses: () => context.pushNamed(RouteNames.addresses),
                    onNotifications: () =>
                        _showComingSoon(context, 'Notifications'),
                    onSettings: () => _showComingSoon(context, 'Settings'),
                  ),
                  const SizedBox(height: 32),
                  _LogoutButton(
                    isLoading: state.isSigningOut,
                    onPressed: state.isSigningOut
                        ? null
                        : context.read<ProfileCubit>().signOut,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onBottomNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(RouteNames.home);
      case 1:
        context.pushNamed(RouteNames.search);
      case 2:
        _showComingSoon(context, 'Wishlist');
      case 3:
      // Already on profile.
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }
}

class _NoirAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: NoirAccountHubTheme.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back,
            color: NoirAccountHubTheme.onBackground),
      ),
      title: Text(
        'NOIR',
        style: NoirAccountHubTheme.anton(
          fontSize: 28,
          color: NoirAccountHubTheme.onBackground,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.shopping_bag_outlined,
            color: NoirAccountHubTheme.onBackground,
          ),
          tooltip: 'Cart',
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: NoirAccountHubTheme.divider,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({this.profile});

  final UserProfile? profile;

  String get _initials {
    final name = profile?.name ?? '';
    if (name.trim().isEmpty) return 'AM';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  String get _displayName {
    final name = profile?.name.trim();
    if (name == null || name.isEmpty) return 'ALEX MERCER';
    return name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    const avatarSize = 140.0;
    const badgeSize = 36.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: avatarSize,
            height: avatarSize,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: NoirAccountHubTheme.surface,
                    border: Border.all(
                      color: NoirAccountHubTheme.onBackground,
                      width: 2,
                    ),
                  ),
                  child: profile?.hasPhoto == true
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0,
                            0,
                            0,
                            1,
                            0,
                          ]),
                          child: Image.network(
                            profile!.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _FallbackInitials(initials: _initials),
                          ),
                        )
                      : _FallbackInitials(initials: _initials),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    width: badgeSize,
                    height: badgeSize,
                    decoration: BoxDecoration(
                      color: NoirAccountHubTheme.accent,
                      border: Border.all(
                        color: NoirAccountHubTheme.onBackground,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: NoirAccountHubTheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _displayName,
          textAlign: TextAlign.center,
          style: NoirAccountHubTheme.anton(
            fontSize: 36,
            color: NoirAccountHubTheme.onBackground,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _FallbackInitials extends StatelessWidget {
  const _FallbackInitials({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: NoirAccountHubTheme.anton(
          fontSize: 48,
          color: NoirAccountHubTheme.onBackground,
        ),
      ),
    );
  }
}

class _NavigationMenu extends StatelessWidget {
  const _NavigationMenu({
    required this.onOrders,
    required this.onWishlist,
    required this.onAddresses,
    required this.onNotifications,
    required this.onSettings,
  });

  final VoidCallback onOrders;
  final VoidCallback onWishlist;
  final VoidCallback onAddresses;
  final VoidCallback onNotifications;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NoirAccountHubMenuTile(
          icon: Icons.inventory_2_outlined,
          label: 'My Orders',
          onTap: onOrders,
        ),
        const SizedBox(height: 12),
        NoirAccountHubMenuTile(
          icon: Icons.favorite_border,
          label: 'Wishlist',
          onTap: onWishlist,
        ),
        const SizedBox(height: 12),
        NoirAccountHubMenuTile(
          icon: Icons.location_on_outlined,
          label: 'Addresses',
          onTap: onAddresses,
        ),
        const SizedBox(height: 12),
        NoirAccountHubMenuTile(
          icon: Icons.notifications_none,
          label: 'Notifications',
          onTap: onNotifications,
        ),
        const SizedBox(height: 12),
        NoirAccountHubMenuTile(
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: onSettings,
        ),
      ],
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.isLoading, this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: NoirAccountHubTheme.onBackground,
          foregroundColor: NoirAccountHubTheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: NoirAccountHubTheme.surface,
                ),
              )
            : Text(
                l10n.logout.toUpperCase(),
                style: NoirAccountHubTheme.anton(
                  fontSize: 18,
                  color: NoirAccountHubTheme.surface,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }
}
