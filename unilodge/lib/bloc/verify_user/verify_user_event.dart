import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class VerificationrEvent extends Equatable {
  const VerificationrEvent();

  @override
  List<Object> get props => [];
}

class CheckFaceEvent extends VerificationrEvent {
  final File image;

  const CheckFaceEvent(this.image);
  @override
  List<Object> get props => [image];
}

class CheckIdEvent extends VerificationrEvent {
  final File image;

  const CheckIdEvent(this.image);
  @override
  List<Object> get props => [image];
}

class VerifyUserEvent extends VerificationrEvent {}
