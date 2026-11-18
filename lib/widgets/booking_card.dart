import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../utils/constants.dart';
import 'common_widgets.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final cancelled = booking.status == 'Cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: networkImage(
                  booking.image,
                  width: 75,
                  height: 70,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.courtName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cancelled
                            ? const Color(0xFFFFEEEE)
                            : const Color(0xFFE6F5EF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        booking.status,
                        style: TextStyle(
                          color: cancelled ? Colors.red : darkGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Wrap(
            spacing: 15,
            runSpacing: 8,
            children: [
              infoItem(Icons.calendar_today, booking.date),
              infoItem(Icons.access_time, booking.time),
            ],
          ),
          const Divider(height: 23),
          Row(
            children: [
              Expanded(
                child: Text(
                  formatPrice(booking.price),
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              if (!cancelled)
                TextButton.icon(
                  onPressed: () => showCancelDialog(context, booking),
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Cancel Booking',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
