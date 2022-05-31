import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unitimer/widgets/workout_timer.dart';

class UniStore extends VxStore {
  List<DocumentSnapshot<Map<String, dynamic>>> detailsList =
      List.empty(growable: true);

  num totalDetailsDuration = 0;
  double totalProgressBarWidth = 0;

  double progressValue = 0;
  Color progressColor = Colors.green;

  String progressLabel = '';
  String startButtonLabel = 'Start';

  String steps = '?';

  List<Widget> totalProgressBarsList = List.empty(growable: true);

  double totalProgressLeftPosition = 0.0;
}

class GetDetailsList extends VxMutation<UniStore> {
  final firestoreInstance = FirebaseFirestore.instance;
  num totalDetailsDuration = 0;
  GetDetailsList();

  @override
  perform() async {
    await firestoreInstance.collection('details').get().then((value) {
      value.docs.forEach((element) {
        store!.detailsList.add(element);
        store!.totalDetailsDuration =
            store!.totalDetailsDuration + element.data()['duration'];
      });
    });
  }
}

class ChangeTotalProgressLeftPosition extends VxMutation<UniStore> {
  late final double totalProgressLeftPosition;

  ChangeTotalProgressLeftPosition(this.totalProgressLeftPosition);

  @override
  perform() {
    store!.totalProgressLeftPosition = totalProgressLeftPosition;
  }
}

class SetTotalProgressBarWidth extends VxMutation<UniStore> {
  late final double totalProgressBarWidth;

  SetTotalProgressBarWidth(this.totalProgressBarWidth);

  @override
  perform() {
    store!.totalProgressBarWidth = totalProgressBarWidth;
  }
}

class ChangeProgressValue extends VxMutation<UniStore> {
  late final double progressValue;

  ChangeProgressValue(this.progressValue);

  @override
  perform() {
    store!.progressValue = progressValue;
  }
}

class ChangeProgressColor extends VxMutation<UniStore> {
  late final Color progressColor;

  ChangeProgressColor(this.progressColor);

  @override
  perform() {
    store!.progressColor = progressColor;
  }
}

class ChangeStartButtonLabel extends VxMutation<UniStore> {
  late final WorkoutTimer timer;

  ChangeStartButtonLabel(this.timer);

  @override
  perform() {
    timer.getIsOn()
        ? store!.startButtonLabel = 'Pause'
        : store!.startButtonLabel = 'Start';
  }
}

class ChangeProgressLabel extends VxMutation<UniStore> {
  late final String progressLabel;

  ChangeProgressLabel(this.progressLabel);

  @override
  perform() {
    store!.progressLabel = progressLabel;
  }
}

class ChangeSteps extends VxMutation<UniStore> {
  late final String steps;

  ChangeSteps(this.steps);

  @override
  perform() {
    store!.steps = steps;
  }
}
