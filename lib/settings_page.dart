import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:historical_restaurants/bloc/settings_bloc.dart';
import 'package:historical_restaurants/event/settings_page_event.dart';
import 'package:historical_restaurants/preference_wrapper.dart';
import 'package:historical_restaurants/state/settings_state.dart';
import 'package:historical_restaurants/widget/animated_filter_chip.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const Map _titleMap = {
    SortOptions.alphabeticallyAscending: "Alphabetically Ascending",
    SortOptions.alphabeticallyDescending: "Alphabetically Descending",
    SortOptions.cityAscending: "City Ascending",
    SortOptions.cityDescending: "City Descending",
    SortOptions.distanceAscending: "Location Ascending",
    SortOptions.distanceDescending: "Location Descending",
    SortOptions.dateAscending: "Date Ascending",
    SortOptions.dateDescending: "Date Descending"
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsLoadedState) {
        return SingleChildScrollView(
            child: Column(children: [
          Card(
              elevation: 20,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Sort By",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.black))),
                ListView.builder(
                  padding: const EdgeInsets.all(4.0),
                  shrinkWrap: true,
                  itemCount: SortOptions.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        context.read<SettingsBloc>().add(
                            SortOptionSelectedEvent(SortOptions.values[index]));
                      },
                      selected: state.sortOption == SortOptions.values[index],
                      selectedTileColor: Colors.blue,
                      title: Text(
                        _titleMap[SortOptions.values[index]],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: state.sortOption == SortOptions.values[index]
                                ? Colors.white
                                : Colors.black),
                      ),
                    );
                  },
                )
              ])),
          Card(
              elevation: 20.0,
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Filter By City",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.black))),
                Wrap(
                    spacing: 2,
                    alignment: WrapAlignment.spaceEvenly,
                    children: _getFilterChips(context, state.cityFilters))
              ]))
        ]));
      }
      return const Text("");
    });
  }

  List<Widget> _getFilterChips(
      BuildContext context, Map<String, bool> filters) {
    var filterChips = <Widget>[];
    filters.forEach((key, value) {
      filterChips.add(AnimatedFilterChip(
          onTap: () =>
              context.read<SettingsBloc>().add(CityFilterSelectedEvent(key)),
          title: <String>() => key,
          initialSelected: value));
    });
    return filterChips;
  }
}
