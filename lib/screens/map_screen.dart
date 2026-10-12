import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  static const LatLng defaultPosition = LatLng(56.4761, 84.9657);
  bool _mapReady = false;
  bool _locating = false;
  bool _initializingMap = true;

  LatLng? _userPosition;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initializingMap
          ? const ColoredBox(color: Colors.white)
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _userPosition ?? defaultPosition,
                    initialZoom: _userPosition == null ? 13 : 16,
                    onMapReady: () {
                      _mapReady = true;
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.evgo_clone',
                    ),
                    if (_userPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _userPosition!,
                            width: 24,
                            height: 24,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    const RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          '© OpenStreetMap contributors',
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        children: [
                          _buildMapButton(
                            icon: Icons.menu_outlined,
                            tooltip: 'Меню',
                          ),
                          const Spacer(),
                          _buildMapButton(
                            icon: Icons.search,
                            tooltip: 'Поиск',
                          ),
                          const SizedBox(width: 10),
                          _buildMapButton(
                            icon: Icons.filter_list_alt,
                            tooltip: 'Фильтр',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F7E9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 12,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          _buildBottomAction(
                            icon: Icons.add_location_alt_outlined,
                            label: 'Найти заправку',
                          ),
                          _buildBottomAction(
                            icon: Icons.qr_code_scanner,
                            label: 'Сканировать QR',
                          ),
                          _buildBottomAction(
                            icon: Icons.info_outline,
                            label: 'Помощь',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 128,
                  width: 50,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFFECFCF2),
                      onPressed: _locateUser,
                      tooltip: 'Моё местоположение',
                      child: const Icon(Icons.my_location, color: Color(0xFF666666)),
                    ),
                  )
                ),
              ],
            ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required String tooltip,
  }) {
    return Material(
      color: Color(0xFF1A2D3E),
      elevation: 3,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: () {},
        tooltip: tooltip,
        icon: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildBottomAction({
    required IconData icon,
    required String label,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: 76,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, height: 1.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeMap() async {
    try {
      final hasLocationPermission = await _requestPermissions();
      if (!hasLocationPermission) {
        _showMessage('Нет доступа к местоположению');
      } else if (!await Geolocator.isLocationServiceEnabled()) {
        _showMessage('Включи геолокацию на устройстве');
      } else {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        _userPosition = LatLng(
          position.latitude,
          position.longitude,
        );
      }
    } catch (e) {
      _showMessage('Не удалось определить местоположение');
    } finally {
      if (mounted) {
        setState(() => _initializingMap = false);
      }
    }
  }

  Future<bool> _requestPermissions() async {
    var locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }

    final notificationPermission = await Permission.notification.request();
    if (notificationPermission.isDenied) {
      _showMessage('Уведомления отклонены!');
    }

    return locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse;
  }

  Future<void> _locateUser() async {
    if (!_mapReady || _locating) return;

    _locating = true;

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showMessage('Нет доступа к местоположению');
        return;
      }

      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showMessage('Включи геолокацию на устройстве');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final point = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _userPosition = point;
      });

      _mapController.move(point, 16);
    } catch (e) {
      _showMessage('Не удалось определить местоположение');
    } finally {
      _locating = false;
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}