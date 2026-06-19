import 'package:flutter/material.dart';
import 'passenger_dashboard_view.dart';

class PaymentScreen extends StatefulWidget {
  final String price;
  final String departure;
  final String arrival;
  final String driverName;
  final String departureTime;
  final String arrivalTime;

  const PaymentScreen({
    super.key,
    required this.price,
    required this.departure,
    required this.arrival,
    required this.driverName,
    required this.departureTime,
    required this.arrivalTime,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;
  final _phoneController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
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
          'Paiement',
          style:
              TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTripSummary(),
            const SizedBox(height: 24),
            _buildSectionTitle('Choisissez votre moyen de paiement'),
            const SizedBox(height: 12),
            _buildPaymentMethod(
              'T-Money',
              'Paiement mobile T-Money',
              'assets/mix_by_yas.png',
              const Color(0xFF22C55E),
              'tmoney',
            ),
            const SizedBox(height: 12),
            _buildPaymentMethod(
              'Moov Money',
              'Paiement mobile Moov Money',
              'assets/moov.png',
              const Color(0xFFF59E0B),
              'moov',
            ),
            if (_selectedMethod != null) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Numéro de téléphone'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        _selectedMethod == 'tmoney'
                            ? 'assets/mix_by_yas.png'
                            : 'assets/moov.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    hintText: _selectedMethod == 'tmoney'
                        ? 'Ex: 90 00 00 00'
                        : 'Ex: 98 00 00 00',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Saisissez le numéro associé à votre compte ${_selectedMethod == 'tmoney' ? 'T-Money' : 'Moov Money'}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedMethod != null &&
                          _phoneController.text.length >= 6
                      ? const Color(0xFF000066)
                      : const Color(0xFF94A3B8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: _selectedMethod != null &&
                        _phoneController.text.length >= 6 &&
                        !_isProcessing
                    ? _processPayment
                    : null,
                child: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        'Payer',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)));
  }

  Widget _buildTripSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
          const Text('Récapitulatif',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A))),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.route, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text('${widget.departure} → ${widget.arrival}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(widget.driverName,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF475569))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text('${widget.departureTime} → ${widget.arrivalTime}',
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF475569))),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total à payer',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w600)),
              Text(widget.price,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000066))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String name, String description, String assetPath,
      Color color, String value) {
    final selected = _selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : const Color(0xFFE2E8F0),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: color.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(assetPath, width: 32, height: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0F172A))),
                  const SizedBox(height: 2),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? color : Colors.transparent,
                border: Border.all(
                  color: selected ? color : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    final code = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 56),
            const SizedBox(height: 12),
            const Text('Paiement réussi !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF000066).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF000066).withValues(alpha: 0.15)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Code de réservation',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          Icon(Icons.lock, size: 12, color: Colors.green[600]),
                          const SizedBox(width: 4),
                          Text('Unique',
                              style: TextStyle(fontSize: 10, color: Colors.green[600], fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(code,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF000066), letterSpacing: 4)),
                  const SizedBox(height: 6),
                  Container(
                    height: 1,
                    color: const Color(0xFF000066).withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 10),
                  _confirmationRow(Icons.route_outlined, '${widget.departure} → ${widget.arrival}'),
                  const SizedBox(height: 6),
                  _confirmationRow(Icons.person_outline, 'Conducteur : ${widget.driverName}'),
                  const SizedBox(height: 6),
                  _confirmationRow(Icons.access_time, '${widget.departureTime} → ${widget.arrivalTime}'),
                  const SizedBox(height: 6),
                  _confirmationRow(Icons.monetization_on_outlined, widget.price),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Montrez ce code et les détails ci-dessus au conducteur\navant de monter à bord.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF000066),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    ctx,
                    MaterialPageRoute(builder: (_) => const PassengerDashboardView()),
                    (route) => false,
                  );
                },
                child: const Text('Voir mes réservations', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmationRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
