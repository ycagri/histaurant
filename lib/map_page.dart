import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:historical_restaurants/bloc/map_cubit.dart';
import 'package:historical_restaurants/state/map_state.dart';

import 'database/restaurant.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GoogleMapController? mapController;
    return BlocConsumer<MapCubit, MapState>(
      builder: (context, state) {
        if (state is MapRestaurantsLoadedState) {
          return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
                  const CameraPosition(target: LatLng(0.0, 0.0)),
              markers: state.restaurants
                  .map((e) => Marker(
                      markerId: MarkerId(e.id),
                      position: LatLng(e.lat, e.lon),
                      infoWindow: InfoWindow(
                          title: e.toString(),
                          onTap: () => _onMarkerTap(context, e))))
                  .toSet(),
              onMapCreated: (controller) {
                mapController = controller;
                BlocProvider.of<MapCubit>(context).getPosition();
              },
              compassEnabled: true,
              myLocationEnabled: true);
        }
        BlocProvider.of<MapCubit>(context).getRestaurants();
        return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Image.asset('assets/images/logo.png')));
      },
      listener: (context, state) {
        if (state is MapLoadingState) {
          BlocProvider.of<MapCubit>(context).getRestaurants();
        } else if (state is MapPositionLoadedState) {
          mapController
              ?.animateCamera(CameraUpdate.newCameraPosition(state.position));
        } else if (state is MapNavigateRestaurantState) {
          mapController
              ?.animateCamera(CameraUpdate.newCameraPosition(state.position));
          mapController?.showMarkerInfoWindow(MarkerId(state.id));
        } else if (state is LocationErrorState) {
          var snackBar = SnackBar(
            content: Text(AppLocalizations.of(context)!.locationError),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is RequestErrorState) {
          var snackBar = SnackBar(
            content: Text(AppLocalizations.of(context)!.requestError),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      buildWhen: (oldState, currentState) =>
          currentState is MapRestaurantsLoadedState,
      listenWhen: (oldState, currentState) =>
          currentState is! MapRestaurantsLoadedState,
    );
  }
}

void _onMarkerTap(BuildContext context, Restaurant element) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext buildContext) {
        return DraggableScrollableSheet(
            initialChildSize: 0.4,
            builder: (BuildContext context,
                    ScrollController scrollController) =>
                Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  element.toString(),
                                  style: Theme.of(buildContext)
                                      .textTheme
                                      .titleLarge,
                                )),
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(element.desc,
                                    style: Theme.of(buildContext)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(height: 2.0)))
                          ],
                        ))));
      });
}
