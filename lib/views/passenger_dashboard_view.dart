import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'invoice_screen.dart';
import 'review_screen.dart';
import 'home_view.dart';
import 'signin_view.dart';
import 'shared_widgets.dart';
import '../services/auth_service.dart';

class PassengerTrip {
  final String id;
  final String route;
  final String driverName;
  final String departureTime;
  final String arrivalTime;
  final String confirmationCode;
  final DateTime date;
  final int price;
  final String status;
  double? rating;
  final String? carModel;
  String? comment;

  PassengerTrip({
    required this.id,
    required this.route,
    required this.driverName,
    required this.departureTime,
    required this.arrivalTime,
    required this.confirmationCode,
    required this.date,
    required this.price,
    required this.status,
    this.rating,
    this.carModel,
    this.comment,
  });
}

class PassengerDashboardView extends StatefulWidget {
  const PassengerDashboardView({super.key});

  @override
  State<PassengerDashboardView> createState() => _PassengerDashboardViewState();
}

class _PassengerDashboardViewState extends State<PassengerDashboardView> {
  int _selectedNavIndex = 0;
  bool _sidebarOpen = true;
  String? _filterStatus;

  final _nomController = TextEditingController(text: 'Kossi');
  final _prenomController = TextEditingController(text: 'Agbodifo');
  final _telController = TextEditingController(text: '+228 90 00 00 00');

  final List<PassengerTrip> _trips = [
    PassengerTrip(
      id: '1',
      route: 'Lomé → Kara',
      driverName: 'Koffi A.',
      departureTime: '08:30',
      arrivalTime: '11:45',
      confirmationCode: '487251',
      date: DateTime.now().add(const Duration(days: 2)),
      price: 1425,
      status: 'upcoming',
      carModel: 'Toyota Corolla',
    ),
    PassengerTrip(
      id: '2',
      route: 'Lomé → Atakpamé',
      driverName: 'Mablé T.',
      departureTime: '14:15',
      arrivalTime: '17:30',
      confirmationCode: '632894',
      date: DateTime.now().add(const Duration(days: 5)),
      price: 1900,
      status: 'upcoming',
      carModel: 'Hyundai Elantra',
    ),
    PassengerTrip(
      id: '3',
      route: 'Sokodé → Kara',
      driverName: 'Yawo S.',
      departureTime: '16:00',
      arrivalTime: '19:10',
      confirmationCode: '154723',
      date: DateTime.now().subtract(const Duration(days: 3)),
      price: 1100,
      status: 'completed',
      rating: 4.5,
      carModel: 'Suzuki Swift',
      comment: 'Conducteur ponctuel et agréable',
    ),
    PassengerTrip(
      id: '4',
      route: 'Kpalimé → Lomé',
      driverName: 'Afi K.',
      departureTime: '07:00',
      arrivalTime: '09:30',
      confirmationCode: '908561',
      date: DateTime.now().subtract(const Duration(days: 10)),
      price: 850,
      status: 'completed',
      carModel: 'Honda Civic',
    ),
    PassengerTrip(
      id: '5',
      route: 'Lomé → Kara',
      driverName: 'Koffi A.',
      departureTime: '10:00',
      arrivalTime: '13:15',
      confirmationCode: '332176',
      date: DateTime.now().subtract(const Duration(days: 7)),
      price: 1425,
      status: 'cancelled',
      carModel: 'Toyota Corolla',
    ),
    PassengerTrip(
      id: '6',
      route: 'Lomé → Kpalimé',
      driverName: 'Efoé K.',
      departureTime: '09:00',
      arrivalTime: '11:30',
      confirmationCode: '771204',
      date: DateTime.now().subtract(const Duration(days: 15)),
      price: 950,
      status: 'completed',
      carModel: 'Renault Logan',
    ),
    PassengerTrip(
      id: '7',
      route: 'Atakpamé → Lomé',
      driverName: 'Dovi A.',
      departureTime: '13:00',
      arrivalTime: '16:15',
      confirmationCode: '445903',
      date: DateTime.now().subtract(const Duration(days: 21)),
      price: 1800,
      status: 'completed',
      carModel: 'Toyota Hilux',
    ),
    PassengerTrip(
      id: '8',
      route: 'Kara → Sokodé',
      driverName: 'Amah S.',
      departureTime: '06:30',
      arrivalTime: '08:45',
      confirmationCode: '992318',
      date: DateTime.now().subtract(const Duration(days: 30)),
      price: 750,
      status: 'completed',
      carModel: 'Suzuki Swift',
    ),
  ];

  int get _completedTrips =>
      _trips.where((t) => t.status == 'completed').length;
  int get _upcomingTrips => _trips.where((t) => t.status == 'upcoming').length;
  int get _totalSpent => _trips
      .where((t) => t.status == 'completed' || t.status == 'upcoming')
      .fold(0, (sum, t) => sum + t.price);
  double get _avgRating {
    final ratings =
        _trips.where((t) => t.rating != null).map((t) => t.rating!).toList();
    if (ratings.isEmpty) return 0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  List<PassengerTrip> get _filteredTrips {
    if (_filterStatus == null) return _trips;
    return _trips.where((t) => t.status == _filterStatus).toList();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildMainBody(),
    );
  }

  Widget _buildMainBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        return isMobile
            ? _buildContent()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: _sidebarOpen ? 240 : 0,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF000066), Color(0xFF0052CC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SizedBox(
                      width: 240,
                      child: _SidebarContent(
                        selectedIndex: _selectedNavIndex,
                        onNavTap: (index) =>
                            setState(() => _selectedNavIndex = index),
                      ),
                    ),
                  ),
                  Expanded(child: _buildContent()),
                ],
              );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) return const SizedBox.shrink();
          return IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _sidebarOpen
                  ? const AlwaysStoppedAnimation(1.0)
                  : const AlwaysStoppedAnimation(0.0),
            ),
            color: const Color(0xFF000066),
            onPressed: () => setState(() => _sidebarOpen = !_sidebarOpen),
          );
        },
      ),
      title: const Text('TransPorto',
          style:
              TextStyle(color: Color(0xFF000066), fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: const Icon(Icons.home_outlined, color: Color(0xFF000066)),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeView()),
            (route) => false,
          ),
        ),
        IconButton(
            icon:
                const Icon(Icons.notifications_none, color: Color(0xFF000066)),
            onPressed: () {}),
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: ProfileAvatar(radius: 16),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000066), Color(0xFF0052CC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: ClipOval(
                        child: AuthService().profileImage != null
                            ? Image.memory(AuthService().profileImage!,
                                width: 56, height: 56, fit: BoxFit.cover)
                            : const Icon(Icons.person,
                                size: 32, color: Colors.white),
                      )),
                  const SizedBox(height: 12),
                  const Text('Kossi Agbodifo',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: const [
                      Icon(Icons.check_circle,
                          size: 14, color: Colors.greenAccent),
                      SizedBox(width: 6),
                      Text('Compte vérifié',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: _buildNavList(isDrawer: true)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavList({bool isDrawer = false}) {
    final items = [
      ('Tableau de bord', Icons.dashboard_outlined, 0),
      ('Mes voyages', Icons.route_outlined, 1),
      ('Mes avis', Icons.star_outline, 2),
      ('Mon profil', Icons.person_outline, 3),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: items.map((item) {
        final isSelected = _selectedNavIndex == item.$3;
        final textColor = isSelected ? Colors.white : Colors.white70;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() => _selectedNavIndex = item.$3);
                if (isDrawer) Navigator.pop(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(item.$2, size: 20, color: textColor),
                    const SizedBox(width: 12),
                    Text(item.$1,
                        style: TextStyle(
                          color: textColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContent() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildTripsPage();
      case 2:
        return _buildReviewsPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Voyages', '$_completedTrips',
                      Icons.route, const Color(0xFFFF6F61))),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildStatCard('À venir', '$_upcomingTrips',
                      Icons.schedule, const Color(0xFFFDD835))),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildStatCard('Dépensé', '$_totalSpent F',
                      Icons.account_balance_wallet, const Color(0xFF795548))),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildStatCard(
                      'Avis',
                      '${_avgRating.toStringAsFixed(1)} ⭐',
                      Icons.star,
                      const Color(0xFF009688))),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Prochains voyages',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000066))),
          const SizedBox(height: 10),
          ..._trips
              .where((t) => t.status == 'upcoming')
              .map((t) => _buildTripCard(t)),
          const SizedBox(height: 24),
          const Text('Derniers voyages',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000066))),
          const SizedBox(height: 10),
          ..._trips
              .where((t) => t.status == 'completed')
              .take(2)
              .map((t) => _buildTripCard(t)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 2),
              Text(title,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 24),
        ],
      ),
    );
  }

  Widget _buildTripCard(PassengerTrip trip) {
    Color statusBg;
    Color statusText;
    String statusLabel;
    switch (trip.status) {
      case 'upcoming':
        statusBg = const Color(0xFFDCFCE7);
        statusText = Colors.green;
        statusLabel = 'À venir';
        break;
      case 'completed':
        statusBg = const Color(0xFFE0F2FE);
        statusText = const Color(0xFF0369A1);
        statusLabel = 'Terminé';
        break;
      case 'cancelled':
        statusBg = const Color(0xFFFFEBEE);
        statusText = const Color(0xFFC62828);
        statusLabel = 'Annulé';
        break;
      default:
        statusBg = const Color(0xFFF1F5F9);
        statusText = const Color(0xFF64748B);
        statusLabel = trip.status;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showTripDetails(trip),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trip.route,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF0F172A))),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 13, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(
                                  '${trip.date.day}/${trip.date.month}/${trip.date.year}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF64748B))),
                              const SizedBox(width: 12),
                              const Icon(Icons.person,
                                  size: 13, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(trip.driverName,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(statusLabel,
                          style: TextStyle(
                              color: statusText,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.monetization_on,
                        size: 14, color: Color(0xFF000066)),
                    const SizedBox(width: 4),
                    Text('${trip.price} FCFA',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF000066))),
                    if (trip.status == 'upcoming') ...[
                      const SizedBox(width: 16),
                      const Icon(Icons.confirmation_number,
                          size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(trip.confirmationCode,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              letterSpacing: 2)),
                    ],
                    const Spacer(),
                    const Icon(Icons.chevron_right,
                        size: 18, color: Color(0xFFCBD5E1)),
                  ],
                ),
                if (trip.status == 'completed' && trip.rating == null) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 32,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000066),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            final result = await Navigator.push<Map<String, dynamic>>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReviewScreen(
                                  driverName: trip.driverName,
                                  route: trip.route,
                                  dateLabel:
                                      '${trip.date.day}/${trip.date.month}/${trip.date.year}',
                                ),
                              ),
                            );
                            if (result != null && mounted) {
                              setState(() {
                                trip.rating = result['rating'] as double;
                                trip.comment = result['comment'] as String?;
                              });
                            }
                          },
                          icon: const Icon(Icons.star_outline, size: 14),
                          label: const Text('Noter',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 32,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF000066),
                            side: const BorderSide(color: Color(0xFF000066)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InvoiceScreen(
                                  driverName: trip.driverName,
                                  route: trip.route,
                                  dateLabel:
                                      '${trip.date.day}/${trip.date.month}/${trip.date.year}',
                                  departureTime: trip.departureTime,
                                  arrivalTime: trip.arrivalTime,
                                  carModel: trip.carModel ?? '-',
                                  price: trip.price,
                                  confirmationCode:
                                      trip.confirmationCode,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download, size: 14),
                          label: const Text('Facture',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
                if (trip.status == 'completed' && trip.rating != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ...List.generate(
                          5,
                          (i) => Icon(
                                i < trip.rating!.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              )),
                      const Spacer(),
                      SizedBox(
                        height: 28,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF000066),
                            side: const BorderSide(color: Color(0xFF000066)),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InvoiceScreen(
                                  driverName: trip.driverName,
                                  route: trip.route,
                                  dateLabel:
                                      '${trip.date.day}/${trip.date.month}/${trip.date.year}',
                                  departureTime: trip.departureTime,
                                  arrivalTime: trip.arrivalTime,
                                  carModel: trip.carModel ?? '-',
                                  price: trip.price,
                                  confirmationCode:
                                      trip.confirmationCode,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download, size: 12),
                          label: const Text('Facture',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripsPage() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mes voyages',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A))),
              const SizedBox(height: 16),
              _buildFilterChips(),
            ],
          ),
        ),
        Expanded(
          child: _filteredTrips.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off,
                          size: 48, color: Color(0xFFCBD5E1)),
                      SizedBox(height: 8),
                      Text('Aucun voyage trouvé',
                          style: TextStyle(color: Color(0xFF94A3B8))),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildTable(
                    columns: const [
                      'DATE',
                      'TRAJET',
                      'CHAUFFEUR',
                      'PRIX',
                      'STATUT',
                      'FACTURE',
                      'ACTIONS'
                    ],
                    flexes: const [2, 2, 2, 2, 2, 1, 2],
                    rows: _filteredTrips.map((t) {
                      Color statusBg;
                      Color statusText;
                      String label;
                      switch (t.status) {
                        case 'upcoming':
                          statusBg = const Color(0xFFDCFCE7);
                          statusText = Colors.green;
                          label = 'À venir';
                          break;
                        case 'completed':
                          statusBg = const Color(0xFFE0F2FE);
                          statusText = const Color(0xFF0369A1);
                          label = 'Terminé';
                          break;
                        case 'cancelled':
                          statusBg = const Color(0xFFFFEBEE);
                          statusText = const Color(0xFFC62828);
                          label = 'Annulé';
                          break;
                        default:
                          statusBg = const Color(0xFFF1F5F9);
                          statusText = const Color(0xFF64748B);
                          label = t.status;
                      }
                      return [
                        '${t.date.day}/${t.date.month}/${t.date.year}',
                        t.route,
                        t.driverName,
                        '${t.price} FCFA',
                        _buildStatusBadge(label, statusBg, statusText),
                        t.status == 'completed'
                            ? SizedBox(
                                height: 28,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    side: const BorderSide(
                                        color: Color(0xFF000066)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => InvoiceScreen(
                                          driverName: t.driverName,
                                          route: t.route,
                                          dateLabel:
                                              '${t.date.day}/${t.date.month}/${t.date.year}',
                                          departureTime: t.departureTime,
                                          arrivalTime: t.arrivalTime,
                                          carModel: t.carModel ?? '-',
                                          price: t.price,
                                          confirmationCode:
                                              t.confirmationCode,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('PDF',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF000066),
                                          fontWeight: FontWeight.w600)),
                                ),
                              )
                            : const Text('-',
                                style: TextStyle(
                                    color: Color(0xFFCBD5E1), fontSize: 13)),
                        _buildActionsRow(t),
                      ];
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = <String, String?>{
      'Tous': null,
      'À venir': 'upcoming',
      'Terminés': 'completed',
      'Annulés': 'cancelled'
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          final label = entry.key;
          final value = entry.value;
          final count = value == null
              ? _trips.length
              : _trips.where((t) => t.status == value).length;
          final isSelected = _filterStatus == value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(
                  () => _filterStatus = _filterStatus == value ? null : value),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF000066)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        )),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white24
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('$count',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF64748B),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReviewsPage() {
    final rated = _trips.where((t) => t.rating != null).toList();
    final avgNote = rated.isEmpty
        ? 0.0
        : rated.fold(0.0, (sum, t) => sum + t.rating!) / rated.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(avgNote.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A))),
                    Row(
                      children: List.generate(
                          5,
                          (i) => Icon(
                                i < avgNote.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 18,
                              )),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${rated.length} avis donnés',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('Basé sur les trajets terminés',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (rated.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: const Center(
                  child: Text('Vous n\'avez pas encore donné d\'avis',
                      style: TextStyle(color: Color(0xFF94A3B8)))),
            )
          else
            _buildTable(
              columns: const [
                'TRAJET',
                'CHAUFFEUR',
                'NOTE',
                'COMMENTAIRE',
                'DATE'
              ],
              flexes: const [2, 2, 1, 3, 2],
              rows: rated
                  .map((t) => [
                        t.route,
                        t.driverName,
                        _buildStars(t.rating!),
                        t.comment ?? '-',
                        '${t.date.day}/${t.date.month}/${t.date.year}',
                      ])
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildStars(double note) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          5,
          (i) => Icon(
                i < note.round() ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 14,
              )),
    );
  }

  Widget _buildStatusBadge(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label,
          style: TextStyle(
              color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionsRow(PassengerTrip trip) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => _showTripDetails(trip),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.visibility_outlined,
                size: 18, color: Color(0xFF475569)),
          ),
        ),
        if (trip.status == 'upcoming') ...[
          const SizedBox(width: 6),
          InkWell(
            onTap: () => _confirmCancelTrip(trip),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.cancel_outlined,
                  size: 18, color: Color(0xFFC62828)),
            ),
          ),
        ],
        if (trip.status == 'completed' && trip.rating == null) ...[
          const SizedBox(width: 6),
          InkWell(
            onTap: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => ReviewScreen(
                    driverName: trip.driverName,
                    route: trip.route,
                    dateLabel:
                        '${trip.date.day}/${trip.date.month}/${trip.date.year}',
                  ),
                ),
              );
              if (result != null && mounted) {
                setState(() {
                  trip.rating = result['rating'] as double;
                  trip.comment = result['comment'] as String?;
                });
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.star_outline,
                  size: 18, color: Color(0xFFF57F17)),
            ),
          ),
        ],
        if (trip.status == 'completed') ...[
          const SizedBox(width: 6),
          InkWell(
            onTap: () => _confirmDeleteTrip(trip),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.delete_outline,
                  size: 18, color: Color(0xFFC62828)),
            ),
          ),
        ],
      ],
    );
  }

  void _confirmCancelTrip(PassengerTrip trip) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Annuler la réservation'),
        content: Text('Êtes-vous sûr de vouloir annuler votre voyage ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _trips.removeWhere((x) => x.id == trip.id));
            },
            child: const Text('Oui, annuler',
                style: TextStyle(color: Color(0xFFDC2626))),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTrip(PassengerTrip trip) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer le trajet'),
        content: Text(
            'Êtes-vous sûr de vouloir supprimer ce trajet ${trip.route} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _trips.removeWhere((x) => x.id == trip.id));
            },
            child: const Text('Oui, supprimer',
                style: TextStyle(color: Color(0xFFDC2626))),
          ),
        ],
      ),
    );
  }

  Future<void> _pickNewProfileImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    AuthService().setProfileImage(bytes);
    setState(() {});
  }

  Widget _buildTable({
    required List<String> columns,
    required List<int> flexes,
    required List<List<dynamic>> rows,
    void Function(dynamic)? onRowTap,
    List? rowData,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Row(
              children: List.generate(
                  columns.length,
                  (i) => Expanded(
                        flex: flexes[i],
                        child: Text(columns[i],
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF334155))),
                      )),
            ),
          ),
          ...List.generate(rows.length, (rowIdx) {
            final row = rows[rowIdx];
            return InkWell(
              onTap: onRowTap != null && rowData != null
                  ? () => onRowTap(rowData[rowIdx])
                  : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: rowIdx < rows.length - 1
                      ? const Border(
                          bottom: BorderSide(color: Color(0xFFF1F5F9)))
                      : null,
                ),
                child: Row(
                  children: List.generate(
                      row.length,
                      (cIdx) => Expanded(
                            flex: flexes[cIdx],
                            child: row[cIdx] is Widget
                                ? row[cIdx] as Widget
                                : Text('${row[cIdx]}',
                                    style: const TextStyle(
                                        fontSize: 13, color: Color(0xFF1E293B)),
                                    overflow: TextOverflow.ellipsis),
                          )),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFCBD5E1),
                      child: ClipOval(
                        child: AuthService().profileImage != null
                            ? Image.memory(AuthService().profileImage!,
                                width: 100, height: 100, fit: BoxFit.cover)
                            : const Icon(Icons.person,
                                size: 56, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickNewProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF000066),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Kossi Agbodifo',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 14),
                    SizedBox(width: 4),
                    Text('Compte vérifié',
                        style:
                            TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text('Informations personnelles',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 14),
          _buildProfileField('NOM', _nomController),
          const SizedBox(height: 12),
          _buildProfileField('PRÉNOM', _prenomController),
          const SizedBox(height: 12),
          _buildProfileField('NUMÉRO DE TÉLÉPHONE', _telController,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000066),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profil mis à jour avec succès'),
                      backgroundColor: Colors.green),
                );
              },
              child: const Text('Enregistrer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: const BorderSide(color: Color(0xFFDC2626)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                AuthService().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInView()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Se déconnecter',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  void _showTripDetails(PassengerTrip trip) {
    _showBlurredDialog((ctx) => Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(trip.route,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(height: 24),
              _detailRow('Conducteur', trip.driverName),
              _detailRow('Date',
                  '${trip.date.day}/${trip.date.month}/${trip.date.year}'),
              _detailRow(
                  'Horaire', '${trip.departureTime} → ${trip.arrivalTime}'),
              _detailRow('Prix', '${trip.price} FCFA'),
              if (trip.status == 'upcoming')
                _detailRow('Code réservation', trip.confirmationCode),
              if (trip.carModel != null) _detailRow('Véhicule', trip.carModel!),
              if (trip.status == 'upcoming') ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _confirmCancelTrip(trip);
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Annuler ma réservation'),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ));
  }

  void _showBlurredDialog(Widget Function(BuildContext) builder) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: builder(ctx),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}

class _SidebarContent extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;

  const _SidebarContent({
    required this.selectedIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Tableau de bord', Icons.dashboard_outlined, 0),
      ('Mes voyages', Icons.route_outlined, 1),
      ('Mes avis', Icons.star_outline, 2),
      ('Mon profil', Icons.person_outline, 3),
    ];

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white24,
                  child: ClipOval(
                    child: AuthService().profileImage != null
                        ? Image.memory(AuthService().profileImage!,
                            width: 48, height: 48, fit: BoxFit.cover)
                        : const Icon(Icons.person,
                            size: 28, color: Colors.white),
                  )),
              const SizedBox(height: 10),
              const Text('Kossi Agbodifo',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Row(
                children: const [
                  Icon(Icons.check_circle, size: 12, color: Colors.greenAccent),
                  SizedBox(width: 4),
                  Text('Compte vérifié',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: items.map((item) {
              final isSelected = selectedIndex == item.$3;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onNavTap(item.$3),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(item.$2, size: 20, color: Colors.white70),
                          const SizedBox(width: 12),
                          Text(item.$1,
                              style: TextStyle(
                                color: Colors.white70,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
