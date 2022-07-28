import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:historical_restaurants/state/list_state.dart';
import 'package:injectable/injectable.dart';

import '../repository/list_repository.dart';

@injectable
class ListCubit extends Cubit<ListState> {
  final ListRepository _repository;

  _onSettingsChanged() => _getRestaurants();

  ListCubit(this._repository) : super(ListLoadingState()) {
    _getRestaurants();
    _repository.registerSettingsChangeListener(_onSettingsChanged);
  }

  void _getRestaurants() async {
    emit(ListLoadedState(await _repository.getRestaurants()));
  }

  @override
  Future<void> close() {
    _repository.unregisterSettingsChangeListener(_onSettingsChanged);
    return super.close();
  }
}
