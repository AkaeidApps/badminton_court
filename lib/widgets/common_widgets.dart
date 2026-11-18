import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../state/app_state.dart';
import '../models/booking.dart';

void message(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      backgroundColor: darkGreen,
    ),
  );
}

String formatPrice(int price) {
  return '৳${price.toString()}';
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 15,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: Color(0xFFE3EAE6)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: Color(0xFFE3EAE6)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: primary, width: 1.5),
    ),
  );
}

ButtonStyle primaryButton() {
  return ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    elevation: 0,
    minimumSize: const Size(0, 48),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(11),
    ),
  );
}

Widget networkImage(
    String url, {
      double? height,
      double? width,
      BorderRadius radius = BorderRadius.zero,
    }) {
  return ClipRRect(
    borderRadius: radius,
    child: Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: const Color(0xFFE5F3EC),
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: primary,
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: const Color(0xFFE5F3EC),
        alignment: Alignment.center,
        child: const Icon(
          Icons.sports_tennis,
          size: 45,
          color: primary,
        ),
      ),
    ),
  );
}

Widget pageContainer(
    BuildContext context,
    Widget child, {
      double maxWidth = 1200,
    }) {
  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
    ),
  );
}

Widget pageTitle(String title, String subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        subtitle,
        style: const TextStyle(color: muted, fontSize: 13),
      ),
    ],
  );
}

Widget smallTag(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 9,
      vertical: 6,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFFE6F5EF),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: darkGreen,
        fontSize: 10,
      ),
    ),
  );
}

Widget statBox(String title, String value, IconData icon) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: primary, size: 25),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget infoItem(IconData icon, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: muted, size: 14),
      const SizedBox(width: 5),
      Text(
        text,
        style: const TextStyle(
          color: muted,
          fontSize: 11,
        ),
      ),
    ],
  );
}

Widget profileTile(
    IconData icon,
    String title,
    VoidCallback onTap,
    ) {
  return Card(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(11),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      leading: Icon(icon, color: primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: muted,
      ),
      onTap: onTap,
    ),
  );
}

void showCancelDialog(BuildContext context, Booking booking) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Cancel Booking?'),
      content: const Text(
        'Are you sure you want to cancel this booking?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Keep Booking'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await AppState.instance.cancelBooking(booking.id);

            if (!dialogContext.mounted) return;

            Navigator.pop(dialogContext);
            message(context, 'Booking cancelled successfully');
          },
          child: const Text('Cancel Booking'),
        ),
      ],
    ),
  );
}
