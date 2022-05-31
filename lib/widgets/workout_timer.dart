import 'dart:async';
import 'package:velocity_x/velocity_x.dart';
import 'package:unitimer/unistore.dart';
import 'package:flutter/material.dart';

class WorkoutTimer {
  int detailIndex;
  double progressStep;
  String stringColor;
  double elapsedSec;
  double totalElapsedSec;
  bool isOn;
  UniStore store;
  bool firstStarted;
  String progressLabelPercent, progressLabelSecUp, progressLabelSecDown;
  int progressLabelMode;
  double totalProgressBarStep;

  WorkoutTimer()
      : detailIndex = -1,
        progressStep = 0,
        stringColor = '',
        elapsedSec = 0,
        totalElapsedSec = 0,
        isOn = false,
        store = VxState.store as UniStore,
        firstStarted = true,
        progressLabelPercent = '',
        progressLabelSecUp = '',
        progressLabelSecDown = '',
        progressLabelMode = 0,
        totalProgressBarStep = 0.0;

  void changeProgressLabelMode() {
    this.progressLabelMode++;
    if (this.progressLabelMode >= 3) this.progressLabelMode = 0;
  }

  void changeProgressLabel() {
    switch (this.progressLabelMode) {
      case 0:
        ChangeProgressLabel(this.progressLabelSecDown);
        break;
      case 1:
        ChangeProgressLabel(this.progressLabelPercent);
        break;
      case 2:
        ChangeProgressLabel(this.progressLabelSecUp);
        break;
    }
  }

  bool getIsOn() {
    return this.isOn;
  }

  double getTotalElapsedSec() {
    return this.totalElapsedSec;
  }

  void start() {
    this.isOn = true;
    this.totalProgressBarStep = store.totalProgressBarWidth /
        (store.totalDetailsDuration.toDouble() * 1000 / 100);
    print('totalProgressBarStep=${this.totalProgressBarStep}');
    if (this.firstStarted) goOn();
  }

  void goOn() {
    this.firstStarted = false;
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (this.isOn) {
        if ((store.progressValue == 0 && this.detailIndex == -1) ||
            (store.progressValue >= 1 &&
                this.detailIndex < store.detailsList.length - 1)) {
          this.detailIndex++;
          this.progressStep = (1 /
                  (store.detailsList
                          .elementAt(detailIndex)
                          .data()!['duration'] *
                      1000)) *
              100;
          this.stringColor =
              '0xff${store.detailsList.elementAt(detailIndex).data()!['color'].toString().replaceAll('#', '').toUpperCase()}';
          ChangeProgressColor(Color(int.parse(this.stringColor)));
          ChangeProgressValue(0.0);
          this.elapsedSec = 0;
        } else if (store.progressValue >= 1 &&
            this.detailIndex == store.detailsList.length - 1) {
          timer.cancel();
        }
        ChangeProgressValue(store.progressValue + progressStep);
        this.elapsedSec = this.elapsedSec + 0.1;
        this.totalElapsedSec = this.totalElapsedSec + 0.1;
        this.progressLabelPercent =
            '${(store.progressValue * 100).truncate()}%';
        this.progressLabelSecUp = '${elapsedSec.truncate()}s';
        this.elapsedSec <= 1
            ? this.progressLabelSecDown =
                '${(store.detailsList.elementAt(detailIndex).data()!['duration']).truncate().abs()}s'
            : this.progressLabelSecDown =
                '${(store.detailsList.elementAt(detailIndex).data()!['duration'] - elapsedSec).truncate().abs()}s';
        changeProgressLabel();
        ChangeTotalProgressLeftPosition(
            store.totalProgressLeftPosition + this.totalProgressBarStep);
      }
    });
  }

  void pause() {
    this.isOn = false;
  }
}
