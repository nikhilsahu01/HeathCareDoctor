import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

import '../../../core/utils/custom_widgets/custom_appBar.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? mapController;
  LatLng selectedLatLng = const LatLng(28.6139, 77.2090); // Default Delhi
  Placemark? selectedPlace;

  String address = "";
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  void _onMapTap(LatLng latLng) async {
    setState(() {
      selectedLatLng = latLng;
    });

    List<Placemark> placemarks =
    await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    selectedPlace = placemarks.first;
    address = [
      selectedPlace?.name,
      selectedPlace?.subLocality,
      selectedPlace?.locality,
    ]
        .where((e) => e != null && e!.isNotEmpty)
        .join(", ");

    // address =
    // "${selectedPlace!.street}, ${selectedPlace!.locality}, ${selectedPlace!.administrativeArea}, ${selectedPlace!.postalCode}, ${selectedPlace!.country}";

    setState(() {});
  }
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).requestFocus(searchFocusNode);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Select Location'),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLatLng,
              zoom: 14,
            ),
            onTap: _onMapTap,
            markers: {
              Marker(
                markerId: const MarkerId("selected"),
                position: selectedLatLng,
              )
            },
          ),

          /// 🔍 Search Bar
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: searchController,
              focusNode: searchFocusNode,

              googleAPIKey: "AIzaSyCSk_LBk7QP0k4YUfX61t_QF8ItPuZzsoc",
              inputDecoration: const InputDecoration(
                hintText: "Search location",
                filled: true,
                fillColor: Colors.white,
              ),
              debounceTime: 800,
              // countries: ["in"],
              isLatLngRequired: true,
              getPlaceDetailWithLatLng: (prediction) async {
                double lat = double.parse(prediction.lat!);
                double lng = double.parse(prediction.lng!);

                selectedLatLng = LatLng(lat, lng);

                mapController?.animateCamera(
                  CameraUpdate.newLatLng(selectedLatLng),
                );

                List<Placemark> placemarks =
                await placemarkFromCoordinates(lat, lng);

                selectedPlace = placemarks.first;

                address =
                "${selectedPlace!.name}, ${selectedPlace!.locality}, ${selectedPlace!.administrativeArea}, ${selectedPlace!.postalCode}, ${selectedPlace!.country}";

                setState(() {});
              },
              itemClick: (prediction) {},
            ),
          ),
          Positioned(
            bottom: 80,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                address.isEmpty ? "Select location" : address,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          /// ✅ Confirm Button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (selectedPlace == null) return;

                Navigator.pop(context, {
                  "address": address,
                  "lat": selectedLatLng.latitude,
                  "lng": selectedLatLng.longitude,
                  "city": selectedPlace!.locality,
                  "state": selectedPlace!.administrativeArea,
                  "pincode": selectedPlace!.postalCode,
                  "country": selectedPlace!.country,
                });
              },
              child: const Text("Confirm Location"),
            ),
          )
        ],
      ),
    );
  }
}