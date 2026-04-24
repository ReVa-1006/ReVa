import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  // ── Theme colors (matching driver dashboard) ─────────────────────────────
  static const _darkGreen = Color(0xFF1B5E20);
  static const _green = Color(0xFF2E6B2E);
  static const _lightGreen = Color(0xFF4CAF50);
  static const _bgColor = Color(0xFFF0F5F0);

  final MapController _mapController = MapController();
  bool _isTracking = true;
  int _selectedFilter = 0; // 0 = All, 1 = Pickup, 2 = Delivery

  // Cairo center
  final LatLng _driverLocation = const LatLng(30.0444, 31.2357);

  // Sample pickup & delivery points
  final List<Map<String, dynamic>> _waypoints = [
    {
      'id': '#ORD-0041',
      'type': 'pickup',
      'label': 'Seller · Omar F.',
      'address': '12 Elm St, Cairo',
      'material': 'Clear PET Bottles · 5 kg',
      'price': '\$17.50',
      'latlng': const LatLng(30.0500, 31.2300),
    },
    {
      'id': '#ORD-0041',
      'type': 'delivery',
      'label': 'Buyer · Sara M.',
      'address': '45 Nile Ave, Giza',
      'material': 'Clear PET Bottles · 5 kg',
      'price': '\$17.50',
      'latlng': const LatLng(30.0390, 31.2440),
    },
    {
      'id': '#ORD-0042',
      'type': 'pickup',
      'label': 'Seller · Nour S.',
      'address': '88 Cedar Rd, Cairo',
      'material': 'Aluminum Cans · 8 kg',
      'price': '\$24.00',
      'latlng': const LatLng(30.0530, 31.2400),
    },
    {
      'id': '#ORD-0042',
      'type': 'delivery',
      'label': 'Buyer · Ahmed K.',
      'address': '22 Green Blvd, Cairo',
      'material': 'Aluminum Cans · 8 kg',
      'price': '\$24.00',
      'latlng': const LatLng(30.0360, 31.2250),
    },
  ];

  // ── Filter labels ─────────────────────────────────────────────────────────
  final _filters = ['All', 'Pickup', 'Delivery'];

  List<Map<String, dynamic>> get _filteredWaypoints {
    if (_selectedFilter == 0) return _waypoints;
    final type = _selectedFilter == 1 ? 'pickup' : 'delivery';
    return _waypoints.where((w) => w['type'] == type).toList();
  }

  // Track the currently selected waypoint for bottom sheet
  Map<String, dynamic>? _selectedWaypoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(child: _buildMap()),
          ],
        ),
      ),
      // Floating bottom card when a waypoint is selected
      bottomSheet: _selectedWaypoint != null ? _buildWaypointSheet() : null,
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_darkGreen, _green, _lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Live Map',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                Text('Track pickups & deliveries',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          // Tracking toggle
          GestureDetector(
            onTap: () => setState(() => _isTracking = !_isTracking),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _isTracking ? Colors.white : Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isTracking ? _lightGreen : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isTracking ? 'Tracking' : 'Paused',
                    style: TextStyle(
                      color: _isTracking ? _green : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter chips ──────────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: List.generate(_filters.length, (i) {
          final isActive = i == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedFilter = i;
                _selectedWaypoint = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? const LinearGradient(colors: [_darkGreen, _lightGreen])
                      : null,
                  color: isActive ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      i == 0
                          ? Icons.layers_rounded
                          : i == 1
                              ? Icons.store_rounded
                              : Icons.person_pin_circle_rounded,
                      size: 16,
                      color: isActive ? Colors.white : _green,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _filters[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : const Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Map ────────────────────────────────────────────────────────────────────
  Widget _buildMap() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _driverLocation,
              initialZoom: 14,
              onTap: (_, __) => setState(() => _selectedWaypoint = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.reva.app',
              ),
              // Route polylines from driver to each pickup → delivery pair
              PolylineLayer(
                polylines: _buildRoutePolylines(),
              ),
              // Waypoint markers
              MarkerLayer(markers: _buildMarkers()),
            ],
          ),
        ),
        // Re-center FAB
        Positioned(
          bottom: _selectedWaypoint != null ? 200 : 24,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _mapFab(Icons.my_location_rounded, () {
                _mapController.move(_driverLocation, 14);
              }),
              const SizedBox(height: 10),
              _mapFab(Icons.add_rounded, () {
                _mapController.move(
                    _mapController.camera.center, _mapController.camera.zoom + 1);
              }),
              const SizedBox(height: 10),
              _mapFab(Icons.remove_rounded, () {
                _mapController.move(
                    _mapController.camera.center, _mapController.camera.zoom - 1);
              }),
            ],
          ),
        ),
        // Top-left stats overlay
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.route_rounded, color: _green, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${_filteredWaypoints.length} waypoints',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Build markers ─────────────────────────────────────────────────────────
  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Driver marker
    markers.add(
      Marker(
        point: _driverLocation,
        width: 52,
        height: 52,
        child: Container(
          decoration: BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                  color: _green.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 3),
            ],
          ),
          child: const Icon(Icons.local_shipping_rounded,
              color: Colors.white, size: 24),
        ),
      ),
    );

    // Waypoint markers
    for (final wp in _filteredWaypoints) {
      final isPickup = wp['type'] == 'pickup';
      markers.add(
        Marker(
          point: wp['latlng'] as LatLng,
          width: 44,
          height: 56,
          child: GestureDetector(
            onTap: () => setState(() => _selectedWaypoint = wp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPickup
                          ? const Color(0xFFF9A825)
                          : const Color(0xFF1E88E5),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6),
                    ],
                  ),
                  child: Icon(
                    isPickup
                        ? Icons.store_rounded
                        : Icons.person_pin_circle_rounded,
                    color: isPickup
                        ? const Color(0xFFF9A825)
                        : const Color(0xFF1E88E5),
                    size: 20,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPickup
                        ? const Color(0xFFF9A825)
                        : const Color(0xFF1E88E5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isPickup ? 'Pickup' : 'Drop',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return markers;
  }

  // ── Route polylines ───────────────────────────────────────────────────────
  List<Polyline> _buildRoutePolylines() {
    final lines = <Polyline>[];
    // Draw simplified straight-line routes from driver → pickup → delivery
    for (int i = 0; i < _waypoints.length; i += 2) {
      if (i + 1 >= _waypoints.length) break;
      final pickup = _waypoints[i]['latlng'] as LatLng;
      final delivery = _waypoints[i + 1]['latlng'] as LatLng;

      // Driver to pickup
      lines.add(Polyline(
        points: [_driverLocation, pickup],
        color: _green.withValues(alpha: 0.5),
        strokeWidth: 3,
        pattern: const StrokePattern.dotted(),
      ));

      // Pickup to delivery
      lines.add(Polyline(
        points: [pickup, delivery],
        color: _green,
        strokeWidth: 3.5,
      ));
    }
    return lines;
  }

  // ── Map FAB ───────────────────────────────────────────────────────────────
  Widget _mapFab(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Icon(icon, color: _green, size: 20),
      ),
    );
  }

  // ── Bottom waypoint sheet ─────────────────────────────────────────────────
  Widget _buildWaypointSheet() {
    final wp = _selectedWaypoint!;
    final isPickup = wp['type'] == 'pickup';
    final accentColor =
        isPickup ? const Color(0xFFF9A825) : const Color(0xFF1E88E5);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPickup
                      ? Icons.store_rounded
                      : Icons.person_pin_circle_rounded,
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isPickup ? 'PICKUP' : 'DELIVERY',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: accentColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(wp['id'] as String,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF888888))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(wp['label'] as String,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A))),
                    Text(wp['address'] as String,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF888888))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Material info bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_rounded,
                    color: _green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(wp['material'] as String,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333))),
                ),
                Text(wp['price'] as String,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _darkGreen)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Navigate button
          GestureDetector(
            onTap: () {
              final target = wp['latlng'] as LatLng;
              _mapController.move(target, 16);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_darkGreen, _green, _lightGreen]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: _green.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.navigation_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Navigate',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
