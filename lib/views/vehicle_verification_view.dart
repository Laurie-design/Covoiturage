import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'driver_status_tracker_view.dart';
import '../services/auth_service.dart';

class VehicleVerificationView extends StatefulWidget {
  final bool isDriver;

  const VehicleVerificationView({super.key, required this.isDriver});

  @override
  State<VehicleVerificationView> createState() =>
      _VehicleVerificationViewState();
}

class _VehicleVerificationViewState extends State<VehicleVerificationView> {
  final _plateController = TextEditingController();
  final _modelController = TextEditingController();

  Uint8List? _vehicleDocBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDocumentImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List bytes = await image.readAsBytes();
      setState(() {
        _vehicleDocBytes = bytes;
      });
    }
  }

  void _submitDriverProfile() {
    if (_plateController.text.isEmpty || _modelController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Veuillez remplir toutes les informations du véhicule.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Profil soumis avec succès ! Transfère en cours...',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF007A33),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF000066)),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => DriverStatusTrackerView(
                isDriver: widget.isDriver)),
        (route) => false,
      );
    });
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
              children: [
                const Text(
                  'ÉTAPE 3/3',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000066),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Carte Grise & Véhicule',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Finalisez votre inscription en renseignant les détails\ntechniques de votre véhicule de service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Color(0x8A000000), height: 1.4),
                ),
                const SizedBox(height: 24),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Numéro d\'immatriculation',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _plateController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.badge_outlined,
                              color: Color(0xFF9E9E9E)),
                          hintText: 'ex: AB-123-CD',
                          hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Modèle du véhicule',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _modelController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                              Icons.directions_car_filled_outlined,
                              color: Color(0xFF9E9E9E)),
                          hintText: 'ex: Toyota Prius 2023',
                          hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Carte Grise',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF334155)),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDocumentImage,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: _vehicleDocBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(_vehicleDocBytes!,
                                      height: 140, fit: BoxFit.cover),
                                )
                              : Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: const Color(0xFFE0E7FF),
                                      child: const Icon(
                                          Icons.electric_car_outlined,
                                          color: Color(0xFF000066),
                                          size: 24),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Télécharger le document',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Glissez-déposez ou cliquez ici',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF9E9E9E)),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.info_outline,
                              size: 14, color: Color(0xFF9E9E9E)),
                          SizedBox(width: 6),
                          Text(
                            'Formats acceptés: PDF, JPG, PNG (Max 5Mo)',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFF9E9E9E)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1617788138017-80ad40651399?auto=format&fit=crop&q=80&w=600',
                              height: 110,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.7),
                                    Colors.transparent
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 12,
                            left: 12,
                            child: Text(
                              'Vérification de sécurité active',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 37, 0, 122),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 2,
                    ),
                    onPressed: _submitDriverProfile,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Soumettre mon profil conducteur',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
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
                      _buildStepIndicator(Icons.directions_car_filled_outlined,
                          'Permis', false),
                      _buildStepIndicator(
                          Icons.local_taxi_outlined, 'Véhicule', true),
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
