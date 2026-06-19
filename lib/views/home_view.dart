import 'package:flutter/material.dart';
import 'register_view.dart';
import 'signin_view.dart';
import 'trip_results_screen.dart';
import 'passenger_dashboard_view.dart';
import 'driver_dashboard_view.dart';
import 'shared_widgets.dart';
import '../services/auth_service.dart';
import '../utils/trip_guard.dart';

class HomeView extends StatefulWidget {
  final bool initialDriverMode;

  const HomeView({super.key, this.initialDriverMode = false});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late bool _isDriverMode;

  @override
  void initState() {
    super.initState();
    _isDriverMode = widget.initialDriverMode;
  }

  final _scrollController = ScrollController();
  final _heroSectionKey = GlobalKey<_HeroSectionState>();
  String? _routeDeparture;
  String? _routeArrival;

  void _navigateToRoute(String label) {
    final parts = label.split(' ➔ ');
    if (parts.length == 2) {
      setState(() {
        _routeDeparture = parts[0];
        _routeArrival = parts[1];
        _isDriverMode = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. BARRE DE NAVIGATION FIXE (HEADER)
          _Navbar(
            onDriverTap: () => setState(() => _isDriverMode = true),
            onPassengerTap: () => setState(() => _isDriverMode = false),
            onMenuAction: () => setState(() {}),
            isDriverMode: _isDriverMode,
          ),

          // 2. CONTENU SCROLLABLE
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // SECTION HERO
                  _isDriverMode
                      ? const _DriverHeroSection()
                      : _HeroSection(
                          key: _heroSectionKey,
                          initialDeparture: _routeDeparture,
                          initialArrival: _routeArrival,
                        ),

                  // DESTINATIONS TENDANCES
                  const _TrendingDestinations(),

                  // COMMENT ÇA MARCHE ? / COMMENT DEVENIR CHAUFFEUR ?
                  _isDriverMode
                      ? const _DriverProcessSection()
                      : const _HowItWorksSection(),

                  // AVANTAGES
                  const _FeaturesSection(),

                  // FOOTER
                  _FooterSection(onRouteTap: _navigateToRoute),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Navbar extends StatelessWidget {
  final VoidCallback onDriverTap;
  final VoidCallback onPassengerTap;
  final VoidCallback onMenuAction;
  final bool isDriverMode;

  const _Navbar({
    required this.onDriverTap,
    required this.onPassengerTap,
    required this.onMenuAction,
    required this.isDriverMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          const Row(
            children: [
              Icon(Icons.directions_car, color: Color(0xFF0052CC), size: 32),
              SizedBox(width: 8),
              Text(
                'TransPorto',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0052CC)),
              ),
            ],
          ),
          // Liens du milieu
          Row(
            children: [
              TextButton(
                  onPressed: onPassengerTap,
                  child: Text('Trouver un trajet',
                      style: TextStyle(
                          fontWeight: isDriverMode
                              ? FontWeight.normal
                              : FontWeight.bold,
                          color: isDriverMode
                              ? Colors.black54
                              : const Color(0xFF0052CC)))),
              const SizedBox(width: 20),
              TextButton(
                  onPressed: onDriverTap,
                  child: Text('Je suis chauffeur',
                      style: TextStyle(
                          fontWeight: isDriverMode
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isDriverMode
                              ? const Color(0xFF0052CC)
                              : Colors.black87))),
            ],
          ),
          // Bouton Publier & Profil
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: () => TripGuard.checkAuthAndNavigate(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Publier un trajet',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              PopupMenuButton<String>(
                offset: const Offset(0, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                onSelected: (value) {
                  if (value == 'register') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                    );
                  } else if (value == 'signin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInView()),
                    );
                  } else if (value == 'dashboard') {
                    final a = AuthService();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => a.isDriver
                            ? const DriverDashboardView()
                            : const PassengerDashboardView(),
                      ),
                    );
                  } else if (value == 'logout') {
                    AuthService().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInView()),
                      (route) => false,
                    );
                  }
                },
                itemBuilder: (context) {
                  final auth = AuthService();
                  if (!auth.isLoggedIn) {
                    return [
                      const PopupMenuItem(
                        value: 'register',
                        child: Row(
                          children: [
                            Icon(Icons.person_add_outlined,
                                color: Color(0xFF0052CC), size: 20),
                            SizedBox(width: 12),
                            Text("S'inscrire"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'signin',
                        child: Row(
                          children: [
                            Icon(Icons.login,
                                color: Color(0xFF0052CC), size: 20),
                            SizedBox(width: 12),
                            Text('Se connecter'),
                          ],
                        ),
                      ),
                    ];
                  }
                  return [
                    PopupMenuItem(
                      value: 'dashboard',
                      child: Row(
                        children: [
                          const Icon(Icons.dashboard_outlined,
                              color: Color(0xFF0052CC), size: 20),
                          const SizedBox(width: 12),
                          Text(auth.isDriver
                              ? 'Mon tableau de bord'
                              : 'Mes réservations'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              color: Color(0xFFDC2626), size: 20),
                          SizedBox(width: 12),
                          Text('Déconnexion',
                              style: TextStyle(color: Color(0xFFDC2626))),
                        ],
                      ),
                    ),
                  ];
                },
                child: AuthService().isLoggedIn
                    ? const ProfileAvatar(radius: 18)
                    : const CircleAvatar(
                        backgroundColor: Color(0xFFE2E8F0),
                        child:
                            Icon(Icons.person_outline, color: Colors.black54),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriverProcessSection extends StatelessWidget {
  const _DriverProcessSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
      child: Column(
        children: [
          const Text(
            'Comment devenir chauffeur ?',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 48),
          Row(
            children: const [
              Expanded(
                child: _DriverStepCard(
                  number: '1',
                  icon: Icons.upload_file,
                  title: 'Déposez vos documents',
                  description:
                      'Téléchargez votre permis de conduire, carte grise et pièce d\'identité.',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _DriverStepCard(
                  number: '2',
                  icon: Icons.verified_user,
                  title: 'Vérification',
                  description:
                      'Nous vérifions vos documents sous 24h pour garantir votre fiabilité.',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _DriverStepCard(
                  number: '3',
                  icon: Icons.directions_car,
                  title: 'Publiez un trajet',
                  description:
                      'Proposez vos trajets et fixez vos prix en toute simplicité.',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _DriverStepCard(
                  number: '4',
                  icon: Icons.account_balance_wallet,
                  title: 'Recevez le paiement',
                  description:
                      'Les passagers réservent, vous conduisez et le paiement vous est reversé.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriverStepCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const _DriverStepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF0052CC),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Icon(icon, color: const Color(0xFF0052CC), size: 28),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13, color: Colors.black54, height: 1.4)),
        ],
      ),
    );
  }
}

class _DriverHeroSection extends StatelessWidget {
  const _DriverHeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 64.0),
      child: Column(
        children: [
          const Text(
            'Rentabilisez vos trajets\ndu quotidien.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                height: 1.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'Le covoiturage simple, rapide et sécurisé\npartout au Togo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 48),
          _GainsCalculatorCard(),
        ],
      ),
    );
  }
}

class _GainsCalculatorCard extends StatefulWidget {
  @override
  State<_GainsCalculatorCard> createState() => _GainsCalculatorCardState();
}

class _GainsCalculatorCardState extends State<_GainsCalculatorCard> {
  final _departController = TextEditingController();
  final _arriveeController = TextEditingController();

  @override
  void dispose() {
    _departController.dispose();
    _arriveeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calculez vos gains',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _departController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.my_location, color: Color(0xFF0052CC)),
                labelText: 'Départ',
                hintText: 'Ville de départ',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                labelStyle: TextStyle(
                    color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _arriveeController,
              decoration: const InputDecoration(
                prefixIcon:
                    Icon(Icons.location_on_outlined, color: Color(0xFF0052CC)),
                labelText: 'Arrivée',
                hintText: "Ville d'arrivée",
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                labelStyle: TextStyle(
                    color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text.rich(
              TextSpan(
                text: 'Économisez jusqu\'à ',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                children: [
                  TextSpan(
                    text: '15 000 FCFA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0052CC),
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: ' sur un voyage',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () => TripGuard.checkAuthAndNavigate(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Publier un trajet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatefulWidget {
  final String? initialDeparture;
  final String? initialArrival;

  const _HeroSection({super.key, this.initialDeparture, this.initialArrival});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  int _passengerCount = 1;
  bool _bagageSac = false;
  bool _bagageValise = true;
  final _tileKey = GlobalKey();
  OverlayEntry? _passengerOverlay;
  late String _departure;
  late String _arrival;
  DateTime _tripDate = DateTime.now();

  String get _formattedDate {
    if (_tripDate.day == DateTime.now().day &&
        _tripDate.month == DateTime.now().month &&
        _tripDate.year == DateTime.now().year) {
      return "Aujourd'hui";
    }
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (_tripDate.day == tomorrow.day &&
        _tripDate.month == tomorrow.month &&
        _tripDate.year == tomorrow.year) {
      return 'Demain';
    }
    return '${_tripDate.day}/${_tripDate.month}/${_tripDate.year}';
  }

  final _cities = [
    'Lomé',
    'Kara',
    'Atakpamé',
    'Sokodé',
    'Kpalimé',
    'Aneho',
    'Dapaong',
    'Tsévié'
  ];

  void _showCityPicker(void Function(String) onSelected, String current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final controller = TextEditingController(text: current);
        final filtered = ValueNotifier<List<String>>(_cities);
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Choisir une ville',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Rechercher',
                  prefixIcon: Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (v) {
                  filtered.value = _cities
                      .where((c) => c.toLowerCase().contains(v.toLowerCase()))
                      .toList();
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ValueListenableBuilder<List<String>>(
                  valueListenable: filtered,
                  builder: (ctx, list, _) => ListView(
                    children: list
                        .map((c) => ListTile(
                              dense: true,
                              title: Text(c),
                              selected: c == current,
                              selectedTileColor: const Color(0xFF000066)
                                  .withValues(alpha: 0.06),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onTap: () {
                                onSelected(c);
                                Navigator.pop(ctx);
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchWithGuard() {
    if (_departure.isEmpty || _arrival.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Veuillez sélectionner une ville de départ et une destination'),
          backgroundColor: Color(0xFFC62828),
        ),
      );
      return;
    }
    _goToResults();
  }

  void _goToResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripResultsScreen(
          departure: _departure.isEmpty ? null : _departure,
          arrival: _arrival.isEmpty ? null : _arrival,
          passengerCount: _passengerCount,
          tripDate: _tripDate,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _departure = widget.initialDeparture ?? '';
    _arrival = widget.initialArrival ?? '';
  }

  @override
  void didUpdateWidget(_HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDeparture != oldWidget.initialDeparture) {
      _departure = widget.initialDeparture ?? '';
    }
    if (widget.initialArrival != oldWidget.initialArrival) {
      _arrival = widget.initialArrival ?? '';
    }
  }

  void _showPassengerConfig() {
    if (_passengerOverlay != null) {
      _passengerOverlay!.remove();
      _passengerOverlay = null;
      return;
    }

    final renderBox = _tileKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final tilePos = renderBox.localToGlobal(Offset.zero);
    final tileSize = renderBox.size;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                entry.remove();
                _passengerOverlay = null;
              },
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: tilePos.dx - 100,
              top: tilePos.dy + tileSize.height + 4,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: _PassengerCard(
                  passengerCount: _passengerCount,
                  bagageSac: _bagageSac,
                  bagageValise: _bagageValise,
                  onChanged: (count, sac, valise) {
                    setState(() {
                      _passengerCount = count;
                      _bagageSac = sac;
                      _bagageValise = valise;
                    });
                  },
                  onDone: () {
                    entry.remove();
                    _passengerOverlay = null;
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    _passengerOverlay = entry;
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 64.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Partagez la route,\nréduisez vos frais.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                height: 1.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'Le covoiturage simple, rapide et sécurisé partout au Togo.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 48),

          // La fameuse barre de recherche horizontale de ta maquette
          Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20)
              ],
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                    child: ListTile(
                        leading: const Icon(Icons.my_location),
                        onTap: () => _showCityPicker(
                            (value) => setState(() => _departure = value),
                            _departure),
                        title: Text(
                            _departure.isEmpty
                                ? 'D\'où partez-vous ?'
                                : _departure,
                            style: TextStyle(
                                color: _departure.isEmpty
                                    ? Colors.grey
                                    : Colors.black87,
                                fontSize: 14)))),
                Container(width: 1, height: 30, color: Colors.grey[300]),
                Expanded(
                    child: ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        onTap: () => _showCityPicker(
                            (value) => setState(() => _arrival = value),
                            _arrival),
                        title: Text(
                            _arrival.isEmpty ? 'Où allez-vous ?' : _arrival,
                            style: TextStyle(
                                color: _arrival.isEmpty
                                    ? Colors.grey
                                    : Colors.black87,
                                fontSize: 14)))),
                Container(width: 1, height: 30, color: Colors.grey[300]),
                Expanded(
                    child: ListTile(
                        leading: const Icon(Icons.calendar_month_outlined),
                        title: Text(_formattedDate,
                            style: TextStyle(
                                color: const Color(0xFF0F172A), fontSize: 14)),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _tripDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) setState(() => _tripDate = date);
                        })),
                Container(width: 1, height: 30, color: Colors.grey[300]),
                Expanded(
                  key: _tileKey,
                  child: ListTile(
                    leading: const Icon(Icons.group_outlined),
                    title: Text(
                        "$_passengerCount passager${_passengerCount > 1 ? 's' : ''}",
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 14)),
                    onTap: _showPassengerConfig,
                  ),
                ),

                // Bouton Loupe Bleu
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF0052CC),
                  child: IconButton(
                      onPressed: _searchWithGuard,
                      icon: const Icon(Icons.search, color: Colors.white)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PassengerCard extends StatefulWidget {
  final int passengerCount;
  final bool bagageSac;
  final bool bagageValise;
  final void Function(int count, bool sac, bool valise) onChanged;
  final VoidCallback onDone;

  const _PassengerCard({
    required this.passengerCount,
    required this.bagageSac,
    required this.bagageValise,
    required this.onChanged,
    required this.onDone,
  });

  @override
  State<_PassengerCard> createState() => _PassengerCardState();
}

class _PassengerCardState extends State<_PassengerCard> {
  late int _count;
  late bool _sac;
  late bool _valise;

  @override
  void initState() {
    super.initState();
    _count = widget.passengerCount;
    _sac = widget.bagageSac;
    _valise = widget.bagageValise;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Nombre de places",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _count > 1 ? () => setState(() => _count--) : null,
                icon: Icon(Icons.remove_circle_outline,
                    color: _count > 1 ? const Color(0xFF0052CC) : Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("$_count",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A))),
              ),
              IconButton(
                onPressed: _count < 4 ? () => setState(() => _count++) : null,
                icon: Icon(Icons.add_circle_outline,
                    color: _count < 4 ? const Color(0xFF0052CC) : Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Bagages volumineux ?",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _BaggageOption(
                  icon: Icons.backpack,
                  label: "Sac",
                  selected: _sac,
                  onTap: () => setState(() {
                    _sac = true;
                    _valise = false;
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BaggageOption(
                  icon: Icons.luggage,
                  label: "Valise",
                  selected: _valise,
                  onTap: () => setState(() {
                    _valise = true;
                    _sac = false;
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () {
                widget.onChanged(_count, _sac, _valise);
                widget.onDone();
              },
              child: const Text("Terminé",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaggageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BaggageOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF0052CC) : const Color(0xFFE2E8F0),
            width: selected ? 2 : 1,
          ),
          color: selected
              ? const Color(0xFF0052CC).withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: selected ? const Color(0xFF0052CC) : Colors.grey,
                size: 22),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: selected ? const Color(0xFF0052CC) : Colors.grey,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _TrendingDestinations extends StatelessWidget {
  const _TrendingDestinations();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Destinations tendances cette semaine',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(
                  child: _DestinationCard(
                      from: 'Lomé',
                      to: 'Atakpamé',
                      price: '2 500 F',
                      imageUrl: 'assets/atakpame.png')),
              SizedBox(width: 20),
              Expanded(
                  child: _DestinationCard(
                      from: 'Lomé',
                      to: 'Kpalimé',
                      price: '1 800 F',
                      imageUrl: 'assets/kpalime.png')),
              SizedBox(width: 20),
              Expanded(
                  child: _DestinationCard(
                      from: 'Lomé',
                      to: 'Kara',
                      price: '6 000 F',
                      imageUrl: 'assets/kara.png')),
              SizedBox(width: 20),
              Expanded(
                  child: _DestinationCard(
                      from: 'Lomé',
                      to: 'Aneho',
                      price: '1 000 F',
                      imageUrl: 'assets/aneho.png')),
            ],
          ),
        ],
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String from;
  final String to;
  final String price;
  final String imageUrl;

  const _DestinationCard({
    required this.from,
    required this.to,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            imageUrl,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
                height: 220,
                color: const Color(0xFFE2E8F0),
                child: const Icon(Icons.image, color: Color(0xFF9E9E9E))),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$from ➔ $to',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                    overflow: TextOverflow.ellipsis),
                Text(price,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0052CC))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 64),
      child: Column(
        children: [
          const Text(
            'Comment ça marche ?',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 48),
          Row(
            children: const [
              Expanded(
                child: _StepCard(
                  number: '1',
                  icon: Icons.search,
                  title: 'Trouvez un trajet',
                  description:
                      'Consultez les annonces de covoiturage et trouvez le trajet qui vous arrange.',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _StepCard(
                  number: '2',
                  icon: Icons.book_online,
                  title: 'Réservez votre place',
                  description:
                      'Choisissez votre siège et payez en toute sécurité via T-Money ou Flooz.',
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: _StepCard(
                  number: '3',
                  icon: Icons.directions_car,
                  title: 'Voyagez ensemble',
                  description:
                      'Retrouvez votre conducteur au point de rendez-vous et profitez du trajet.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF0052CC),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Icon(icon, color: const Color(0xFF0052CC), size: 32),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black54, height: 1.5)),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0F172A), // Bleu nuit très sombre (Slate 900)
      padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 64.0),
      child: Column(
        children: [
          const Text(
            'Voyagez l\'esprit tranquille',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),

          // Grille des 3 piliers de confiance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: _FeatureItem(
                  icon: Icons.verified_user_outlined,
                  title: 'Profils vérifiés',
                  description:
                      'Nous vérifions les pièces d\'identité et les avis pour chaque membre.',
                ),
              ),
              Expanded(
                child: _FeatureItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Paiement Mobile Sécurisé',
                  description:
                      'T-Money et Flooz acceptés pour une transaction sans souci.',
                ),
              ),
              Expanded(
                child: _FeatureItem(
                  icon: Icons.support_agent_outlined,
                  title: 'Support 7j/7',
                  description:
                      'Notre équipe togolaise est disponible pour vous accompagner à tout moment.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Petit composant interne pour chaque colonne d'avantage
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Cercle autour de l'icône
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue[400], size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: Colors.blueGrey[400], height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final void Function(String label) onRouteTap;

  const _FooterSection({required this.onRouteTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC), // Fond clair du footer
      padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 64.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colonne 1 : Trouver nos options de trajet
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trouver nos options de trajet',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 16),
                  _RouteLink(
                      label: 'Lomé ➔ Atakpamé',
                      onTap: () => onRouteTap('Lomé ➔ Atakpamé')),
                  _RouteLink(
                      label: 'Lomé ➔ Kpalimé',
                      onTap: () => onRouteTap('Lomé ➔ Kpalimé')),
                  _RouteLink(
                      label: 'Lomé ➔ Kara',
                      onTap: () => onRouteTap('Lomé ➔ Kara')),
                  _RouteLink(
                      label: 'Lomé ➔ Sokodé',
                      onTap: () => onRouteTap('Lomé ➔ Sokodé')),
                  _RouteLink(
                      label: 'Lomé ➔ Aneho',
                      onTap: () => onRouteTap('Lomé ➔ Aneho')),
                  _RouteLink(
                      label: 'Lomé ➔ Dapaong',
                      onTap: () => onRouteTap('Lomé ➔ Dapaong')),
                ],
              ),
              // Colonne 2 : Légal
              _FooterColumn(
                title: 'Légal',
                links: [
                  'Conditions Générales',
                  'Protection des données',
                  'Mentions légales'
                ],
              ),
              // Colonne 3 : Aide
              _FooterColumn(
                title: 'Aide',
                links: [
                  'Comment ça marche ?',
                  'Centre d\'aide',
                  'Nous contacter'
                ],
              ),
              // Colonne 4 : Application & Téléchargements
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 16),

                  // Bouton Android (Simulé)
                  _AppDownloadButton(
                    icon: Icons.play_arrow,
                    storeName: 'Google Play',
                    platform: 'Android App',
                  ),
                  const SizedBox(height: 12),

                  // Bouton iOS (Simulé)
                  _AppDownloadButton(
                    icon: Icons.apple,
                    storeName: 'App Store',
                    platform: 'iOS App',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 24),

          // Ligne des droits d'auteur et icônes de partage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TransPorto, ${DateTime.now().year} ©',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.language,
                          color: Colors.grey, size: 20)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share,
                          color: Colors.grey, size: 20)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

// Widget pour un lien de route dans le footer
class _RouteLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RouteLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Text(label,
            style: const TextStyle(color: Colors.black54, fontSize: 14)),
      ),
    );
  }
}

// Widget réutilisable pour les listes de liens du footer
class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A))),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () {},
                child: Text(link,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 14)),
              ),
            )),
      ],
    );
  }
}

// Widget pour simuler un beau bouton de téléchargement de store
class _AppDownloadButton extends StatelessWidget {
  final IconData icon;
  final String storeName;
  final String platform;

  const _AppDownloadButton(
      {required this.icon, required this.storeName, required this.platform});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(platform,
                  style: const TextStyle(color: Colors.grey, fontSize: 10)),
              Text(storeName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
