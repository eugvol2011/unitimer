import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:unitimer/unistore.dart';
import 'package:unitimer/utils.dart';
import 'package:unitimer/widgets/workout_timer.dart';

class TotalProgressBar extends StatelessWidget {
  UniStore store = VxState.store as UniStore;

  final double width;
  final double height;
  final List<DocumentSnapshot<Map<String, dynamic>>> detailsList;
  final WorkoutTimer workoutTimer;

  TotalProgressBar(
      {required this.width,
      required this.height,
      required this.detailsList,
      required this.workoutTimer});

  @override
  Widget build(BuildContext context) {
    final List<Widget> barsList = List.empty(growable: true);

    if (detailsList.isNotEmpty) {
      detailsList.forEach(((element) {
        num duration = element.data()!['duration'];
        double barWidth =
            (duration.toDouble() / store.totalDetailsDuration.toDouble()) *
                (width - Utils.totalBarBorderWidth * 2);

        barsList.add(Container(
          height: height,
          width: barWidth,
          color: Color(int.parse(
              '0xff${element.data()!['color'].toString().replaceAll('#', '').toUpperCase()}')),
        ));
      }));
      SetTotalProgressBarWidth(width);
      ChangeTotalProgressLeftPosition(-height * 2);
    }

    return detailsList.isNotEmpty
        ? [
            Stack(clipBehavior: Clip.none, children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: Utils.totalBarBorderWidth,
                  color: Utils.totalBarBorderColor,
                  style: BorderStyle.solid,
                )),
                child: barsList.row(),
              ),
              VxBuilder(
                  mutations: {ChangeTotalProgressLeftPosition},
                  builder: (context, UniStore, _) {
                    return Positioned(
                        left: store.totalProgressLeftPosition,
                        top: -height / 2,
                        child: VxCircle(
                          backgroundColor: Utils.totalBarCircleColor,
                          radius: height * 2,
                        ));
                  }),
            ]),
            VxBuilder(
              builder: (context, Unistore, _) {
                return '${Utils.SecToTime(workoutTimer.getTotalElapsedSec())}/${Utils.SecToTime(store.totalDetailsDuration.toDouble())}'
                    .text
                    .black
                    .lg
                    .bold
                    .make()
                    .py(5);
              },
              mutations: {ChangeTotalProgressLeftPosition},
            )
          ].vStack()
        : const CircularProgressIndicator();
  }
}
