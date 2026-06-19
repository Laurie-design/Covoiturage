import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final String driverName;
  final String route;
  final String dateLabel;

  const ReviewScreen({
    super.key,
    required this.driverName,
    required this.route,
    required this.dateLabel,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _currentRating = 0;

  final List<String> _availablePoints = [
    'Conduite prudente',
    'Véhicule propre',
    'Ponctuel',
    'Chauffeur courtois',
  ];

  final List<String> _selectedPoints = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000066)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Laisser un avis',
          style: TextStyle(
            color: Color(0xFF000066),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverCard(),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'COMMENT S\'EST PASSÉ VOTRE TRAJET ?',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildStarRatingBar(),
            const SizedBox(height: 24),
            const Text(
              'Points forts',
              style: TextStyle(
                color: Color(0xFF000066),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            _buildPointsFortsChips(),
            const SizedBox(height: 24),
            const Text(
              'Votre commentaire (Optionnel)',
              style: TextStyle(
                color: Color(0xFF000066),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            _buildCommentInputField(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Icon(Icons.verified, size: 16, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.driverName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF000066),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Trajet ${widget.route} du ${widget.dateLabel}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRatingBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        IconData icon;
        final starValue = index + 1;
        if (starValue <= _currentRating) {
          icon = Icons.star;
        } else if (starValue - 0.5 <= _currentRating) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return IconButton(
          icon: Icon(icon, color: Colors.amber, size: 36),
          onPressed: () {
            setState(() => _currentRating = starValue.toDouble());
          },
        );
      }),
    );
  }

  Widget _buildPointsFortsChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _availablePoints.map((point) {
        final isSelected = _selectedPoints.contains(point);
        return ChoiceChip(
          label: Text(
            point,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF475569),
              fontSize: 13,
            ),
          ),
          selected: isSelected,
          selectedColor: const Color(0xFF000066),
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isSelected ? const Color(0xFF000066) : Colors.grey.shade300,
          ),
          avatar: isSelected
              ? const Icon(Icons.check_circle, color: Colors.white, size: 16)
              : null,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedPoints.add(point);
              } else {
                _selectedPoints.remove(point);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCommentInputField() {
    return TextField(
      controller: _commentController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Racontez votre expérience...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF000066)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF000066),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: _currentRating == 0
            ? null
            : () {
                Navigator.pop(context, {
                  'rating': _currentRating,
                  'comment': _commentController.text,
                  'badges': _selectedPoints,
                });
              },
        icon: const Icon(Icons.send, size: 18, color: Colors.white),
        label: const Text(
          "Soumettre l'évaluation",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
