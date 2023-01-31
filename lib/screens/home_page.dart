import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_apps/data/workout_data.dart';
import 'package:workout_apps/screens/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controller
  final newWorkoutNameController = TextEditingController();

  createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Create new workout'),
              content: TextField(
                controller: newWorkoutNameController,
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
            ));
  }

  void save() {
    // get workout name from controller
    String newWorkoutName = newWorkoutNameController.text;
    // add workout to workout data list
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
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
    newWorkoutNameController.clear();
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(
                  workoutName: workoutName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Workout Tracker'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: value.workoutList.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getWorkoutList()[index].name),
            trailing: IconButton(
                onPressed: () =>
                    goToWorkoutPage(value.getWorkoutList()[index].name),
                icon: const Icon(Icons.chevron_right)),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
