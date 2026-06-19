import 'package:flutter/material.dart';
import 'payment_screen.dart';
import '../services/auth_service.dart';
import 'register_view.dart';
import 'identity_verification_view.dart';

class TripDetailsScreen extends StatelessWidget {
  final String driverName;
  final String rating;
  final String price;
  final String departureTime;
  final String arrivalTime;
  final String carModel;
  final String immat;
  final String color;
  final bool isVerified;
  final int availableSeats;
  final int totalSeats;
  final List<String> badges;
  final String departure;
  final String arrival;
  final int passengerCount;

  const TripDetailsScreen({
    super.key,
    required this.driverName,
    required this.rating,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.carModel,
    required this.immat,
    required this.color,
    required this.isVerified,
    required this.availableSeats,
    required this.totalSeats,
    required this.badges,
    required this.departure,
    required this.arrival,
    required this.passengerCount,
  });

  Widget _paymentScreenBuilder(BuildContext ctx) => PaymentScreen(
        price: price,
        departure: departure,
        arrival: arrival,
        driverName: driverName,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
      );

  void _handleReserve(BuildContext context) {
    final auth = AuthService();

    if (!auth.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegisterView()),
      );
      return;
    }

    if (!auth.identityVerified) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IdentityVerificationView(
            isDriver: false,
            redirectBuilder: _paymentScreenBuilder,
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: _paymentScreenBuilder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Détails du trajet',
          style:
              TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF000066)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverCard(),
            const SizedBox(height: 20),
            _buildRouteCard(),
            const SizedBox(height: 20),
            _buildPriceSeatsCard(),
            const SizedBox(height: 20),
            _buildVehicleCard(),
            const SizedBox(height: 20),
            _buildBadgesCard(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000066),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () => _handleReserve(context),
                icon: const Icon(Icons.book_online, size: 20),
                label: Text(
                  'Réserver',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A))),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Conducteur'),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF000066).withValues(alpha: 0.1),
                child: Text(
                  driverName.split(' ').first[0],
                  style: const TextStyle(
                      color: Color(0xFF000066),
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(driverName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF0F172A))),
                        if (isVerified) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.verified,
                              size: 18, color: Colors.green[700]),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[600], size: 18),
                        const SizedBox(width: 4),
                        Text(rating,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0xFF475569))),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Vérifié',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Trajet'),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF000066).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(departureTime,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Color(0xFF000066))),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(departureTime,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF0F172A))),
                  Text(departure,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF64748B))),
                  Text('Gare Routière',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Text('3h 15min',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[500])),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.radio_button_checked,
                            size: 10, color: Color(0xFF000066)),
                        Expanded(
                            child:
                                Container(height: 1, color: Colors.grey[300])),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF000066), width: 1.5),
                          ),
                        ),
                        Expanded(
                            child:
                                Container(height: 1, color: Colors.grey[300])),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF000066), width: 1.5),
                          ),
                        ),
                        Expanded(
                            child:
                                Container(height: 1, color: Colors.grey[300])),
                        const Icon(Icons.radio_button_unchecked,
                            size: 10, color: Color(0xFF000066)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('Direct',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.location_on,
                          size: 18, color: Color(0xFF22C55E)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(arrivalTime,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF0F172A))),
                  Text(arrival,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF64748B))),
                  Text('Gare Routière',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF94A3B8))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSeatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Prix & Places'),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000066).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Prix par passager',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(price,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000066))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Places restantes',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('$availableSeats',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A34A))),
                          const SizedBox(width: 4),
                          Text('/ $totalSeats',
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text('Voyage avec ',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              Text('$passengerCount passager${passengerCount > 1 ? 's' : ''}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F172A))),
              const Spacer(),
              ...List.generate(
                  totalSeats,
                  (i) => Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.event_seat,
                          size: 20,
                          color: i < availableSeats
                              ? Colors.green
                              : Colors.grey[300],
                        ),
                      )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Véhicule'),
          Row(
            children: [
              Container(
                width: 72,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.directions_car, color: Color(0xFF94A3B8), size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(carModel,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
                    const SizedBox(height: 4),
                    Text('$immat • $color',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Équipements'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badges
                .map((b) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_badgeIcon(b),
                              size: 16, color: const Color(0xFF000066)),
                          const SizedBox(width: 6),
                          Text(b,
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF1E293B))),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  IconData _badgeIcon(String badge) {
    if (badge.contains('Climatisé')) return Icons.ac_unit;
    if (badge.contains('Fumeur')) return Icons.smoke_free;
    if (badge.contains('Animaux')) return Icons.pets;
    if (badge.contains('Musique')) return Icons.music_note;
    return Icons.check_circle_outline;
  }
}
