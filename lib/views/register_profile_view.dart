import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'onboarding_view.dart';
import 'identity_verification_view.dart';
import '../services/auth_service.dart';

class RegisterProfileView extends StatefulWidget {
  final Widget Function(BuildContext)? redirectBuilder;

  const RegisterProfileView({super.key, this.redirectBuilder});

  @override
  State<RegisterProfileView> createState() => _RegisterProfileViewState();
}

class _RegisterProfileViewState extends State<RegisterProfileView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Uint8List? _profileImageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() => _profileImageBytes = bytes);
      AuthService().setProfileImage(bytes);
    }
  }

  void _finalizeRegistration() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quel est votre rôle ?'),
        content:
            const Text('Choisissez un rôle pour tester la page suivante :'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IdentityVerificationView(
                    isDriver: false,
                    redirectBuilder: widget.redirectBuilder,
                  ),
                ),
              );
            },
            child: const Text('Passager'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const OnboardingView(isDriver: true)),
              );
            },
            child: const Text('Conducteur'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. BANNIÈRE SUPÉRIEURE BLEU NUIT
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'TransPorto',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // 2. CORPS DU FORMULAIRE
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Créez votre profil',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Plus qu\'une étape pour commencer à covoiturer sur TransPorto.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9E9E9E),
                            height: 1.4),
                      ),
                      const SizedBox(height: 32),
                      // 3. ZONE SÉLECTEUR DE PHOTO (AVATAR)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: const Color(0xFFE2E8F0),
                              backgroundImage: _profileImageBytes != null
                                  ? MemoryImage(_profileImageBytes!)
                                  : null,
                              child: _profileImageBytes == null
                                  ? const Icon(Icons.camera_alt_outlined,
                                      size: 30, color: Color(0xFF718096))
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _pickImage,
                            child: Text(
                              _profileImageBytes == null
                                  ? 'Ajouter une photo'
                                  : 'Changer la photo',
                              style: const TextStyle(
                                  color: Color(0xFF0052CC),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 4. CHAMPS DE SAISIE
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          hintText: 'Votre prénom (ex: Aimée)',
                          fillColor: const Color(0xFFF1F5F9),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          hintText: 'Votre nom (ex: MARDJA)',
                          fillColor: const Color(0xFFF1F5F9),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 5. BOUTON DE FINALISATION
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052CC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: _finalizeRegistration,
                          child: const Text(
                            'Finaliser l\'inscription',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 6. TEXTE LÉGAL
                      const Text.rich(
                        TextSpan(
                          text: 'En continuant, vous acceptez nos ',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9E9E9E),
                              height: 1.4),
                          children: [
                            TextSpan(
                              text: 'Conditions Générales',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                            TextSpan(text: ' et notre '),
                            TextSpan(
                              text: 'Politique de Confidentialité',
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
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
}
