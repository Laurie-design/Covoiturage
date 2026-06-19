import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'home_view.dart';

class DocumentAnalysisView extends StatelessWidget {
  final Uint8List? profileImage;
  final bool isDriver;

  const DocumentAnalysisView({super.key, this.profileImage, required this.isDriver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TransPorto',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000066),
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFFEEF2F6),
                        backgroundImage: profileImage != null
                            ? MemoryImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? const Icon(Icons.person_outline, color: Color(0xFF000066))
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      'assets/togo_flag.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(Icons.flag, color: Color(0xFF000066)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Vos documents sont en cours d\'analyse',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000066),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Nos administrateurs vérifient vos informations. Vous recevrez une notification par SMS dès que votre profil sera actif.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                _buildStatusCard(Icons.fingerprint, 'Statut Identité'),
                const SizedBox(height: 14),
                _buildStatusCard(Icons.badge_outlined, 'Statut Permis'),
                const SizedBox(height: 14),
                _buildStatusCard(
                    Icons.directions_car_filled_outlined, 'Statut Véhicule'),
                const SizedBox(height: 40),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeView(initialDriverMode: isDriver),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continuer vers l\'accueil',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
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

  Widget _buildStatusCard(IconData icon, String title) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFF1F5F9),
            child: Icon(icon, color: const Color(0xFF000066), size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFFD97706),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'En attente',
                style: TextStyle(
                  color: Color(0xFFD97706),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
