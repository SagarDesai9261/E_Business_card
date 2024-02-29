import 'package:bloc/bloc.dart';
import 'package:e_business_card/src/repositories/Data_Repository.dart';
import '../bloc/blocs.dart';
import 'package:meta/meta.dart';

class DataBloc extends Bloc<UsersEvent, UsersState> {
  final DataRepository dataRepository;

  DataBloc({@required this.dataRepository})
      : assert(dataRepository != null),
        super(InitialUsersState());

  UsersState get initialState => InitialUsersState();

  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    if (event is FetchData) {
      yield UsersLoading();
      try {
        final List<Object> responseData = await dataRepository.getData();
        yield UsersLoaded(responseData: responseData);
      } catch (e) {
        print('Error in Data bloc: $e');
        yield UsersError();
      }
    }
  }
}
