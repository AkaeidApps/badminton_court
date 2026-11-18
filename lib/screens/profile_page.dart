import 'package:flutter/material.dart';
import '../models/court.dart';
import '../state/app_state.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';
import '../widgets/booking_card.dart';
import '../widgets/court_card.dart';
import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> editProfile(BuildContext context) async {
    final state = AppState.instance;

    final nameController = TextEditingController(text: state.name);
    final emailController = TextEditingController(text: state.email);

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: inputDecoration('Full name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration('Email address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: primaryButton(),
            onPressed: () async {
              final name = nameController.text.trim();
              final email = emailController.text.trim();

              if (name.isEmpty || !email.contains('@')) {
                message(context, 'Enter valid profile details');
                return;
              }

              await state.updateProfile(name, email);

              if (!dialogContext.mounted) return;

              Navigator.pop(dialogContext);
              message(context, 'Profile updated');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    nameController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final history = state.bookings.reversed.toList();

        return pageContainer(
          context,
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    pageTitle(
                      'My Profile',
                      'Manage your account and bookings',
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primary,
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 48,
                          backgroundColor: Color(0xFFDDF4E9),
                          child: Icon(
                            Icons.person,
                            color: primary,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    Center(
                      child: Text(
                        state.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        state.email,
                        style: const TextStyle(
                          color: muted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () => editProfile(context),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit Profile'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primary,
                          side: const BorderSide(color: primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 23),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            Expanded(
                              child: statBox(
                                'Bookings',
                                '${state.bookings.length}',
                                Icons.calendar_month,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: statBox(
                                'Favorites',
                                '${state.favorites.length}',
                                Icons.favorite_border,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'My Booking History',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (history.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Center(
                          child: Text(
                            'You have no bookings yet',
                            style: TextStyle(color: muted),
                          ),
                        ),
                      ),
                  ]),
                ),
              ),
              if (history.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => BookingCard(
                        booking: history[index],
                      ),
                      childCount: history.length,
                    ),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 10),
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    profileTile(
                      Icons.person_outline,
                      'Edit Personal Information',
                          () => editProfile(context),
                    ),
                    profileTile(
                      Icons.favorite_border,
                      'My Favorites',
                          () => showFavorites(context),
                    ),
                    profileTile(
                      Icons.notifications_none,
                      'Notifications',
                          () => message(context, 'No new notifications'),
                    ),
                    profileTile(
                      Icons.help_outline,
                      'Help & Support',
                          () => message(context, 'Contact support'),
                    ),
                    profileTile(
                      Icons.info_outline,
                      'About App',
                          () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Court Booking',
                          applicationVersion: '2.0.0',
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await AppState.instance.logout();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                                (_) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showFavorites(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: AnimatedBuilder(
          animation: AppState.instance,
          builder: (context, _) {
            final favorites = AppState.instance.favorites;

            return Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 450),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Favorite Courts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (favorites.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(25),
                        child: Center(child: Text('No favorite courts')),
                      ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: courts
                            .where((c) => favorites.contains(c.id))
                            .map(
                              (court) => ListTile(
                            leading: const Icon(
                              Icons.favorite,
                              color: primary,
                            ),
                            title: Text(court.name),
                            trailing: Text(
                              formatPrice(court.price),
                            ),
                            onTap: () {
                              Navigator.pop(sheetContext);
                              openCourt(context, court);
                            },
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
