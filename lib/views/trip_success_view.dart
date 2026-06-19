import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'driver_dashboard_view.dart';
import 'shared_widgets.dart';

class TripSuccessView extends StatelessWidget {
  final String origin;
  final String destination;
  final String dateFormatted;
  final int passengerCount;
  final int pricePerPassenger;

  const TripSuccessView({
    super.key,
    required this.origin,
    required this.destination,
    required this.dateFormatted,
    required this.passengerCount,
    required this.pricePerPassenger,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // HEADER EN PLEINE LARGEUR (hors de la carte, comme dans home_view.dart)
          const AppHeader(isDriverMode: true),

          // CONTENU SCROLLABLE, centré uniquement à l'intérieur de cette zone
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 420),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 24),
                            Container(
                              height: 180,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(32)),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ...List.generate(8, (index) {
                                    final positions = [
                                      const Offset(-70, -50),
                                      const Offset(80, -40),
                                      const Offset(-90, 30),
                                      const Offset(85, 40),
                                      const Offset(-40, 60),
                                      const Offset(50, -65),
                                      const Offset(-20, -70),
                                      const Offset(30, 55),
                                    ];
                                    final sizes = [
                                      3.0,
                                      5.0,
                                      4.0,
                                      6.0,
                                      3.5,
                                      4.5,
                                      5.5,
                                      3.0
                                    ];
                                    final colors = [
                                      const Color(0xFF4ADE80),
                                      const Color(0xFF60A5FA),
                                      const Color(0xFF4ADE80),
                                      const Color(0xFFF59E0B),
                                      const Color(0xFF60A5FA),
                                      const Color(0xFF4ADE80),
                                      const Color(0xFFF59E0B),
                                      const Color(0xFF60A5FA),
                                    ];
                                    return Transform.translate(
                                      offset: positions[index],
                                      child: Container(
                                        width: sizes[index],
                                        height: sizes[index],
                                        decoration: BoxDecoration(
                                          color: colors[index]
                                              .withValues(alpha: 0.6),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  }),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF000066),
                                          Color(0xFF0052CC)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF000066)
                                              .withValues(alpha: 0.25),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 52,
                                    ),
                                  ),
                                  Positioned(
                                    right: 60,
                                    bottom: 25,
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4ADE80),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF4ADE80)
                                                .withValues(alpha: 0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.star,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                  Positioned(
                                    left: 55,
                                    top: 25,
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF59E0B),
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFF59E0B)
                                                .withValues(alpha: 0.4),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.auto_awesome,
                                          color: Colors.white, size: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'Votre trajet de $origin à $destination\nest en ligne !',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000066),
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    _buildSummaryRow(Icons.location_on,
                                        'ORIGINE', 'Départ de $origin'),
                                    const SizedBox(height: 14),
                                    _buildSummaryRow(Icons.calendar_today,
                                        'DATE & HEURE', dateFormatted),
                                    const SizedBox(height: 14),
                                    _buildSummaryRow(
                                        Icons.directions_car,
                                        'DISPONIBILITÉ',
                                        '$passengerCount places disponibles'),
                                    const SizedBox(height: 14),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              size: 18,
                                              color: Color(0xFF000066)),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text('Prix par',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF9E9E9E),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text('Passager',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF9E9E9E),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '$pricePerPassenger FCFA',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF1B5E20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF000066),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DriverDashboardView()),
                                          (route) => false,
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.rocket_launch_outlined,
                                          size: 18),
                                      label: const Text(
                                          'Voir mon tableau de bord',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE2E8F0),
                                        foregroundColor:
                                            const Color(0xFF334155),
                                        side: BorderSide.none,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                      onPressed: () async {
                                        final message = Uri.encodeComponent(
                                            '🚗 *TransPorto - Trajet disponible !*\n\n'
                                            '📍 De *$origin* à *$destination*\n'
                                            '📅 $dateFormatted\n'
                                            '👥 $passengerCount places disponibles\n'
                                            '💰 $pricePerPassenger FCFA par passager\n\n'
                                            'Réservez vite sur TransPorto !');
                                        final url = Uri.parse(
                                            'https://wa.me/?text=$message');
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        }
                                      },
                                      icon: const Icon(Icons.share_outlined,
                                          size: 18),
                                      label: const Text(
                                          'WhatsApp: Partager le trajet',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, right: 24.0, bottom: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.stars,
                                      color: Color(0xFF1B5E20), size: 16),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Les passagers peuvent maintenant réserver leur place.',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF475569),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const AppFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF22C55E)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
          ],
        ),
      ],
    );
  }
}
