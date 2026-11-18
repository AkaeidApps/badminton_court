import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  late SharedPreferences prefs;

  String name = 'Amanda Bella';
  String email = '';
  bool isLoggedIn = false;

  List<Booking> bookings = [];
  List<String> favorites = [];

  static const String _loginKey = 'is_logged_in';
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';
  static const String _bookingKey = 'saved_bookings';
  static const String _favoriteKey = 'saved_favorites';

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    isLoggedIn = prefs.getBool(_loginKey) ?? false;
    name = prefs.getString(_nameKey) ?? 'Amanda Bella';
    email = prefs.getString(_emailKey) ?? '';

    final savedBookings = prefs.getString(_bookingKey);
    if (savedBookings != null) {
      try {
        final list = jsonDecode(savedBookings) as List;
        bookings = list
            .map((item) =>
            Booking.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } catch (_) {
        bookings = [];
      }
    }

    favorites = prefs.getStringList(_favoriteKey) ?? [];
  }

  Future<void> login(String userEmail, String password) async {
    email = userEmail.trim();
    final localPart = email.split('@').first;
    name = localPart
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0].toUpperCase() + e.substring(1))
        .join(' ');

    if (name.isEmpty) name = 'User';

    isLoggedIn = true;

    await prefs.setBool(_loginKey, true);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);

    notifyListeners();
  }

  Future<void> logout() async {
    isLoggedIn = false;
    await prefs.setBool(_loginKey, false);
    notifyListeners();
  }

  Future<void> updateProfile(String newName, String newEmail) async {
    name = newName.trim();
    email = newEmail.trim();

    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);

    notifyListeners();
  }

  Future<bool> isSlotAvailable(
      String courtId,
      String date,
      String time,
      ) async {
    return !bookings.any(
          (b) =>
      b.courtId == courtId &&
          b.date == date &&
          b.time == time &&
          b.status == 'Confirmed',
    );
  }

  Future<bool> addBooking(Booking booking) async {
    if (!await isSlotAvailable(
      booking.courtId,
      booking.date,
      booking.time,
    )) {
      return false;
    }

    bookings = [...bookings, booking];
    await _saveBookings();
    notifyListeners();
    return true;
  }

  Future<void> cancelBooking(String id) async {
    bookings = bookings
        .map(
          (b) => b.id == id
          ? Booking(
        id: b.id,
        courtId: b.courtId,
        courtName: b.courtName,
        image: b.image,
        date: b.date,
        time: b.time,
        price: b.price,
        status: 'Cancelled',
      )
          : b,
    )
        .toList();

    await _saveBookings();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    await prefs.setStringList(_favoriteKey, favorites);
    notifyListeners();
  }

  Future<void> _saveBookings() async {
    await prefs.setString(
      _bookingKey,
      jsonEncode(bookings.map((b) => b.toJson()).toList()),
    );
  }

  int get confirmedBookings =>
      bookings.where((b) => b.status == 'Confirmed').length;
}
