import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  String exerciseName;
  String reps;
  String sets;
  String weight;
  bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile(
      {super.key,
      required this.exerciseName,
      required this.reps,
      required this.sets,
      required this.weight,
      required this.isCompleted,
      required this.onCheckBoxChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exerciseName),
      subtitle: Row(
        children: [
          Chip(
            label: Text('$reps reps'),
          ),
          const SizedBox(
            width: 4,
          ),
          Chip(
            label: Text("$weight kg"),
          ),
          const SizedBox(
            width: 4,
          ),
          Chip(
            label: Text(
              "$sets sets",
            ),
          )
        ],
      ),
      trailing: Checkbox(
        value: isCompleted,
        onChanged: (value) => onCheckBoxChanged!(value),
      ),
    );
  }
}
