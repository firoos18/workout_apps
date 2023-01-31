import 'package:flutter/material.dart';
import 'package:workout_apps/models/exercise.dart';
import 'package:workout_apps/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  List<Workout> workoutList = [
    Workout(name: "Upper Body", exercises: [
      Exercise(
        name: "Bicep Curls",
        weight: "12",
        reps: "10",
        sets: "3",
      ),
      Exercise(
        name: "Incline Bicep Curls",
        weight: "8",
        reps: "10",
        sets: "3",
      )
    ]),
    Workout(name: "Lower Body", exercises: [
      Exercise(
        name: "Squats",
        weight: "10",
        reps: "10",
        sets: "3",
      ),
      Exercise(
        name: "Leg Press",
        weight: "50",
        reps: "10",
        sets: "3",
      )
    ])
  ];

  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get the length of a given workout
  int numberOfExerciseInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
  }

  // add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
      ),
    );

    notifyListeners();
  }

  // check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    // find the relevant exercise in the workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  // return relevant workout object, given the workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  // return relevant workout object, given the workout name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find the relevant workout
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    // then find the relevant exercise in the workout
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exerciseName == exercise.name);

    return relevantExercise;
  }
}