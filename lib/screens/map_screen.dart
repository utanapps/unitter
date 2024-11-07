import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:unitter/services/supabase_service.dart';
import '../generated/l10n.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with WidgetsBindingObserver {
  final MapController _mapController = MapController();
  Timer? _positionUpdateTimer;
  StreamSubscription<List<Map<String, dynamic>>>? _locationSubscription;
  Map<String, LatLng> _userLocations = {};
  final supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    supabaseService.setUserOnlineStatus(true);
    _startPositionUpdates();
    _subscribeToUserLocations();
  }

  @override
  void dispose() {
    _stopPositionUpdates();
    _unsubscribeFromUserLocations();
    supabaseService.setUserOnlineStatus(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      supabaseService.setUserOnlineStatus(false);
    } else if (state == AppLifecycleState.resumed) {
      supabaseService.setUserOnlineStatus(true);
    }
  }

  void _startPositionUpdates() {
    _positionUpdateTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
          try {
            final position = await _getCurrentPosition();
            await supabaseService.updateUserLocation(
                position.latitude, position.longitude);

            _mapController.move(
                LatLng(position.latitude, position.longitude), 13);

            setState(() {});
          } catch (e) {
            print(S.of(context).positionUpdateError + ': $e');
          }
        });
  }

  void _stopPositionUpdates() {
    _positionUpdateTimer?.cancel();
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(S.of(context).locationServiceDisabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(S.of(context).locationPermissionDenied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(S.of(context).locationPermissionPermanentlyDenied);
    }

    return await Geolocator.getCurrentPosition();
  }

  void _subscribeToUserLocations() {
    _locationSubscription = supabaseService.subscribeToUserLocations().listen(
          (data) {
        setState(() {
          _userLocations.clear();
          for (final record in data) {
            final lat = record['latitude'];
            final lng = record['longitude'];
            if (lat != null && lng != null) {
              _userLocations[record['id']] = LatLng(
                lat,
                lng,
              );
            } else {
              print(S.of(context).nullLatLngError);
            }
          }
        });
      },
      onError: (error) {
        print(S.of(context).locationSubscriptionError + ': $error');
      },
    );
  }

  void _unsubscribeFromUserLocations() {
    _locationSubscription?.cancel();
  }

  List<Marker> _buildMarkers() {
    final userId = supabaseService.client.auth.currentUser?.id;

    return _userLocations.entries.map((entry) {
      bool isCurrentUser = entry.key == userId;
      return Marker(
        point: entry.value,
        width: 40,
        height: 40,
        child: Icon(
          Icons.electric_bike,
          color: isCurrentUser ? Colors.red : Colors.blue,
          size: 40,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).mapScreenTitle),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(35.6812, 139.7671),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _buildMarkers(),
          ),
        ],
      ),
    );
  }
}
