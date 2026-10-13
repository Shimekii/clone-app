import 'package:evgo_clone/services/station_service.dart';
import 'package:evgo_clone/styles/styles.dart';
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
  final StationService _stationService = StationService();
  bool _mapReady = false;
  bool _locating = false;
  bool _initializingMap = true;
  final TextEditingController _searchController = TextEditingController();
  LatLng? _userPosition;

  Future<void> _searchStations() async {
    final stations = _stationService.getStations();

    await showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 1,
          minChildSize: 1,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 32),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close, size: 24),
                            ),
                            const Expanded(
                              child: Text(
                                "Поиск",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setModalState(() {}),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF3F7E9),
                            focusedBorder: getInputBorder(
                              const Color(0xFFDEEACC),
                            ),
                            enabledBorder: getInputBorder(
                              const Color(0xFFDEEACC),
                            ),
                            focusedErrorBorder: getInputBorder(Colors.red),
                            errorBorder: getInputBorder(Colors.red),
                            suffixIcon: const Icon(Icons.search, size: 32),
                            hintText: 'Поиск...',
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Ближайшие места зарядки', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final query = _searchController.text
                                .trim()
                                .toLowerCase();
                            final filteredStations = stations
                                .where(
                                  (station) => station.name
                                      .toLowerCase()
                                      .contains(query),
                                )
                                .toList();

                            if (filteredStations.isEmpty) {
                              return const Center(
                                child: Text('Станции не найдены'),
                              );
                            }

                            return ListView.separated(
                              controller: scrollController,
                              itemCount: filteredStations.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final station = filteredStations[index];
                                final availableConnectors = _stationService
                                    .getAvailableConnectorCount(station);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: ListTile(
                                    tileColor: const Color(0xFFF3F7E9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    leading: const Icon(
                                      Icons.bolt_outlined,
                                      size: 36,
                                    ),
                                    title: Text(station.name, style: TextStyle(color: Colors.black)),
                                    subtitle: Text(
                                      '$availableConnectors/${station.connectors.length} доступно',
                                    ),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.route, size: 30, color: Colors.black),
                                        Text(_distanceLabel(station), style: TextStyle(fontSize: 14, color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      _buildBottomActionBar(),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _distanceLabel(Station station) {
    final currentPosition = _userPosition;
    if (currentPosition == null) return '—';

    final distanceInMeters = _stationService.getDistanceInMeters(
      currentPosition,
      station,
    );
    if (distanceInMeters < 1000) {
      return '~${distanceInMeters.round()} м';
    }

    return '~${(distanceInMeters / 1000).toStringAsFixed(1)} км';
  }

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                        TextSourceAttribution('© OpenStreetMap contributors'),
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
                            func: () {
                              // ДОБАВИТЬ ЛОГИКУ
                              // ДОБАВИТЬ ЛОГИКУ
                              // ДОБАВИТЬ ЛОГИКУ
                            },
                          ),
                          const Spacer(),
                          _buildMapButton(
                            icon: Icons.search,
                            tooltip: 'Поиск',
                            func: () {
                              _searchStations();
                            },
                          ),
                          const SizedBox(width: 10),
                          _buildMapButton(
                            icon: Icons.filter_list_alt,
                            tooltip: 'Фильтр',
                            func: () {
                              // ДОБАВИТЬ ЛОГИКУ
                              // ДОБАВИТЬ ЛОГИКУ
                              // ДОБАВИТЬ ЛОГИКУ
                            },
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
                  child: SafeArea(top: false, child: _buildBottomActionBar()),
                ),
                Positioned(
                  right: 16,
                  top: 128,
                  width: 50,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(borderRadius: BorderRadius.zero),
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFFECFCF2),
                      onPressed: _locateUser,
                      tooltip: 'Моё местоположение',
                      child: const Icon(
                        Icons.my_location,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback func,
  }) {
    return Material(
      color: Color(0xFF1A2D3E),
      elevation: 3,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: func,
        tooltip: tooltip,
        icon: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildBottomAction({required IconData icon, required String label}) {
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

  Widget _buildBottomActionBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF3F7E9)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
          _buildBottomAction(icon: Icons.info_outline, label: 'Помощь'),
        ],
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
        _userPosition = LatLng(position.latitude, position.longitude);
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

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

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

      final point = LatLng(position.latitude, position.longitude);

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

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
