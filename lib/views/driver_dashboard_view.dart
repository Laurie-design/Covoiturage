import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_view.dart';
import 'signin_view.dart';
import 'shared_widgets.dart';
import '../services/auth_service.dart';

enum TripStatus { initial, enCours, termine }

class Trip {
  final String id;
  final String depart;
  final String arrivee;
  final DateTime date;
  final int passagers;
  final int maxPassagers;
  final int prixPassager;
  final TripStatus statut;

  Trip({
    required this.id,
    required this.depart,
    required this.arrivee,
    required this.date,
    required this.passagers,
    required this.maxPassagers,
    required this.prixPassager,
    required this.statut,
  });

  String get route => '$depart → $arrivee';

  int get gainTotal => passagers * prixPassager;
  String get statutLabel {
    switch (statut) {
      case TripStatus.initial:
        return 'En attente';
      case TripStatus.enCours:
        return 'En cours';
      case TripStatus.termine:
        return 'Terminé';
    }
  }
}

class Avis {
  final String passager;
  final String trajet;
  final double note;
  final String commentaire;
  final DateTime date;

  Avis({
    required this.passager,
    required this.trajet,
    required this.note,
    required this.commentaire,
    required this.date,
  });
}

class AppNotification {
  final String id;
  final String titre;
  final String sousTitre;
  final DateTime date;
  final Color couleur;

  AppNotification({
    required this.id,
    required this.titre,
    required this.sousTitre,
    required this.date,
    this.couleur = Colors.blue,
  });

  String get dateFormatee {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class DriverDashboardView extends StatefulWidget {
  const DriverDashboardView({super.key});

  @override
  State<DriverDashboardView> createState() => _DriverDashboardViewState();
}

class _DriverDashboardViewState extends State<DriverDashboardView> {
  TripStatus currentStatus = TripStatus.initial;
  int _selectedNavIndex = 0;
  bool _sidebarOpen = true;
  TripStatus? _filterStatus;
  DateTime? _filterDate;

  final _profileNomController = TextEditingController(text: 'Kossi');
  final _profilePrenomController = TextEditingController(text: 'Agbodifo');
  final _profileTelController = TextEditingController(text: '+228 90 00 00 00');

  final List<Trip> _trips = [
    Trip(
        id: '1',
        depart: 'Lomé',
        arrivee: 'Kara',
        date: DateTime.now().add(const Duration(hours: 2)),
        passagers: 1,
        maxPassagers: 3,
        prixPassager: 1425,
        statut: TripStatus.initial),
    Trip(
        id: '2',
        depart: 'Lomé',
        arrivee: 'Atakpamé',
        date: DateTime.now().subtract(const Duration(days: 3)),
        passagers: 3,
        maxPassagers: 3,
        prixPassager: 1900,
        statut: TripStatus.termine),
    Trip(
        id: '3',
        depart: 'Sokodé',
        arrivee: 'Kara',
        date: DateTime.now().subtract(const Duration(days: 7)),
        passagers: 2,
        maxPassagers: 4,
        prixPassager: 1100,
        statut: TripStatus.termine),
    Trip(
        id: '4',
        depart: 'Kpalimé',
        arrivee: 'Lomé',
        date: DateTime.now().subtract(const Duration(days: 14)),
        passagers: 1,
        maxPassagers: 3,
        prixPassager: 850,
        statut: TripStatus.termine),
    Trip(
        id: '5',
        depart: 'Lomé',
        arrivee: 'Kara',
        date: DateTime.now().add(const Duration(days: 5)),
        passagers: 0,
        maxPassagers: 3,
        prixPassager: 1425,
        statut: TripStatus.initial),
  ];

  final List<Avis> _avis = [
    Avis(
        passager: 'Koffi M.',
        trajet: 'Lomé → Kara',
        note: 5.0,
        commentaire: 'Super chauffeur ! Conduite douce et ponctuel.',
        date: DateTime.now().subtract(const Duration(days: 1))),
    Avis(
        passager: 'Afia S.',
        trajet: 'Lomé → Atakpamé',
        note: 4.0,
        commentaire: 'Bon trajet, mais un peu de retard au départ.',
        date: DateTime.now().subtract(const Duration(days: 3))),
    Avis(
        passager: 'Yawo A.',
        trajet: 'Sokodé → Kara',
        note: 5.0,
        commentaire: 'Véhicule propre, conducteur agréable. Je recommande !',
        date: DateTime.now().subtract(const Duration(days: 7))),
    Avis(
        passager: 'Esi K.',
        trajet: 'Kpalimé → Lomé',
        note: 4.5,
        commentaire: 'Très bon service, à l\'heure.',
        date: DateTime.now().subtract(const Duration(days: 14))),
    Avis(
        passager: 'Mensah B.',
        trajet: 'Lomé → Atakpamé',
        note: 3.5,
        commentaire: 'Trajet correct mais route difficile.',
        date: DateTime.now().subtract(const Duration(days: 21))),
  ];

  final List<AppNotification> _notifications = [
    AppNotification(
        id: '1',
        titre: 'Jean-Pierre K. (Sac à dos)',
        sousTitre: 'Nouvelle réservation confirmée',
        date: DateTime.now().subtract(const Duration(minutes: 12)),
        couleur: Colors.red),
    AppNotification(
        id: '2',
        titre: 'Ama D. (Valise)',
        sousTitre: 'Réservation annulée',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        couleur: Colors.amber),
    AppNotification(
        id: '3',
        titre: 'Koffi M.',
        sousTitre: 'Avis laissé : ★★★★★',
        date: DateTime.now().subtract(const Duration(days: 1)),
        couleur: Colors.blue),
    AppNotification(
        id: '4',
        titre: 'Support TransPorto',
        sousTitre: 'Votre profil a été vérifié avec succès',
        date: DateTime.now().subtract(const Duration(days: 3)),
        couleur: Colors.green),
    AppNotification(
        id: '5',
        titre: 'Afia S.',
        sousTitre: 'Nouvelle réservation confirmée',
        date: DateTime.now().subtract(const Duration(days: 5)),
        couleur: Colors.red),
  ];

  List<AppNotification> get _notificationsTri =>
      _notifications..sort((a, b) => b.date.compareTo(a.date));

  int get _totalGains => _trips
      .where((t) => t.statut == TripStatus.termine)
      .fold(0, (sum, t) => sum + t.gainTotal);
  int get _trajetsEffectues =>
      _trips.where((t) => t.statut == TripStatus.termine).length;
  int get _totalPassagers => _trips
      .where((t) => t.statut == TripStatus.termine)
      .fold(0, (sum, t) => sum + t.passagers);

  List<Trip> get _filteredTrips {
    return _trips.where((t) {
      if (_filterStatus != null && t.statut != _filterStatus) return false;
      if (_filterDate != null &&
          (t.date.day != _filterDate!.day ||
              t.date.month != _filterDate!.month ||
              t.date.year != _filterDate!.year)) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  void dispose() {
    _profileNomController.dispose();
    _profilePrenomController.dispose();
    _profileTelController.dispose();
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
                        )),
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
            onPressed: _showAllNotifications),
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
                      Text('Conducteur vérifié',
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
      ('Mes trajets', Icons.route_outlined, 1),
      ('Mes gains', Icons.account_balance_wallet_outlined, 2),
      ('Mes avis', Icons.star_outline, 3),
      ('Mon profil', Icons.person_outline, 4),
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
        return _buildGainsPage();
      case 3:
        return _buildAvisPage();
      case 4:
        return _buildProfilePage();
      default:
        return _buildDashboard();
    }
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

  Widget _buildDashboard() {
    final monthlyTrips = [3, 7, 5, 9, 6, _trajetsEffectues];
    final termineCount =
        _trips.where((t) => t.statut == TripStatus.termine).length;
    final attenteCount =
        _trips.where((t) => t.statut == TripStatus.initial).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Gains',
                      '$_totalGains FCFA',
                      Icons.monetization_on_outlined,
                      const Color(0xFF388E3C),
                      const Color(0xFF388E3C))),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard(
                      'Trajets',
                      '$_trajetsEffectues',
                      Icons.directions_car_outlined,
                      const Color(0xFF1976D2),
                      const Color(0xFF1976D2))),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard(
                      'Avis',
                      '${_avis.length}',
                      Icons.star_outline,
                      const Color(0xFFF57F17),
                      const Color(0xFFF57F17))),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildStatCard(
                      'Passagers',
                      '$_totalPassagers',
                      Icons.person_outline,
                      const Color(0xFF7B1FA2),
                      const Color(0xFF7B1FA2))),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildLineChartCard(monthlyTrips),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildDonutChartCard(termineCount, attenteCount),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildRecentTripsTable(),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildNotificationsPanel(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActiveTripCard(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: bgColor.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Text(title,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 28),
        ],
      ),
    );
  }

  Widget _buildLineChartCard(List<int> data) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text('Trajets',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          const Text('Janvier - Juin 2026',
              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: CustomPaint(
              size: Size.infinite,
              painter: _LineChartPainter(
                  data: data, lineColor: const Color(0xFF22C55E)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Janv', 'Fév', 'Mars', 'Avr', 'Mai', 'Juin']
                .map((m) => Text(m,
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF94A3B8))))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard(int termine, int attente) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text('Statut des trajets',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: CustomPaint(
                    size: const Size(120, 120),
                    painter: _DonutChartPainter(
                      sections: [
                        (
                          value: termine.toDouble(),
                          color: const Color(0xFF1565C0)
                        ),
                        (
                          value: attente.toDouble(),
                          color: const Color(0xFFFFC107)
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem('Terminés', const Color(0xFF1565C0), termine),
                    const SizedBox(height: 8),
                    _legendItem('En attente', const Color(0xFFFFC107), attente),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text('$label : $count',
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildRecentTripsTable() {
    final recent = _trips.take(4).toList();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text('Trajets récents',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    color: const Color(0xFFF8FAFC),
                    child: Row(
                      children:
                          ['TRAJET', 'DATE', 'PLACES', 'PRIX/PASS', 'STATUT']
                              .map((c) => Expanded(
                                    child: Text(c,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF64748B))),
                                  ))
                              .toList(),
                    ),
                  ),
                  ...List.generate(recent.length, (i) {
                    final t = recent[i];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: i < recent.length - 1
                            ? const Border(
                                bottom: BorderSide(color: Color(0xFFF1F5F9)))
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(t.route,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))),
                          Expanded(
                              child: Text(
                                  '${t.date.day}/${t.date.month}/${t.date.year}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF64748B)))),
                          Expanded(
                              child: Text('${t.passagers}/${t.maxPassagers}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF64748B)))),
                          Expanded(
                              child: Text('${t.prixPassager} FCFA',
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xFF64748B)))),
                          Expanded(
                              child: _buildMiniBadge(t.statutLabel, t.statut)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(String label, TripStatus status) {
    Color bg;
    Color txt;
    switch (status) {
      case TripStatus.initial:
        bg = const Color(0xFFDCFCE7);
        txt = Colors.green;
        break;
      case TripStatus.enCours:
        bg = const Color(0xFFFFF3E0);
        txt = const Color(0xFFE65100);
        break;
      case TripStatus.termine:
        bg = const Color(0xFFFFEBEE);
        txt = const Color(0xFFC62828);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style:
              TextStyle(color: txt, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNotificationsPanel() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notifications',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A))),
              TextButton(
                onPressed: _showAllNotifications,
                child: const Text('Voir tout',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF000066),
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(
              _notificationsTri.length > 4 ? 4 : _notificationsTri.length, (i) {
            final n = _notificationsTri[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 36,
                    decoration: BoxDecoration(
                      color: n.couleur,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.notifications_active_outlined,
                      color: Color(0xFF94A3B8), size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.titre,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color(0xFF1E293B))),
                        Text(n.sousTitre,
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  Text(n.dateFormatee,
                      style: const TextStyle(
                          fontSize: 9, color: Color(0xFFCBD5E1))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showTripDetails(dynamic trip) {
    _showBlurredDialog(
      (ctx) => Container(
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A))),
                IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(height: 24),
            _detailRow('Date',
                '${trip.date.day}/${trip.date.month}/${trip.date.year}'),
            _detailRow('Statut', trip.statutLabel),
            _detailRow(
                'Places réservées', '${trip.passagers}/${trip.maxPassagers}'),
            _detailRow('Prix par passager', '${trip.prixPassager} FCFA'),
            _detailRow('Gain total', '${trip.gainTotal} FCFA'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildActiveTripCard() {
    final activeTrip =
        _trips.where((t) => t.statut != TripStatus.termine).isNotEmpty
            ? _trips.firstWhere((t) => t.statut != TripStatus.termine)
            : null;

    if (activeTrip == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(Icons.celebration_outlined, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 8),
            const Text('Aucun trajet actif',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
          ],
        ),
      );
    }

    Color statusBg = activeTrip.statut == TripStatus.initial
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFFF3E0);
    Color statusText = activeTrip.statut == TripStatus.initial
        ? Colors.green
        : const Color(0xFFE65100);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(activeTrip.route,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B))),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: statusBg, borderRadius: BorderRadius.circular(20)),
                child: Text(activeTrip.statutLabel,
                    style: TextStyle(
                        color: statusText,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Text(
              '${activeTrip.date.day}/${activeTrip.date.month}/${activeTrip.date.year}',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                child: Text('${activeTrip.passagers}',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000066))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${activeTrip.maxPassagers} places',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    Text('Prix/Pass: ${activeTrip.prixPassager} FCFA',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              if (activeTrip.statut == TripStatus.initial)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF000066)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: _showModifyDialog,
                  icon: const Icon(Icons.edit,
                      size: 14, color: Color(0xFF000066)),
                  label: const Text('Modifier',
                      style: TextStyle(color: Color(0xFF000066), fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripsPage() {
    final totalStats = _trips.length;
    final actifCount = _trips
        .where((t) =>
            t.statut == TripStatus.initial || t.statut == TripStatus.enCours)
        .length;
    final termineCount =
        _trips.where((t) => t.statut == TripStatus.termine).length;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mes Trajets',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A))),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildFilterChip('Tous', null, totalStats),
                  const SizedBox(width: 8),
                  _buildFilterChip('Actifs', 'actif', actifCount),
                  const SizedBox(width: 8),
                  _buildFilterChip('Terminés', 'termine', termineCount),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _filterDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _filterDate = date);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Color(0xFF000066)),
                      const SizedBox(width: 8),
                      Text(
                          _filterDate != null
                              ? '${_filterDate!.day}/${_filterDate!.month}/${_filterDate!.year}'
                              : 'Filtrer par date',
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF475569))),
                      if (_filterDate != null) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => setState(() => _filterDate = null),
                          child: const Icon(Icons.close,
                              size: 16, color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredTrips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      const Text('Aucun trajet trouvé',
                          style: TextStyle(color: Color(0xFF94A3B8))),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildTable(
                    columns: const [
                      'DATE',
                      'DÉPART',
                      'ARRIVÉE',
                      'GAIN',
                      'STATUT',
                      'ACTIONS'
                    ],
                    flexes: const [2, 2, 2, 2, 2, 3],
                    rows: _filteredTrips.map((t) {
                      Color statusBg;
                      Color statusText;
                      String label;
                      switch (t.statut) {
                        case TripStatus.initial:
                          statusBg = const Color(0xFFDCFCE7);
                          statusText = Colors.green;
                          label = 'En attente';
                          break;
                        case TripStatus.enCours:
                          statusBg = const Color(0xFFFFF3E0);
                          statusText = const Color(0xFFE65100);
                          label = 'En cours';
                          break;
                        case TripStatus.termine:
                          statusBg = const Color(0xFFFFEBEE);
                          statusText = const Color(0xFFC62828);
                          label = 'Terminé';
                          break;
                      }
                      return [
                        '${t.date.day}/${t.date.month}/${t.date.year}',
                        t.depart,
                        t.arrivee,
                        '${t.gainTotal} FCFA',
                        _buildStatusBadge(label, statusBg, statusText),
                        _buildActionsRow(t),
                      ];
                    }).toList(),
                    onRowTap: _showTripDetails,
                    rowData: _filteredTrips,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String? value, int count) {
    final isSelected = (value == null && _filterStatus == null) ||
        (value == 'actif' &&
            (_filterStatus == TripStatus.initial ||
                _filterStatus == TripStatus.enCours)) ||
        (value == 'termine' && _filterStatus == TripStatus.termine);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (value == null) {
            _filterStatus = null;
          } else if (value == 'actif') {
            _filterStatus =
                _filterStatus == TripStatus.initial ? null : TripStatus.initial;
          } else if (value == 'termine') {
            _filterStatus =
                _filterStatus == TripStatus.termine ? null : TripStatus.termine;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF000066) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                )),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white24 : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('$count',
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGainsPage() {
    final tripsTermines =
        _trips.where((t) => t.statut == TripStatus.termine).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF000066), Color(0xFF0052CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Gains totaux',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 6),
                Text('$_totalGains FCFA',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${tripsTermines.length} trajets effectués',
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Détail par trajet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000066))),
          const SizedBox(height: 12),
          if (tripsTermines.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                  child: Text('Aucun gain pour le moment',
                      style: TextStyle(color: Color(0xFF94A3B8)))),
            )
          else
            _buildTable(
              columns: const ['DATE', 'TRAJET', 'PASSAGERS', 'GAIN'],
              flexes: const [2, 3, 2, 2],
              rows: tripsTermines
                  .map((t) => [
                        '${t.date.day}/${t.date.month}/${t.date.year}',
                        t.route,
                        '${t.passagers}',
                        '${t.gainTotal} FCFA',
                      ])
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildAvisPage() {
    final avgNote = _avis.isEmpty
        ? 0.0
        : _avis.fold(0.0, (sum, a) => sum + a.note) / _avis.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                      Text('${_avis.length} avis reçus',
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
          if (_avis.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                  child: Text('Aucun avis pour le moment',
                      style: TextStyle(color: Color(0xFF94A3B8)))),
            )
          else
            _buildTable(
              columns: const [
                'PASSAGER',
                'TRAJET',
                'NOTE',
                'COMMENTAIRE',
                'DATE'
              ],
              flexes: const [2, 2, 1, 3, 2],
              rows: _avis
                  .map((a) => [
                        a.passager,
                        a.trajet,
                        _buildStars(a.note),
                        a.commentaire,
                        '${a.date.day}/${a.date.month}/${a.date.year}',
                      ])
                  .toList(),
            ),
        ],
      ),
    );
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
                                : Text(
                                    '${row[cIdx]}',
                                    style: const TextStyle(
                                        fontSize: 13, color: Color(0xFF1E293B)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          )),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionsRow(Trip trip) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              side: const BorderSide(color: Color(0xFF94A3B8)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () => _showTripDetails(trip),
            child: const Text('Voir',
                style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w600)),
          ),
        ),
        if (trip.statut == TripStatus.initial) ...[
          const SizedBox(width: 4),
          SizedBox(
            height: 28,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                side: const BorderSide(color: Color(0xFF000066)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: _showModifyDialog,
              child: const Text('Modifier',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF000066),
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
        if (trip.statut == TripStatus.termine) ...[
          const SizedBox(width: 4),
          SizedBox(
            height: 28,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                side: const BorderSide(color: Color(0xFFDC2626)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
              onPressed: () {
                _showBlurredDialog(
                  (ctx) => Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Color(0xFFDC2626), size: 48),
                        const SizedBox(height: 16),
                        const Text('Supprimer le trajet',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A))),
                        const SizedBox(height: 8),
                        const Text(
                            'Êtes-vous sûr de vouloir supprimer ce trajet ? Cette action est irréversible.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF64748B))),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Annuler',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC2626),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  setState(() => _trips
                                      .removeWhere((x) => x.id == trip.id));
                                  Navigator.pop(ctx);
                                },
                                child: const Text('Supprimer',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text('Suppr.',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ],
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

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
                    Text('Profil vérifié',
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
          _buildProfileField('NOM', _profileNomController),
          const SizedBox(height: 12),
          _buildProfileField('PRENOM', _profilePrenomController),
          const SizedBox(height: 12),
          _buildProfileField('NUMÉRO DE TÉLÉPHONE', _profileTelController,
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
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text(
                        'Êtes-vous sûr de vouloir vous déconnecter ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const SignInView()),
                            (route) => false,
                          );
                        },
                        child: const Text('Se déconnecter',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Se déconnecter',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 32),
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

  void _showAllNotifications() {
    _showBlurredDialog((ctx) {
      return StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Notifications',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A))),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_notifications.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setModalState(() => _notifications.clear());
                              setState(() {});
                            },
                            child: const Text('Tout supprimer',
                                style: TextStyle(color: Colors.red)),
                          ),
                        IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(ctx)),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Flexible(
                  child: _notifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.notifications_off_outlined,
                                  size: 48, color: Colors.grey[300]),
                              const SizedBox(height: 8),
                              const Text('Aucune notification',
                                  style: TextStyle(color: Color(0xFF94A3B8))),
                            ],
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: _notificationsTri
                              .map((n) => Dismissible(
                                    key: Key(n.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                    onDismissed: (_) {
                                      setModalState(() => _notifications
                                          .removeWhere((x) => x.id == n.id));
                                      setState(() {});
                                    },
                                    child: _buildNotifItem(n),
                                  ))
                              .toList(),
                        ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildNotifItem(AppNotification n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 64,
            decoration: BoxDecoration(
              color: n.couleur,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.notifications_active_outlined,
              color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.titre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF1E293B))),
                Text(n.sousTitre,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(n.dateFormatee,
                    style: TextStyle(fontSize: 10, color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showModifyDialog() {
    int countEdit = 3;
    DateTime dateEdit = DateTime.now().add(const Duration(days: 1));
    TimeOfDay timeEdit = const TimeOfDay(hour: 8, minute: 30);

    _showBlurredDialog((ctx) {
      return StatefulBuilder(
        builder: (ctx, setDialogState) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 440),
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
                    const Text('Modifier le trajet',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Date & Heure',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569))),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: dateEdit,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) setDialogState(() => dateEdit = date);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 18, color: Color(0xFF000066)),
                        const SizedBox(width: 12),
                        Text(
                            '${dateEdit.day}/${dateEdit.month}/${dateEdit.year}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            final time = await showTimePicker(
                                context: ctx, initialTime: timeEdit);
                            if (time != null)
                              setDialogState(() => timeEdit = time);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 18, color: Color(0xFF000066)),
                              const SizedBox(width: 6),
                              Text(
                                  '${timeEdit.hour.toString().padLeft(2, '0')}:${timeEdit.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              const Icon(Icons.arrow_drop_down,
                                  color: Color(0xFF000066)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Nombre de places',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569))),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle,
                            color: Color(0xFF000066), size: 32),
                        onPressed: countEdit > 1
                            ? () => setDialogState(() => countEdit--)
                            : null,
                      ),
                      Column(
                        children: [
                          Text('$countEdit',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const Text('PASSAGERS',
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xFF9E9E9E))),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: Color(0xFF000066), size: 32),
                        onPressed: countEdit < 8
                            ? () => setDialogState(() => countEdit++)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
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
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Trajet modifié avec succès'),
                            backgroundColor: Colors.green),
                      );
                    },
                    child: const Text('Enregistrer',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    });
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> data;
  final Color lineColor;

  _LineChartPainter({required this.data, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.reduce((a, b) => a > b ? a : b).toDouble();
    final minVal = 0.0;
    final range = (maxVal - minVal).clamp(1.0, double.infinity);

    final stepX = (size.width - 20) / (data.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = 10.0 + i * stepX;
      final y =
          size.height - 10 - ((data[i] - minVal) / range) * (size.height - 20);
      points.add(Offset(x, y));
    }

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        final prev = points[i - 1];
        final curr = points[i];
        final ctrlX = (prev.dx + curr.dx) / 2;
        path.cubicTo(ctrlX, prev.dy, ctrlX, curr.dy, curr.dx, curr.dy);
      }
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(points.last.dx, size.height - 10);
    fillPath.lineTo(points.first.dx, size.height - 10);
    fillPath.close();

    final gradient = LinearGradient(
      colors: [
        lineColor.withValues(alpha: 0.2),
        lineColor.withValues(alpha: 0.0)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    canvas.drawPath(
        fillPath,
        Paint()
          ..shader = gradient
              .createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);

    for (final p in points) {
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white);
      canvas.drawCircle(p, 2.5, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => data != old.data;
}

class _DonutChartPainter extends CustomPainter {
  final List<({double value, Color color})> sections;

  _DonutChartPainter({required this.sections});

  @override
  void paint(Canvas canvas, Size size) {
    final total = sections
        .fold(0.0, (sum, s) => sum + s.value)
        .clamp(1.0, double.infinity);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -1.5708;
    for (final section in sections) {
      if (section.value <= 0) continue;
      final sweepAngle = (section.value / total) * 6.2832;
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        Paint()
          ..color = section.color
          ..style = PaintingStyle.fill,
      );
      startAngle += sweepAngle;
    }

    canvas.drawCircle(
      center,
      radius * 0.55,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter old) => false;
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
      ('Mes trajets', Icons.route_outlined, 1),
      ('Mes gains', Icons.account_balance_wallet_outlined, 2),
      ('Mes avis', Icons.star_outline, 3),
      ('Mon profil', Icons.person_outline, 4),
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
                  Text('Conducteur vérifié',
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
