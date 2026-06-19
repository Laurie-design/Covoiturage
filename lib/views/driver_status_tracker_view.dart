import 'package:flutter/material.dart';
import 'home_view.dart';
import 'publish_trip_view.dart';
import 'driver_license_view.dart';
import 'identity_verification_view.dart';
import '../services/auth_service.dart';
import 'shared_widgets.dart';

enum DocumentStatus { pending, approved, rejected }

class DriverStatusTrackerView extends StatefulWidget {
  final bool isDriver;
  final Widget Function(BuildContext)? redirectBuilder;

  const DriverStatusTrackerView({
    super.key,
    required this.isDriver,
    this.redirectBuilder,
  });

  @override
  State<DriverStatusTrackerView> createState() =>
      _DriverStatusTrackerViewState();
}

class _DriverStatusTrackerViewState extends State<DriverStatusTrackerView> {
  late DocumentStatus _cniStatus;
  late DocumentStatus _permisStatus;
  late DocumentStatus _vehicleStatus;

  final String _rejectionReason =
      "La photo de votre permis de conduire est trop floue.";

  bool get _hasRejection =>
      _cniStatus == DocumentStatus.rejected ||
      (widget.isDriver && _permisStatus == DocumentStatus.rejected) ||
      (widget.isDriver && _vehicleStatus == DocumentStatus.rejected);

  bool get _allPending {
    if (widget.isDriver) {
      return _cniStatus == DocumentStatus.pending &&
          _permisStatus == DocumentStatus.pending &&
          _vehicleStatus == DocumentStatus.pending;
    }
    return _cniStatus == DocumentStatus.pending;
  }

  @override
  void initState() {
    super.initState();
    _syncFromAuth();
    if (_allPending) {
      Future.delayed(const Duration(seconds: 4), _autoApprove);
    } else if (widget.redirectBuilder != null) {
      Future.delayed(const Duration(milliseconds: 100), _goToRedirect);
    }
  }

  void _goToRedirect() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget.redirectBuilder!(context)),
      (route) => false,
    );
  }

  void _syncFromAuth() {
    final auth = AuthService();
    _cniStatus = auth.identityVerified ? DocumentStatus.approved : DocumentStatus.pending;
    _permisStatus = auth.licenseVerified ? DocumentStatus.approved : DocumentStatus.pending;
    _vehicleStatus = auth.vehicleVerified ? DocumentStatus.approved : DocumentStatus.pending;
  }

  void _autoApprove() async {
    if (!mounted) return;
    final auth = AuthService();
    auth.setIdentityVerified(true);
    auth.setLicenseVerified(true);
    auth.setVehicleVerified(true);
    setState(() {
      _cniStatus = DocumentStatus.approved;
      _permisStatus = DocumentStatus.approved;
      _vehicleStatus = DocumentStatus.approved;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (widget.redirectBuilder != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => widget.redirectBuilder!(ctx)),
        (route) => false,
      );
    } else if (widget.isDriver) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PublishTripView()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppHeader(isDriverMode: true),
                const SizedBox(height: 32),
                _hasRejection ? _buildRejectionHeader() : _buildPendingHeader(),
                const SizedBox(height: 32),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.015),
                          blurRadius: 10,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDocumentRow(Icons.check_circle_outline,
                          'Statut Identité', _cniStatus),
                      if (widget.isDriver) ...[
                        const Divider(height: 24, color: Color(0xFFF1F5F9)),
                        _buildDocumentRow(Icons.badge_outlined, 'Statut Permis',
                            _permisStatus,
                            reason: _rejectionReason),
                        const Divider(height: 24, color: Color(0xFFF1F5F9)),
                        _buildDocumentRow(Icons.directions_car_filled_outlined,
                            'Statut Véhicule', _vehicleStatus),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (_hasRejection) ...[
                  _buildDottedInstructionCard(),
                  const SizedBox(height: 24),
                  _buildActionButton(
                    label: widget.isDriver
                        ? 'Reprendre la photo du permis'
                        : 'Reprendre la photo d\'identité',
                    icon: Icons.refresh,
                    color: const Color(0xFF000066),
                    onPressed: () {
                      if (widget.isDriver) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DriverLicenseView(
                                  isDriver: true)),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const IdentityVerificationView(
                                  isDriver: false)),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Besoin d\'aide ? Contacter le support',
                    style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ] else ...[
                  _buildActionButton(
                    label: 'Continuer vers l\'accueil',
                    icon: Icons.arrow_forward,
                    color: const Color(0xFF1E293B),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeView(initialDriverMode: widget.isDriver)),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
    const SizedBox(height: 32),
    const AppFooter(),
  ],
),
);
  }

  Widget _buildPendingHeader() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 55,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset('assets/togo_flag.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Vos documents sont en cours d\'analyse',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000066)),
        ),
        const SizedBox(height: 8),
        const Text(
          'Nos administrateurs vérifient vos informations. Vous recevrez une notification par SMS dès que votre profil sera actif.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
        ),
      ],
    );
  }

  Widget _buildRejectionHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 36,
          backgroundColor: Color(0xFFFEE2E2),
          child: Icon(Icons.warning_amber_rounded,
              color: Color(0xFFDC2626), size: 42),
        ),
        const SizedBox(height: 20),
        const Text(
          'Vérification échouée',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Notre système d\'analyse automatique n\'a pas pu valider vos pièces. Motif : $_rejectionReason',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF475569), height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentRow(IconData icon, String title, DocumentStatus status,
      {String? reason}) {
    Color badgeBgColor;
    Color badgeTextColor;
    String statusText;

    switch (status) {
      case DocumentStatus.approved:
        badgeBgColor = const Color(0xFFDCFCE7);
        badgeTextColor = const Color(0xFF15803D);
        statusText = 'Validé';
        break;
      case DocumentStatus.rejected:
        badgeBgColor = const Color(0xFFFEE2E2);
        badgeTextColor = const Color(0xFFC53030);
        statusText = 'Refusé';
        break;
      case DocumentStatus.pending:
        badgeBgColor = const Color(0xFFFEF3C7);
        badgeTextColor = const Color(0xFFD97706);
        statusText = 'En attente';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                    status == DocumentStatus.approved
                        ? Icons.check_circle
                        : status == DocumentStatus.rejected
                            ? Icons.cancel
                            : Icons.radio_button_unchecked,
                    color: badgeTextColor,
                    size: 22),
                const SizedBox(width: 12),
                Text(title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B))),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
              child: Text(statusText,
                  style: TextStyle(
                      color: badgeTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        if (status == DocumentStatus.rejected && reason != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 34, top: 4),
            child: Text('Motif: ${reason.split('.').last.trim()}',
                style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          )
        ]
      ],
    );
  }

  Widget _buildDottedInstructionCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
      ),
      child: const Row(
        children: [
          Icon(Icons.no_photography_outlined,
              color: Color(0xFF000066), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Assurez-vous que l\'éclairage est suffisant et que tous les coins du document sont visibles.',
              style: TextStyle(
                  color: Color(0xFF475569), fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(width: 8),
            Icon(icon, size: 18),
          ],
        ),
      ),
    );
  }
}
