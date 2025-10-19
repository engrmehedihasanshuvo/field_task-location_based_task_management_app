import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:neos_coder/core/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_detail_provider.dart';
import '../../services/auth_service.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskEntity task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _posSub;

  LatLng? _myLocation;
  final Set<Marker> _markers = {};
  final Set<Polyline> _lines = {};

  @override
  void initState() {
    super.initState();
    _initLocationUpdates();
  }

  Future<void> _initLocationUpdates() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    _updateMyLocation(LatLng(pos.latitude, pos.longitude));

    _posSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 3),
    ).listen((Position p) {
      _updateMyLocation(LatLng(p.latitude, p.longitude));
    });
  }

  void _updateMyLocation(LatLng loc) {
    setState(() {
      _myLocation = loc;
      _markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('task'),
          position: LatLng(widget.task.lat, widget.task.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Task Location'),
        ))
        ..add(Marker(
          markerId: const MarkerId('me'),
          position: loc,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'My Location'),
        ));

      _lines
        ..clear()
        ..add(Polyline(
          polylineId: const PolylineId('path'),
          points: [loc, LatLng(widget.task.lat, widget.task.lng)],
          color: Colors.blue,
          width: 4,
        ));

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(loc),
      );
    });

    final detail = context.read<TaskDetailProvider>();
    detail.updateDistance(widget.task.lat, widget.task.lng, loc.latitude, loc.longitude);
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = context.read<TaskDetailProvider>();
    detail.setTask(widget.task);
    final auth = context.read<AuthService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Consumer<TaskDetailProvider>(
        builder: (_, p, __) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.task?.title ?? '', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(widget.task.lat, widget.task.lng), zoom: 16),
                  onMapCreated: (controller) => _mapController = controller,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  scrollGesturesEnabled: true,
                  markers: _markers,
                  polylines: _lines,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(p.task?.description ?? 'No description'),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: p.withinRadius ? p.doCheckIn : null,
                          icon: const Icon(Icons.how_to_reg),
                          label: Text(p.withinRadius ? 'Check In' : 'Go Near Location'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: (p.withinRadius && p.task?.assigneeId == auth.userId && p.task?.status != TaskStatus.completed) ? () => p.complete(auth.userId!) : null,
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Complete'),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Text(
                      p.withinRadius
                          ? 'You are within ${AppConstraints.checkRadiusMeters.toStringAsFixed(0)} meters of the task location.'
                          : 'You are ${p.distance.toStringAsFixed(2)} meters away from the task location. Please move closer to check in.',
                      style: TextStyle(color: p.withinRadius ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
