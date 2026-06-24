import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../signin_view.dart';
import 'admin_users_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  String _currentPage = 'Dashboard';
  bool _sidebarOpen = true;

  final _pages = [
    'Dashboard',
    'Utilisateurs',
    'Documents',
    'Trajets',
    'Paiements',
    'Statistiques',
    'Rapports',
    'Paramètres',
  ];

  final _pageIcons = [
    Icons.dashboard,
    Icons.people,
    Icons.description,
    Icons.directions_car,
    Icons.payments,
    Icons.bar_chart,
    Icons.assessment,
    Icons.settings,
  ];

  String get _pageTitle {
    switch (_currentPage) {
      case 'Dashboard':
        return 'Dashboard';
      case 'Utilisateurs':
        return 'Liste des utilisateurs';
      case 'Documents':
        return 'Documents à vérifier';
      case 'Trajets':
        return 'Gestion des trajets';
      case 'Paiements':
        return 'Transactions';
      case 'Statistiques':
        return 'Statistiques';
      case 'Rapports':
        return 'Rapports';
      case 'Paramètres':
        return 'Paramètres';
      default:
        return _currentPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          Row(
            children: [
              if (!_sidebarOpen)
                GestureDetector(
                  onTap: () => setState(() => _sidebarOpen = true),
                  child: Container(
                    width: 24,
                    color: const Color(0xFF0F172A),
                    child: const Center(
                      child: Icon(Icons.chevron_right,
                          color: Colors.white60, size: 18),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: _currentPage == 'Dashboard'
                          ? _buildDashboard()
                          : _currentPage == 'Utilisateurs'
                              ? const AdminUsersView()
                              : _buildPlaceholder(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_sidebarOpen)
            GestureDetector(
              onTap: () => setState(() => _sidebarOpen = false),
              child: Container(color: Colors.black26),
            ),
          if (_sidebarOpen)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: _buildSidebar(),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.directions_car, color: Color(0xFF0052CC), size: 24),
          const SizedBox(width: 8),
          Text(
            _pageTitle,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF475569)),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF0052CC),
              radius: 18,
              child: Text(
                AuthService().firstName.isNotEmpty
                    ? AuthService().firstName[0].toUpperCase()
                    : 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      color: const Color(0xFF0F172A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white60, size: 22),
                  onPressed: () => setState(() => _sidebarOpen = false),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.directions_car, color: Colors.white, size: 28),
                const SizedBox(width: 10),
                const Text(
                  'TransPorto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 16),
            child: Text(
              'Administration',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _pages.length,
              itemBuilder: (ctx, i) {
                final isActive = _currentPage == _pages[i];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      _pageIcons[i],
                      color: isActive ? Colors.white : Colors.white60,
                      size: 22,
                    ),
                    title: Text(
                      _pages[i],
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.white60,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () => setState(() => _currentPage = _pages[i]),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          ListTile(
            dense: true,
            leading:
                const Icon(Icons.logout, color: Colors.redAccent, size: 22),
            title: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.redAccent, fontSize: 15),
            ),
            onTap: () {
              AuthService().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const SignInView()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                icon: Icons.people,
                label: 'Utilisateurs',
                value: '1 240',
                bgColor: const Color(0xFF0052CC),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                icon: Icons.directions_car,
                label: 'Trajets',
                value: '342',
                bgColor: const Color(0xFF059669),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                icon: Icons.account_balance_wallet,
                label: 'Revenus total',
                value: '4,5M',
                bgColor: const Color(0xFFD97706),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                icon: Icons.pending_actions,
                label: 'Docs en attente',
                value: '14',
                bgColor: const Color(0xFFDC2626),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                icon: Icons.person_pin,
                label: 'Conducteurs actifs',
                value: '156',
                bgColor: const Color(0xFF7C3AED),
              )),
            ],
          ),
          const SizedBox(height: 24),

          // Charts row
          Row(
            children: [
              Expanded(
                  child: _ChartCard(
                title: 'INSCRIPTIONS RÉCENTES',
                type: ChartType.line,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: _ChartCard(
                title: 'TRAJETS (30j)',
                type: ChartType.donut,
              )),
            ],
          ),
          const SizedBox(height: 24),

          // Activity + Documents
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _ActivityCard()),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _PendingDocumentsCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_pageIcons[_pages.indexOf(_currentPage)],
              size: 64, color: const Color(0xFF94A3B8)),
          const SizedBox(height: 16),
          Text(
            _currentPage,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Page en cours de développement',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color bgColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
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
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Text(label,
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
}

enum ChartType { line, donut }

class _ChartCard extends StatelessWidget {
  final String title;
  final ChartType type;

  const _ChartCard({required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B))),
          const SizedBox(height: 20),
          type == ChartType.line ? _BarChart() : _DonutChart(),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  static const _data = [
    {'day': 'Lun', 'count': 8},
    {'day': 'Mar', 'count': 12},
    {'day': 'Mer', 'count': 5},
    {'day': 'Jeu', 'count': 15},
    {'day': 'Ven', 'count': 10},
    {'day': 'Sam', 'count': 7},
    {'day': 'Dim', 'count': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nouvelles inscriptions cette semaine',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _data
              .map((d) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Text('${d['count']}',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A))),
                          const SizedBox(height: 6),
                          Container(
                            height: (d['count'] as int) * 8.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0052CC),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(d['day'] as String,
                              style: const TextStyle(
                                  fontSize: 10, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _DonutChart extends StatefulWidget {
  @override
  State<_DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<_DonutChart> {
  static const _legend = [
    {
      'label': 'Koffi A.',
      'color': Color(0xFF0052CC),
      'pct': '45%',
      'trips': 154
    },
    {'label': 'Yawa B.', 'color': Color(0xFF059669), 'pct': '25%', 'trips': 86},
    {
      'label': 'Komlan S.',
      'color': Color(0xFFD97706),
      'pct': '18%',
      'trips': 62
    },
    {'label': 'Afi T.', 'color': Color(0xFFDC2626), 'pct': '12%', 'trips': 40},
  ];

  void _showDetail(int i) {
    final l = _legend[i];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: l['color'] as Color,
                  borderRadius: BorderRadius.circular(3),
                )),
            const SizedBox(width: 10),
            Text(l['label'] as String),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _detailRow('Trajets', '${l['trips']}'),
            _detailRow('Pourcentage', l['pct'] as String),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Fermer')),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 140,
            height: 140,
            child: CustomPaint(
              size: const Size(140, 140),
              painter: const _DonutChartPainter(),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('342',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A))),
                    Text('trajets',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_legend.length, (i) {
          final l = _legend[i];
          return GestureDetector(
            onTap: () => _showDetail(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: l['color'] as Color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(l['label'] as String,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF475569))),
                  const Spacer(),
                  Text(l['pct'] as String,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A))),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter();

  static const _segments = [
    (color: Color(0xFF0052CC), ratio: 0.45),
    (color: Color(0xFF059669), ratio: 0.25),
    (color: Color(0xFFD97706), ratio: 0.18),
    (color: Color(0xFFDC2626), ratio: 0.12),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -1.5708;
    for (int i = 0; i < _segments.length; i++) {
      final seg = _segments[i];
      final sweepAngle = seg.ratio * 6.2832;
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        Paint()
          ..color = seg.color
          ..style = PaintingStyle.fill,
      );
      startAngle += sweepAngle;
    }

    canvas.drawCircle(center, radius * 0.6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActivityCard extends StatelessWidget {
  final _activities = const [
    {
      'icon': Icons.upload_file,
      'text': "Koffi A. a soumis sa CNI",
      'time': 'il y a 2min',
      'color': Color(0xFF0052CC)
    },
    {
      'icon': Icons.directions_car,
      'text': "Trajet Lomé→Kara créé",
      'time': 'il y a 15min',
      'color': Color(0xFF059669)
    },
    {
      'icon': Icons.payments,
      'text': "Paiement 12 000 FCFA",
      'time': 'il y a 1h',
      'color': Color(0xFFD97706)
    },
    {
      'icon': Icons.person_add,
      'text': "Nouveau compte: Ama D.",
      'time': 'il y a 2h',
      'color': Color(0xFF0052CC)
    },
    {
      'icon': Icons.verified,
      'text': "Permis de Yovo K. validé",
      'time': 'il y a 3h',
      'color': Color(0xFF059669)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Activité récente',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          ...List.generate(_activities.length, (i) {
            final a = _activities[i];
            return Padding(
              padding:
                  EdgeInsets.only(bottom: i < _activities.length - 1 ? 16 : 0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: (a['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(a['icon'] as IconData,
                        color: a['color'] as Color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a['text'] as String,
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFF1E293B))),
                        Text(a['time'] as String,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PendingDocumentsCard extends StatelessWidget {
  final _docs = const [
    {'name': 'Koffi A.', 'type': 'CNI'},
    {'name': 'Yawa B.', 'type': 'Permis'},
    {'name': 'Komlan S.', 'type': 'Carte grise'},
    {'name': 'Afi T.', 'type': 'Assurance'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Documents en attente',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          ...List.generate(_docs.length, (i) {
            final d = _docs[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i < _docs.length - 1 ? 12 : 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d['name'] as String,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1E293B))),
                        Text('→ ${d['type']}',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      backgroundColor: const Color(0xFFE8F0FE),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {},
                    child: const Text('Voir',
                        style: TextStyle(
                            color: Color(0xFF0052CC),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
