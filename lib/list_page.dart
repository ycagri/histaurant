import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:historical_restaurants/database/restaurant.dart';
import 'package:historical_restaurants/state/list_state.dart';

import 'bloc/list_cubit.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit, ListState>(builder: (context, state) {
      if (state is ListLoadedState) {
        return Scaffold(
            body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Autocomplete<Restaurant>(
                optionsBuilder: (query) {
                  if (query.text.isEmpty) {
                    return state.restaurants;
                  }
                  return state.restaurants.where((element) {
                    var searchTerm = query.text.toLowerCase();
                    return element.name.toLowerCase().contains(searchTerm) ||
                        element.city.toLowerCase().contains(searchTerm) ||
                        element.district.toLowerCase().contains(searchTerm) ||
                        element.year
                            .toString()
                            .toLowerCase()
                            .contains(searchTerm);
                  });
                },
                fieldViewBuilder: (context, controller, node, onSubmit) {
                  return TextField(
                      controller: controller,
                      focusNode: node,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: IconButton(
                            onPressed: () {
                              controller.clear();
                              node.unfocus();
                            },
                            icon: const Icon(Icons.clear)),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        hintText: 'Search',
                      ));
                },
                onSelected: (restaurant) =>
                    _showRestaurantInfo(context, restaurant),
              )),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var restaurant = state.restaurants[index];
                    return Card(
                        child: ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(restaurant.logo ??
                            "https://www.creativefabrica.com/wp-content/uploads/2019/08/Restaurant-Logo-by-Koko-Store.jpg"),
                      ),
                      title: Text(restaurant.toString(),
                          style: Theme.of(context).textTheme.titleSmall),
                      subtitle: Text(restaurant.city,
                          style: Theme.of(context).textTheme.bodySmall),
                      trailing: Text(
                          "${restaurant.distance.toStringAsFixed(1)} km",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: _getTrailingTextColor(
                                      restaurant.distance))),
                      contentPadding: const EdgeInsets.all(4.0),
                      onTap: () => _showRestaurantInfo(
                          context, state.restaurants[index]),
                    ));
                  },
                  itemCount: state.restaurants.length,
                  padding: const EdgeInsets.all(2.0),
                  shrinkWrap: true))
        ]));
      }
      return const Text("");
    });
  }

  Color _getTrailingTextColor(double distance) {
    var red = distance > 500 ? 255 : (255.0 * (distance / 500.0)).toInt();
    var green = distance > 500 ? 0 : (255.0 * (1.0 - distance / 500.0)).toInt();
    return Color.fromARGB(255, red, green, 0);
  }

  void _showRestaurantInfo(BuildContext context, Restaurant r) {
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
                                    r.toString(),
                                    style: Theme.of(buildContext)
                                        .textTheme
                                        .titleLarge,
                                  )),
                              Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(r.desc,
                                      style: Theme.of(buildContext)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(height: 2.0)))
                            ],
                          ))));
        });
  }
}
