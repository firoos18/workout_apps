import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_apps/components/exercise_tile.dart';
import 'package:workout_apps/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  String workoutName;
  WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // text controller
  final exerciseNameController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();
  final weightController = TextEditingController();

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(hintText: 'Exercise Name'),
              controller: exerciseNameController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Number of Reps'),
              controller: repsController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Number of Sets'),
              controller: setsController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Amount of Weights'),
              controller: weightController,
            ),
          ],
        ),
        actions: [
          // save
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  void save() {
    // get exercise name from controller
    String newExerciseName = exerciseNameController.text;
    // add exercise to workout data list
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weightController.text,
      repsController.text,
      setsController.text,
    );
    // pop dialog
    Navigator.pop(context);
    // clear textfield
    clear();
  }

  void cancel() {
    // pop dialog
    Navigator.pop(context);
    // clear textfield
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    repsController.clear();
    setsController.clear();
    weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: value.numberOfExerciseInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .name,
            reps: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .reps,
            sets: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .sets,
            weight: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .weight,
            isCompleted: value
                .getRelevantWorkout(widget.workoutName)
                .exercises[index]
                .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
              widget.workoutName,
              value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .name,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
