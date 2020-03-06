//import 'package:equatable/equatable.dart';
//import 'package:meta/meta.dart';
//
//abstract class LoginEvent extends Equatable {}
//
//class LoginButtonPressed extends LoginEvent {
//  String email, password;
//
//  LoginButtonPressed({this.email, this.password});
//
//  @override
//  // TODO: implement props
//  List<Object> get props => [email, password];
//
//  @override
//  String toString() {
//    return 'Submitted { email: $email, password: $password }';
//  }
//}
//
//class SignUpButtonPressed extends LoginEvent {
//  @override
//  // TODO: implement props
//  List<Object> get props => throw UnimplementedError();
//}
//
//class EmailChanged extends LoginEvent {
//  final String email;
//
//  EmailChanged({@required this.email});
//
//  @override
//  List<Object> get props => [email];
//
//  @override
//  String toString() => 'EmailChanged { email :$email }';
//}
//
//class PasswordChanged extends LoginEvent {
//  final String password;
//
//  PasswordChanged({@required this.password});
//
//  @override
//  List<Object> get props => [password];
//
//  @override
//  String toString() => 'PasswordChanged { password: $password }';
//}
