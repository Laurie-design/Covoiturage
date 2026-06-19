import 'package:flutter/material.dart';
import 'trip_details_screen.dart';
import 'shared_widgets.dart';

class TripResultsScreen extends StatefulWidget {
  final String? departure;
  final String? arrival;
  final int? passengerCount;
  final DateTime? tripDate;

  const TripResultsScreen({
    super.key,
    this.departure,
    this.arrival,
    this.passengerCount,
    this.tripDate,
  });

  @override
  State<TripResultsScreen> createState() => _TripResultsScreenState();
}

class _TripResultsScreenState extends State<TripResultsScreen> {
  int _selectedFilter = 0;

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    if (date.day == today.day && date.month == today.month && date.year == today.year) {
      return "Aujourd'hui";
    }
    final tomorrow = today.add(const Duration(days: 1));
    if (date.day == tomorrow.day && date.month == tomorrow.month && date.year == tomorrow.year) {
      return 'Demain';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  void _goToDetails({
    required String driverName,
    required String rating,
    required String price,
    required String departureTime,
    required String arrivalTime,
    required String carModel,
    required String immat,
    required String color,
    required bool isVerified,
    required int availableSeats,
    required int totalSeats,
    required List<String> badges,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripDetailsScreen(
          driverName: driverName,
          rating: rating,
          price: price,
          departureTime: departureTime,
          arrivalTime: arrivalTime,
          carModel: carModel,
          immat: immat,
          color: color,
          isVerified: isVerified,
          availableSeats: availableSeats,
          totalSeats: totalSeats,
          badges: badges,
          departure: widget.departure ?? 'Lomé',
          arrival: widget.arrival ?? 'Kara',
          passengerCount: widget.passengerCount ?? 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'TransPorto',
          style: TextStyle(
            color: Color(0xFF000066),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: const ProfileAvatar(radius: 18),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSummary(),
          _buildFilterBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _buildSectionHeader('Départ matin', '6h - 12h', Icons.wb_sunny_outlined),
                _buildTripCard(
                  driverName: 'Koffi A.',
                  rating: '4.8',
                  price: '1 425 FCFA',
                  departureTime: '08:30',
                  arrivalTime: '11:45',
                  carModel: 'Toyota Corolla',
                  immat: 'TG-123-XX',
                  color: 'Gris métal',
                  isVerified: true,
                  availableSeats: 2,
                  totalSeats: 4,
                  badges: ['Climatisé', 'Fumeur non'],
                  onDetails: () => _goToDetails(driverName: 'Koffi A.', rating: '4.8', price: '1 425 FCFA', departureTime: '08:30', arrivalTime: '11:45', carModel: 'Toyota Corolla', immat: 'TG-123-XX', color: 'Gris métal', isVerified: true, availableSeats: 2, totalSeats: 4, badges: ['Climatisé', 'Fumeur non']),
                ),
                const SizedBox(height: 12),
                _buildTripCard(
                  driverName: 'Koffi A.',
                  rating: '4.8',
                  price: '1 600 FCFA',
                  departureTime: '09:00',
                  arrivalTime: '12:15',
                  carModel: 'Toyota Corolla',
                  immat: 'TG-123-XX',
                  color: 'Gris métal',
                  isVerified: true,
                  availableSeats: 3,
                  totalSeats: 4,
                  badges: ['Climatisé'],
                  onDetails: () => _goToDetails(driverName: 'Koffi A.', rating: '4.8', price: '1 600 FCFA', departureTime: '09:00', arrivalTime: '12:15', carModel: 'Toyota Corolla', immat: 'TG-123-XX', color: 'Gris métal', isVerified: true, availableSeats: 3, totalSeats: 4, badges: ['Climatisé']),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Départ après-midi', '12h - 18h', Icons.wb_cloudy_outlined),
                _buildTripCard(
                  driverName: 'Mablé T.',
                  rating: '4.5',
                  price: '1 425 FCFA',
                  departureTime: '14:15',
                  arrivalTime: '17:30',
                  carModel: 'Hyundai Elantra',
                  immat: 'TG-456-YY',
                  color: 'Bleu nuit',
                  isVerified: false,
                  availableSeats: 4,
                  totalSeats: 4,
                  badges: ['Climatisé', 'Musique'],
                  onDetails: () => _goToDetails(driverName: 'Mablé T.', rating: '4.5', price: '1 425 FCFA', departureTime: '14:15', arrivalTime: '17:30', carModel: 'Hyundai Elantra', immat: 'TG-456-YY', color: 'Bleu nuit', isVerified: false, availableSeats: 4, totalSeats: 4, badges: ['Climatisé', 'Musique']),
                ),
                const SizedBox(height: 12),
                _buildTripCard(
                  driverName: 'Yawo S.',
                  rating: '4.9',
                  price: '1 300 FCFA',
                  departureTime: '16:00',
                  arrivalTime: '19:10',
                  carModel: 'Suzuki Swift',
                  immat: 'TG-789-ZZ',
                  color: 'Rouge',
                  isVerified: true,
                  availableSeats: 1,
                  totalSeats: 4,
                  badges: ['Climatisé', 'Fumeur non', 'Animaux OK'],
                  onDetails: () => _goToDetails(driverName: 'Yawo S.', rating: '4.9', price: '1 300 FCFA', departureTime: '16:00', arrivalTime: '19:10', carModel: 'Suzuki Swift', immat: 'TG-789-ZZ', color: 'Rouge', isVerified: true, availableSeats: 1, totalSeats: 4, badges: ['Climatisé', 'Fumeur non', 'Animaux OK']),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Départ soirée', '18h - 23h', Icons.nights_stay_outlined),
                _buildTripCard(
                  driverName: 'Afi K.',
                  rating: '4.7',
                  price: '1 500 FCFA',
                  departureTime: '19:30',
                  arrivalTime: '22:45',
                  carModel: 'Honda Civic',
                  immat: 'TG-321-AA',
                  color: 'Blanc',
                  isVerified: true,
                  availableSeats: 2,
                  totalSeats: 4,
                  badges: ['Climatisé', 'Fumeur non'],
                  onDetails: () => _goToDetails(driverName: 'Afi K.', rating: '4.7', price: '1 500 FCFA', departureTime: '19:30', arrivalTime: '22:45', carModel: 'Honda Civic', immat: 'TG-321-AA', color: 'Blanc', isVerified: true, availableSeats: 2, totalSeats: 4, badges: ['Climatisé', 'Fumeur non']),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Charger plus de trajets',
                        style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSummary() {
    final dateStr = widget.tripDate != null ? _formatDate(widget.tripDate!) : "Aujourd'hui";
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF000066), Color(0xFF0052CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.departure ?? "Lomé"} ➔ ${widget.arrival ?? "Kara"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 13, color: Colors.white.withValues(alpha: 0.7)),
                        const SizedBox(width: 6),
                        Text(
                          dateStr,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.person, size: 13, color: Colors.white.withValues(alpha: 0.7)),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.passengerCount ?? 1} passager${(widget.passengerCount ?? 1) > 1 ? 's' : ''}',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = ['Pertinence', 'Prix +', 'Prix -', 'Départ +', 'Départ -', 'Note'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: List.generate(filters.length, (i) {
            final selected = _selectedFilter == i;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF000066) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                    border: selected ? null : Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (i == 1)
                        Icon(Icons.arrow_upward, size: 14, color: selected ? Colors.white : const Color(0xFF64748B)),
                      if (i == 2)
                        Icon(Icons.arrow_downward, size: 14, color: selected ? Colors.white : const Color(0xFF64748B)),
                      if (i == 3)
                        Icon(Icons.arrow_upward, size: 14, color: selected ? Colors.white : const Color(0xFF64748B)),
                      if (i == 4)
                        Icon(Icons.arrow_downward, size: 14, color: selected ? Colors.white : const Color(0xFF64748B)),
                      if (i != 3 && i != 4) const SizedBox(width: 4),
                      Text(
                        filters[i],
                        style: TextStyle(
                          color: selected ? Colors.white : const Color(0xFF475569),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF000066)),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(width: 8),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF000066).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('2 trajets',
                style: TextStyle(fontSize: 11, color: Color(0xFF000066), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard({
    required String driverName,
    required String rating,
    required String price,
    required String departureTime,
    required String arrivalTime,
    required String carModel,
    required String immat,
    required String color,
    required bool isVerified,
    required int availableSeats,
    required int totalSeats,
    required List<String> badges,
    VoidCallback? onDetails,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onDetails,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFF000066).withValues(alpha: 0.1),
                      child: Text(
                        driverName.split(' ').first[0],
                        style: const TextStyle(
                          color: Color(0xFF000066),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(driverName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                              if (isVerified) ...[
                                const SizedBox(width: 6),
                                Icon(Icons.verified, size: 16, color: Colors.green[700]),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber[600], size: 16),
                              const SizedBox(width: 4),
                              Text(rating,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF475569))),
                              const SizedBox(width: 12),
                              Icon(Icons.event_seat, size: 14, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text('$availableSeats/$totalSeats places',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(price,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF000066))),
                        const Text('par passager',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF000066).withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(departureTime.split(':')[0],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF000066))),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(departureTime,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                        Text(widget.departure ?? 'Lomé',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('3h 15min',
                              style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.radio_button_checked, size: 10, color: Color(0xFF000066)),
                              Expanded(
                                child: Container(height: 1, color: Colors.grey[300]),
                              ),
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF000066), width: 1.5),
                                ),
                              ),
                              Expanded(
                                child: Container(height: 1, color: Colors.grey[300]),
                              ),
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF000066), width: 1.5),
                                ),
                              ),
                              Expanded(
                                child: Container(height: 1, color: Colors.grey[300]),
                              ),
                              const Icon(Icons.radio_button_unchecked, size: 10, color: Color(0xFF000066)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Direct',
                              style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(Icons.location_on, size: 16, color: Color(0xFF22C55E)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(arrivalTime,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                        Text(widget.arrival ?? 'Kara',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.directions_car_filled, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 6),
                    Text(carModel,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    Text(' • $immat',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                    Text(' • $color',
                        style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                    const Spacer(),
                    const Icon(Icons.more_horiz, size: 16, color: Color(0xFF94A3B8)),
                  ],
                ),
                if (badges.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: badges.map((b) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(b,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    )).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF000066),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: onDetails,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(price,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(width: 6),
                        const Text('• Réserver',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
