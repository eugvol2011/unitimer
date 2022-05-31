import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:unitimer/unistore.dart';
import 'package:unitimer/utils.dart';
import 'package:unitimer/widgets/totalprogressbar.dart';
import 'package:unitimer/widgets/workout_timer.dart';
import 'package:unitimer/widgets/circularprogressbar.dart';

class StartWorkoutWidget extends StatelessWidget {
  StartWorkoutWidget({Key? key}) : super(key: key);

  UniStore store = VxState.store as UniStore;

  late Stream<StepCount> _stepCountStream;

  void onStepCount(StepCount event) {
    ChangeSteps(event.steps.toString());
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    ChangeSteps('Step Count not available');
  }

  Future<void> initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } else {}
    //if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    GetDetailsList();
    WorkoutTimer workoutTimer = new WorkoutTimer();
    initPlatformState();

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        right: true,
        left: true,
        child: Stack(fit: StackFit.expand, children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(
                  colors: [Utils.primaryColor1, Utils.primaryColor2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight))
              .make(),
          [
            AppBar(
                automaticallyImplyLeading: true,
                title: 'Unitimer'.text.bold.size(24).make().shimmer(
                    primaryColor: Vx.teal500, secondaryColor: Vx.amber500),
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: Colors.transparent),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  VxBuilder(
                      mutations: {GetDetailsList},
                      builder: (context, Unistore, _) {
                        return TotalProgressBar(
                            width: context.screenWidth * 0.9,
                            height: 7,
                            detailsList: store.detailsList,
                            workoutTimer: workoutTimer);
                      }),
                  SizedBox(
                    height: 50,
                  ),
                  CircularProgressBar(workoutTimer),
                  SizedBox(
                    height: 30,
                  ),
                  VxBuilder(
                    mutations: {ChangeStartButtonLabel},
                    builder: (context, UniStore, _) => ElevatedButton(
                      onPressed: () {
                        if (store.detailsList.isNotEmpty) {
                          if (!workoutTimer.getIsOn()) {
                            workoutTimer.start();
                          } else {
                            workoutTimer.pause();
                          }
                          ChangeStartButtonLabel(workoutTimer);
                        }
                      },
                      child: Text(store.startButtonLabel),
                    ),
                  ),
                  VxBuilder(
                      mutations: {ChangeSteps},
                      builder: (context, Unistore, _) => Text(store.steps)),
                ],
              ),
            )
          ].vStack(),
        ]),
      ),
    );
  }
}
