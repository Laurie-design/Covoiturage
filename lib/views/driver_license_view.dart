import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'vehicle_verification_view.dart';
import '../services/auth_service.dart';

class DriverLicenseView extends StatefulWidget {
  final bool isDriver;

  const DriverLicenseView({super.key, required this.isDriver});

  @override
  State<DriverLicenseView> createState() => _DriverLicenseViewState();
}

class _DriverLicenseViewState extends State<DriverLicenseView> {
  final _licenseNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  Uint8List? _licenseImageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _licenseImageBytes = bytes);
    }
  }

  void _goToNextStep() {
    if (_licenseNumberController.text.isEmpty ||
        _expiryDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Veuillez renseigner les informations de votre permis.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VehicleVerificationView(isDriver: widget.isDriver)),
    );
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
                const Text(
                  'Étape 2/3: Permis de Conduire',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Veuillez renseigner les informations de votre permis de conduire en vigueur.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 24),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Numéro de permis',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _licenseNumberController,
                        decoration: InputDecoration(
                          hintText: 'Ex: 12/34567/89',
                          hintStyle: const TextStyle(
                              color: Color(0xFFBDBDBD), fontSize: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Date d\'expiration',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _expiryDateController,
                        decoration: InputDecoration(
                          hintText: 'mm/dd/yyyy',
                          hintStyle: const TextStyle(
                              color: Color(0xFFBDBDBD), fontSize: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Copie du permis (Recto/Verso)',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickImage,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 28, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: _licenseImageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    _licenseImageBytes!,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: const Color(0xFFEEF2F6),
                                      child: const Icon(Icons.badge_outlined,
                                          color: Color(0xFF000066), size: 24),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Cliquez pour télécharger',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF000066)),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'ou glissez-déposez votre fichier ici\n(JPG, PNG ou PDF)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                          height: 1.4),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.cloud_upload_outlined,
                                            size: 16, color: Color(0xFF000066)),
                                        SizedBox(width: 6),
                                        Text(
                                          'Taille max. 5Mo',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF000066),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline,
                                color: Color(0xFF1E293B), size: 20),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Conseil de vérification',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                        fontSize: 13),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Assurez-vous que toutes les informations sont parfaitement lisibles et que les quatre coins du document sont visibles sur la photo.',
                                    style: TextStyle(
                                        color: Color(0xFF475569),
                                        fontSize: 12,
                                        height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFFF8FAFC),
                            side: const BorderSide(color: Color(0xFF000066)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back,
                              size: 18, color: Color(0xFF000066)),
                          label: const Text(
                            'Précédent',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000066),
                                fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000066),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _goToNextStep,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Suivant',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      _buildStepIndicator(Icons.badge_outlined, 'CNI', false),
                      _buildStepIndicator(
                          Icons.directions_car_filled_outlined, 'Permis', true),
                      _buildStepIndicator(
                          Icons.local_taxi_outlined, 'Véhicule', false),
                    ],
                  ),
                ),
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
