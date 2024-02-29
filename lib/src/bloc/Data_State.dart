import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UsersState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialUsersState extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final responseData;

  UsersLoaded({@required this.responseData}) : assert(responseData != null);
}

class UsersError extends UsersState {}
