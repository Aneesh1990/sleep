import 'package:equatable/equatable.dart';

abstract class ForgotPassEvent extends Equatable {}

class SendButtonPressed extends ForgotPassEvent {
  String email;

  SendButtonPressed({this.email});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
