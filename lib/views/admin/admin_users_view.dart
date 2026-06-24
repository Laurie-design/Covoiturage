import 'package:flutter/material.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  final _searchController = TextEditingController();
  String _roleFilter = 'Tous';
  String _statusFilter = 'Tous';
  int _currentPage = 1;

  final _users = List.generate(50, (i) => {
    'name': ['Koffi Amenyo', 'Yawa Bocco', 'Komlan Sedo', 'Afi Tete', 'Esso Luma', 'Ama Dossou', 'Yao Koffi', 'Kossi Agbeko'][i % 8],
    'phone': '90 ${(i * 7 + 10) % 100} ${(i * 13 + 20) % 100} ${(i * 3 + 30) % 100}',
    'role': i % 3 == 0 ? 'Conducteur' : 'Passager',
    'docStatus': ['Valide', 'En attente', 'Refuse', 'Valide'][i % 4],
    'date': '${20 + i % 10}/06/2026',
  });

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((u) {
      final search = _searchController.text.toLowerCase();
      if (search.isNotEmpty && !u['name'].toString().toLowerCase().contains(search) && !u['phone'].toString().contains(search)) return false;
      if (_roleFilter != 'Tous' && u['role'] != _roleFilter) return false;
      if (_statusFilter != 'Tous' && u['docStatus'] != _statusFilter) return false;
      return true;
    }).toList();
  }

  int get _totalPages => (_filteredUsers.length / 10).ceil();
  List<Map<String, dynamic>> get _pageUsers {
    final start = (_currentPage - 1) * 10;
    return _filteredUsers.sublist(start, (start + 10).clamp(0, _filteredUsers.length));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredUsers;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() { _currentPage = 1; }),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher un utilisateur...',
                      hintStyle: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildDropdown('Rôle', ['Tous', 'Conducteur', 'Passager'], _roleFilter, (v) {
                setState(() { _roleFilter = v!; _currentPage = 1; });
              }),
              const SizedBox(width: 12),
              _buildDropdown('Statut', ['Tous', 'Valide', 'En attente', 'Refuse'], _statusFilter, (v) {
                setState(() { _statusFilter = v!; _currentPage = 1; });
              }),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {},
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Exporter CSV', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Table header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              children: const [
                _HeaderCell('NOM', 3),
                _HeaderCell('TÉLÉPHONE', 2.5),
                _HeaderCell('RÔLE', 2),
                _HeaderCell('DOCUMENTS', 2.5),
                _HeaderCell('DATE', 2),
                _HeaderCell('ACTIONS', 1.5),
              ],
            ),
          ),
        ),

        // Table rows
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: _pageUsers.isEmpty
                ? const Center(child: Text('Aucun utilisateur trouvé', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15)))
                : ListView.separated(
                    itemCount: _pageUsers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    itemBuilder: (ctx, i) {
                      final u = _pageUsers[i];
                      return InkWell(
                        onTap: () => _showUserDetail(u),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              _CellData(u['name'] as String, 3),
                              _CellData(u['phone'] as String, 2.5),
                              _rowRole(u),
                              _docStatusCell(u['docStatus'] as String, 2.5),
                              _CellData(u['date'] as String, 2),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                      backgroundColor: const Color(0xFFE8F0FE),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () => _showUserDetail(u),
                                    child: const Text('Voir', style: TextStyle(color: Color(0xFF0052CC), fontSize: 13, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),

        // Pagination
        Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${filtered.length} utilisateur(s)',
                  style: const TextStyle(color: Color(0xFF0052CC), fontSize: 14, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 22, color: Color(0xFF475569)),
                    onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                  ),
                  Text('$_currentPage / $_totalPages', style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 22, color: Color(0xFF475569)),
                    onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String current, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
          isDense: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF475569)),
        ),
      ),
    );
  }

  Widget _rowRole(Map<String, dynamic> u) {
    final isDriver = u['role'] == 'Conducteur';
    return Expanded(
      flex: 2,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDriver ? const Color(0xFFE8F0FE) : const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isDriver ? '🚗 Conducteur' : '👤 Passager',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDriver ? const Color(0xFF0052CC) : const Color(0xFF059669)),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _docStatusCell(String status, double flex) {
    Color color;
    String label;
    switch (status) {
      case 'Valide':
        color = const Color(0xFF059669);
        label = 'Validé';
        break;
      case 'En attente':
        color = const Color(0xFFD97706);
        label = 'En attente';
        break;
      case 'Refuse':
        color = const Color(0xFFDC2626);
        label = 'Refusé';
        break;
      default:
        color = const Color(0xFF94A3B8);
        label = status;
    }
    return Expanded(
      flex: flex ~/ 1,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(label, style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  void _showUserDetail(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (ctx, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFF0052CC),
                        child: Text(user['name'].toString().split(' ').map((e) => e[0]).join(''),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['name'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          const SizedBox(height: 4),
                          Text('+228 ${user['phone']}', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Compte actif', style: TextStyle(fontSize: 12, color: Color(0xFF059669), fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  _detailDocRow('CNI', '✅', 'Validé', '15/06/2026', 'Voir'),
                  _detailDocRow('Permis', '⏳', 'En attente', '18/06/2026', 'Voir'),
                  _detailDocRow('Carte grise', '❌', 'Refusé', '19/06/2026', 'Voir'),
                  _detailDocRow('Assurance', '⏳', 'En attente', '21/06/2026', 'Voir'),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Trajets effectués', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 12),
                  _detailTripRow('Lomé → Kara', '12/06/2026', '4 pass.', '✅ Terminé'),
                  _detailTripRow('Lomé → Atakpamé', '15/06/2026', '3 pass.', '✅ Terminé'),
                  _detailTripRow('Lomé → Kpalimé', '18/06/2026', '0 pass.', '❌ Annulé'),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFDC2626)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Suspendre le compte', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052CC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Text('Contacter', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailDocRow(String type, String icon, String label, String date, String action) {
    Color labelColor;
    switch (label) {
      case 'Validé':
        labelColor = const Color(0xFF059669);
        break;
      case 'En attente':
        labelColor = const Color(0xFFD97706);
        break;
      default:
        labelColor = const Color(0xFFDC2626);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(type, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)))),
          Expanded(flex: 2, child: Text('$icon $label', style: TextStyle(fontSize: 13, color: labelColor, fontWeight: FontWeight.w500))),
          Expanded(flex: 1, child: Text(date, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
          TextButton(
            onPressed: () {},
            child: Text(action, style: const TextStyle(fontSize: 13, color: Color(0xFF0052CC))),
          ),
        ],
      ),
    );
  }

  Widget _detailTripRow(String route, String date, String passengers, String status) {
    final isCancelled = status.contains('Annulé');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(route, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)))),
          Expanded(flex: 1, child: Text(date, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
          Expanded(flex: 1, child: Text(passengers, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
          Expanded(
            flex: 2,
            child: Text(status, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isCancelled ? const Color(0xFFDC2626) : const Color(0xFF059669))),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final double flex;
  const _HeaderCell(this.label, this.flex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ~/ 1,
      child: Center(
        child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
      ),
    );
  }
}

class _CellData extends StatelessWidget {
  final String text;
  final double flex;
  const _CellData(this.text, this.flex);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ~/ 1,
      child: Center(
        child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B))),
      ),
    );
  }
}
