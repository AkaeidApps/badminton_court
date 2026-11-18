import 'package:flutter/material.dart';
import '../models/court.dart';
import '../models/booking.dart';
import '../state/app_state.dart';
import '../utils/constants.dart';
import '../widgets/common_widgets.dart';

class CourtDetailsScreen extends StatefulWidget {
  final Court court;

  const CourtDetailsScreen({
    super.key,
    required this.court,
  });

  @override
  State<CourtDetailsScreen> createState() =>
      _CourtDetailsScreenState();
}

class _CourtDetailsScreenState extends State<CourtDetailsScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  bool submitting = false;

  final List<String> slots = const [
    '07:00 AM - 08:00 AM',
    '08:00 AM - 09:00 AM',
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
    '06:00 PM - 07:00 PM',
    '07:00 PM - 08:00 PM',
    '08:00 PM - 09:00 PM',
  ];

  Future<void> chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        selectedTime = null;
      });
    }
  }

  Future<void> confirmBooking() async {
    if (selectedTime == null) {
      message(context, 'Please select a time slot');
      return;
    }

    if (submitting) return;

    setState(() => submitting = true);

    final date = formatDate(selectedDate);

    final booking = Booking(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      courtId: widget.court.id,
      courtName: widget.court.name,
      image: widget.court.image,
      date: date,
      time: selectedTime!,
      price: widget.court.price,
    );

    final success = await AppState.instance.addBooking(booking);

    if (!mounted) return;

    setState(() => submitting = false);

    if (!success) {
      setState(() => selectedTime = null);
      message(
        context,
        'Sorry! This slot has already been booked. Select another slot.',
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: primary,
          size: 58,
        ),
        title: const Text('Booking Confirmed!'),
        content: Text(
          '${widget.court.name}\n\n'
              'Date: $date\n'
              'Time: $selectedTime\n'
              'Price: ${formatPrice(widget.court.price)}',
        ),
        actions: [
          ElevatedButton(
            style: primaryButton(),
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Court Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          AnimatedBuilder(
            animation: AppState.instance,
            builder: (context, _) {
              final saved = AppState.instance.favorites
                  .contains(widget.court.id);

              return IconButton(
                onPressed: () {
                  AppState.instance.toggleFavorite(widget.court.id);
                },
                icon: Icon(
                  saved ? Icons.favorite : Icons.favorite_border,
                  color: saved ? Colors.red : primary,
                ),
              );
            },
          ),
        ],
      ),
      body: pageContainer(
        context,
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(18),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final ratio =
                      constraints.maxWidth < 400 ? 1.45 : 16 / 9;

                      return AspectRatio(
                        aspectRatio: ratio,
                        child: networkImage(
                          widget.court.image,
                          radius: BorderRadius.circular(15),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.court.name,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 15,
                    runSpacing: 7,
                    children: [
                      Text(
                        '⭐ ${widget.court.rating} Rating',
                        style: const TextStyle(color: muted),
                      ),
                      Text(
                        '📍 ${widget.court.location}',
                        style: const TextStyle(color: muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Facilities',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 13),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns =
                      constraints.maxWidth < 330 ? 2 : 4;
                      final itemWidth =
                          (constraints.maxWidth -
                              (columns - 1) * 10) /
                              columns;

                      final facilities = [
                        [Icons.wifi, 'Wifi'],
                        [Icons.restaurant, 'Canteen'],
                        [Icons.bathtub, 'Bathroom'],
                        [Icons.ac_unit, 'AC'],
                      ];

                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: facilities.map((item) {
                          return Container(
                            width: itemWidth,
                            height: 82,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item[0] as IconData,
                                  color: primary,
                                  size: 25,
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  item[1] as String,
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 27),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: chooseDate,
                        icon: const Icon(
                          Icons.calendar_month,
                          color: primary,
                        ),
                        label: const Text(
                          'Change',
                          style: TextStyle(color: primary),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatDate(selectedDate),
                    style: const TextStyle(color: muted),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Select one available slot for your booking',
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Responsive time slot grid
                  AnimatedBuilder(
                    animation: AppState.instance,
                    builder: (context, _) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final columns =
                          constraints.maxWidth < 370 ? 1 : 2;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics:
                            const NeverScrollableScrollPhysics(),
                            itemCount: slots.length,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 55,
                            ),
                            itemBuilder: (context, index) {
                              final time = slots[index];

                              final booked = AppState.instance.bookings.any(
                                    (b) =>
                                b.courtId == widget.court.id &&
                                    b.date == formatDate(selectedDate) &&
                                    b.time == time &&
                                    b.status == 'Confirmed',
                              );

                              final selected = selectedTime == time;

                              return InkWell(
                                onTap: booked
                                    ? null
                                    : () {
                                  setState(
                                        () => selectedTime = time,
                                  );
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: booked
                                        ? const Color(0xFFFFEEEE)
                                        : selected
                                        ? const Color(0xFFDDF4E9)
                                        : Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: Border.all(
                                      color: booked
                                          ? Colors.red.shade200
                                          : selected
                                          ? primary
                                          : const Color(0xFFE2EAE5),
                                      width: selected ? 1.6 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        booked
                                            ? Icons.lock_outline
                                            : Icons.access_time,
                                        size: 17,
                                        color: booked
                                            ? Colors.red
                                            : primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          time,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: booked
                                                ? Colors.red
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        booked
                                            ? 'Booked'
                                            : selected
                                            ? 'Selected'
                                            : 'Available',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: booked
                                              ? Colors.red
                                              : primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Price / Hour',
                            style: TextStyle(color: muted),
                          ),
                        ),
                        Text(
                          formatPrice(widget.court.price),
                          style: const TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitting ? null : confirmBooking,
                      style: primaryButton(),
                      child: submitting
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : const Text(
                        'Confirm Court Booking',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
