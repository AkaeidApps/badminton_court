import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';
import '../widgets/booking_card.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final bookings = AppState.instance.bookings.reversed.toList();

        return pageContainer(
          context,
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    pageTitle(
                      'My Bookings',
                      'Manage your court reservations',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: statBox(
                            'Total',
                            '${bookings.length}',
                            Icons.calendar_month,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: statBox(
                            'Confirmed',
                            '${AppState.instance.confirmedBookings}',
                            Icons.check_circle_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    if (bookings.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 75),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 70,
                              color: primary,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'No Bookings Yet',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Your court bookings will appear here.',
                              style: TextStyle(color: muted),
                            ),
                          ],
                        ),
                      ),
                  ]),
                ),
              ),
              if (bookings.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => BookingCard(
                        booking: bookings[index],
                      ),
                      childCount: bookings.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 25)),
            ],
          ),
        );
      },
    );
  }
}
