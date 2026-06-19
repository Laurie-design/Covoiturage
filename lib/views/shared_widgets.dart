import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_view.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final bool isDriverMode;

  const AppHeader({super.key, this.showBack = false, this.isDriverMode = true});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ZONE GAUCHE : logo (ou bouton retour), identique à _Navbar
          showBack
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF0052CC)),
                )
              : GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                    (route) => false,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_car,
                          color: Color(0xFF0052CC), size: 32),
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
                ),

          // ZONE CENTRALE : liens, identique à _Navbar
          Row(
            children: [
              TextButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeView()),
                        (route) => false,
                      ),
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
                  onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomeView(initialDriverMode: true)),
                        (route) => false,
                      ),
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

          // ZONE DROITE : bouton publier + avatar, identique à _Navbar
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
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomeView(initialDriverMode: true)),
                  (route) => false,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Publier un trajet',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              AuthService().isLoggedIn
                  ? const ProfileAvatar(radius: 18)
                  : const CircleAvatar(
                      backgroundColor: Color(0xFFE2E8F0),
                      child: Icon(Icons.person_outline, color: Colors.black54),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 64.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TransPorto',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView()),
                      (route) => false,
                    ),
                    child: const Text('Accueil',
                        style: TextStyle(color: Color(0xFF0052CC))),
                  ),
                ],
              ),
              _FooterColumn(
                title: 'Légal',
                links: [
                  'Conditions Générales',
                  'Protection des données',
                  'Mentions légales'
                ],
              ),
              _FooterColumn(
                title: 'Aide',
                links: [
                  'Comment ça marche ?',
                  "Centre d'aide",
                  'Nous contacter'
                ],
              ),
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
                  _AppDownloadButton(
                      icon: Icons.play_arrow,
                      storeName: 'Google Play',
                      platform: 'Android App'),
                  const SizedBox(height: 12),
                  _AppDownloadButton(
                      icon: Icons.apple,
                      storeName: 'App Store',
                      platform: 'iOS App'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 24),
          const Text(
            '© 2026 TransPorto. Tous droits réservés.',
            style: TextStyle(color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton(
                onPressed: () {},
                child: Text(link,
                    style: const TextStyle(color: Color(0xFF475569))),
              ),
            )),
      ],
    );
  }
}

class _AppDownloadButton extends StatelessWidget {
  final IconData icon;
  final String storeName;
  final String platform;

  const _AppDownloadButton(
      {required this.icon, required this.storeName, required this.platform});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0F172A)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(storeName,
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              Text(platform,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF0F172A))),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final double radius;

  const ProfileAvatar({super.key, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFEEF2F6),
      child: ClipOval(
        child: auth.profileImage != null
            ? Image.memory(auth.profileImage!,
                width: radius * 2, height: radius * 2, fit: BoxFit.cover)
            : Icon(Icons.person_outline,
                size: radius * 0.9, color: const Color(0xFF000066)),
      ),
    );
  }
}
