import 'package:flutter/material.dart';
import 'trip_success_view.dart';
import 'shared_widgets.dart';

class PublishTripView extends StatefulWidget {
  const PublishTripView({super.key});

  @override
  State<PublishTripView> createState() => _PublishTripViewState();
}

class _PublishTripViewState extends State<PublishTripView> {
  String _selectedRoute = 'Lomé - Kara';
  int _passengerCount = 3;
  final int _fixedPrice = 5700;
  final int _recommendedPricePerPassenger = 1900;
  DateTime _tripDate = DateTime.now().add(const Duration(days: 1));

  String get _formattedDate {
    final months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return '${_tripDate.day} ${months[_tripDate.month - 1]} ${_tripDate.year}, ${_tripDate.hour.toString().padLeft(2, '0')}:${_tripDate.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _tripDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_tripDate),
    );
    if (time == null) return;
    setState(() => _tripDate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // HEADER EN PLEINE LARGEUR (hors du Center, comme dans home_view.dart)
          const AppHeader(isDriverMode: true),

          // CONTENU SCROLLABLE, centré uniquement à l'intérieur de cette zone
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 450),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Proposer un trajet',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Remplissez les détails pour votre prochain voyage.',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: Column(
                          children: [
                            _buildFormCard(
                              title: 'Trajet',
                              child: DropdownButtonFormField<String>(
                                value: _selectedRoute,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.linear_scale_sharp,
                                      color: Color(0xFF000066)),
                                  border: InputBorder.none,
                                ),
                                items: <String>[
                                  'Lomé - Kara',
                                  'Lomé - Atakpamé',
                                  'Sokodé - Kara',
                                  'Kpalimé - Lomé'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedRoute = newValue!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFormCard(
                              title: 'Frais globaux du voyage',
                              footerText:
                                  'Ces frais sont calculés automatiquement selon la distance.',
                              child: TextFormField(
                                initialValue: '$_fixedPrice FCFA',
                                readOnly: true,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF334155)),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                      Icons.account_balance_wallet_outlined,
                                      color: Color(0xFF9E9E9E)),
                                  suffixIcon: Icon(Icons.lock_outline,
                                      color: Color(0xFF9E9E9E), size: 18),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFormCard(
                              title: 'Nombre de places',
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: Color(0xFF000066), size: 36),
                                      onPressed: _passengerCount > 1
                                          ? () =>
                                              setState(() => _passengerCount--)
                                          : null,
                                    ),
                                    Column(
                                      children: [
                                        Text('$_passengerCount',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        const Text('PASSAGERS',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF9E9E9E),
                                                letterSpacing: 0.5)),
                                      ],
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle,
                                          color: Color(0xFF000066), size: 36),
                                      onPressed: _passengerCount < 8
                                          ? () =>
                                              setState(() => _passengerCount++)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: const Color(0xFFBBF7D0)),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xFF4ADE80),
                                    child:
                                        Icon(Icons.person, color: Colors.white),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Prix recommandé par passager',
                                          style: TextStyle(
                                              color: Color(0xFF14532D),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '$_recommendedPricePerPassenger FCFA',
                                          style: const TextStyle(
                                              color: Color(0xFF14532D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFormCard(
                              title: 'Date du voyage',
                              child: TextFormField(
                                controller:
                                    TextEditingController(text: _formattedDate),
                                readOnly: true,
                                onTap: _pickDateTime,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                      Icons.calendar_today_outlined,
                                      color: Color(0xFF9E9E9E)),
                                  suffixIcon: Icon(Icons.keyboard_arrow_down,
                                      color: Color(0xFF9E9E9E)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF000066),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Trajet publié avec succès !'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    final parts = _selectedRoute.split(' - ');
                                    final origin =
                                        parts.isNotEmpty ? parts[0] : 'Lomé';
                                    final destination =
                                        parts.length > 1 ? parts[1] : 'Kara';
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TripSuccessView(
                                          origin: origin,
                                          destination: destination,
                                          dateFormatted: _formattedDate,
                                          passengerCount: _passengerCount,
                                          pricePerPassenger:
                                              _recommendedPricePerPassenger,
                                        ),
                                      ),
                                      (route) => false,
                                    );
                                  });
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.campaign_outlined,
                                        color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      'Mettre le trajet en ligne',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'En publiant, vous acceptez nos conditions de\ntransport professionnel.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9E9E9E),
                                  height: 1.4),
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

  Widget _buildFormCard(
      {required String title, required Widget child, String? footerText}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          child,
          if (footerText != null) ...[
            const Divider(height: 16, color: Color(0xFFF1F5F9)),
            Text(footerText,
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
          ]
        ],
      ),
    );
  }
}
