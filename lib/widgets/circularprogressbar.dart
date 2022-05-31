import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:unitimer/unistore.dart';
import 'package:unitimer/utils.dart';
import 'package:unitimer/widgets/workout_timer.dart';

class CircularProgressBar extends StatelessWidget {
  WorkoutTimer workoutTimer;

  CircularProgressBar(this.workoutTimer);

  UniStore store = VxState.store as UniStore;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        VxBuilder(
          mutations: {ChangeProgressValue},
          builder: (context, Unistore, _) => SizedBox(
            width: context.screenWidth * Utils.circularProgressSizeOfScreen,
            height: context.screenWidth * Utils.circularProgressSizeOfScreen,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(store.progressColor),
              backgroundColor: Utils.circularProgressBackgroundColor,
              value: store.progressValue,
              strokeWidth: Utils.circularProgressStrokeWidth,
            )
                .circle(backgroundColor: Utils.circularProgressInternalColor)
                .onInkTap(() {
              workoutTimer.changeProgressLabelMode();
              workoutTimer.changeProgressLabel();
            }),
          ),
        ),
        VxBuilder(
            mutations: {ChangeProgressLabel},
            builder: (context, UniStore, _) {
              return '${store.progressLabel}'
                  .text
                  .bold
                  .size((context.screenWidth *
                              Utils.circularProgressSizeOfScreen -
                          Utils.circularProgressStrokeWidth) *
                      Utils.circularProgressLabelSizeOfSizedBox)
                  .make()
                  .onInkTap(() {
                workoutTimer.changeProgressLabelMode();
                workoutTimer.changeProgressLabel();
              });
            }),
      ],
    );
  }
}
