import 'package:hive/hive.dart';
import 'package:workout_apps/datetime/date_time.dart';
import 'package:workout_apps/models/exercise.dart';
import 'package:workout_apps/models/workout.dart';

class HiveDatabase {
  // reference hive box
  final _myBox = Hive.box('workout_database');

  // check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print('Previous data does NOT exists');
      _myBox.put("START_DATE", todayDateYYYYMMDD());
      return false;
    } else {
      print('Previous data does exists');
      _myBox.put("START_DATE", todayDateYYYYMMDD());
      return true;
    }
  }

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    // convert workout object into lists of string
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /* 
    check if any of the exercise is have been done 
    we will put a 0 or 1 for each yyyymmdd date
    */

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 0);
    }

    // save to hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  // read data, and return list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get('EXERCISES');

    // create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      // each workout can have multiple exercises
      List<Exercise> exerciseInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        // so add each exercise into a list
        exerciseInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == 'true' ? true : false,
          ),
        );
      }

      // create individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);

      // add individual workout to overall list
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  // check if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    // go thru each workout
    for (var workout in workouts) {
      // go thru each exercise in workout
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return completion status of given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    // return 0 or 1, if null then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }

  // converts workout objects into a list -> eg. [ 'upperbody', 'lowerbody' ]
  List<String> convertObjectToWorkoutList(List<Workout> workouts) {
    List<String> workoutList = [];

    for (int i = 0; i < workouts.length; i++) {
      // in each workout, add the name, followed by lists of exercise
      workoutList.add(
        workouts[i].name,
      );
    }

    return workoutList;
  }

  // converts the exercise in a workout object into a list of strings
  List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
    List<List<List<String>>> exerciseList = [
      /* 
    [

      Upper Body
      [ [biceps, 10kg, 10reps, 3sets], [triceps, 20kg, 10reps, 3sets] ],

      Lower Body
      [ [squats, 10kg, 10reps, 3sets], [leg press, 20kg, 10reps, 3sets] ]

    ]
  
  
  */
    ];

    // go thru each workout
    for (int i = 0; i < workouts.length; i++) {
      // get exercises from each workout
      List<Exercise> exerciseInWorkout = workouts[i].exercises;

      List<List<String>> individualWorkout = [
        // upper body
        // [ [biceps, 10kg, 10reps, 3sets], [triceps, 10kg, 10reps, 3sets] ]
      ];

      // go thru each exercise in workoutList;
      for (int j = 0; j < exerciseInWorkout.length; j++) {
        List<String> individualExercise = [
          // [ biceps, 10kg, 10reps, 3sets ]
        ];

        individualExercise.addAll(
          [
            exerciseInWorkout[j].name,
            exerciseInWorkout[j].weight,
            exerciseInWorkout[j].reps,
            exerciseInWorkout[j].sets,
            exerciseInWorkout[j].isCompleted.toString(),
          ],
        );
        individualWorkout.add(individualExercise);
      }

      exerciseList.add(individualWorkout);
    }

    return exerciseList;
  }
}
