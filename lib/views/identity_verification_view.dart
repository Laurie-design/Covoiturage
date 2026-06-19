import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'driver_license_view.dart';
import 'driver_status_tracker_view.dart';

class IdentityVerificationView extends StatefulWidget {
  final bool isDriver;
  final Widget Function(BuildContext)? redirectBuilder;

  const IdentityVerificationView({super.key, required this.isDriver, this.redirectBuilder});

  @override
  State<IdentityVerificationView> createState() =>
      _IdentityVerificationViewState();
}

class _IdentityVerificationViewState extends State<IdentityVerificationView> {
  String? _selectedDocumentType;
  final _docNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  final List<Map<String, dynamic>> _documentTypes = [
    {'name': 'Carte d\'identité', 'icon': Icons.credit_card_outlined},
    {'name': 'Passeport', 'icon': Icons.travel_explore_outlined},
  ];

  void _goToNextStep() {
    if (_selectedDocumentType == null ||
        _docNumberController.text.isEmpty ||
        _expiryDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Veuillez remplir toutes les informations du document.')),
      );
      return;
    }
    if (widget.isDriver) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DriverLicenseView(isDriver: true)),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DriverStatusTrackerView(
            isDriver: false,
            redirectBuilder: widget.redirectBuilder,
          ),
        ),
        (route) => false,
      );
    }
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isDriver ? 'Étape 1/3' : 'Vérifier votre identité',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000066),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Valider votre Identité',
                  style: TextStyle(fontSize: 16, color: Color(0x8A000000)),
                ),
                const SizedBox(height: 24),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sélectionner votre document',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String?>(
                            value: _selectedDocumentType,
                            isExpanded: true,
                            hint: const Text('Identité',
                                style: TextStyle(
                                    color: Color(0xFFBDBDBD), fontSize: 15)),
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Color(0xFF9E9E9E)),
                            items: _documentTypes.map((doc) {
                              return DropdownMenuItem<String>(
                                value: doc['name'],
                                child: Row(
                                  children: [
                                    Icon(doc['icon'],
                                        color: const Color(0xFF000066),
                                        size: 20),
                                    const SizedBox(width: 12),
                                    Text(doc['name'],
                                        style: const TextStyle(fontSize: 15)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedDocumentType = value);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Numéro de document',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _docNumberController,
                        decoration: InputDecoration(
                          hintText: 'Ex: 123456789',
                          hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Date d\'expiration',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _expiryDateController,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          hintText: 'mm/dd/yyyy',
                          hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Photo du document',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFCBD5E1),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: _imageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    _imageBytes!,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: const Color(0xFFE0E7FF),
                                      child: const Icon(Icons.shield_outlined,
                                          color: Color(0xFF1565C0), size: 24),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Prendre ou charger une photo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Formats acceptés : JPG, PNG (Max 5Mo)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF9E9E9E)),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000066),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _goToNextStep,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Suivant',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Vos données sont sécurisées et chiffrées.',
                          style:
                              TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFF15803D), size: 22),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Besoin d\'aide ?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF166534),
                                  fontSize: 14),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Assurez-vous que tous les bords du document sont visibles et que les informations sont lisibles sans reflet.',
                              style: TextStyle(
                                  color: Color(0xFF166534),
                                  fontSize: 13,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isDriver) ...[
                  const SizedBox(height: 24),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 450),
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStepIndicator(Icons.badge_outlined, 'CNI', true),
                        _buildStepIndicator(Icons.directions_car_filled_outlined,
                            'Permis', false),
                        _buildStepIndicator(
                            Icons.local_taxi_outlined, 'Véhicule', false),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF000066).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            )
          : null,
      child: Row(
        children: [
          Icon(icon,
              color: isActive ? const Color(0xFF000066) : Color(0xFF9E9E9E),
              size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF000066) : Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}
