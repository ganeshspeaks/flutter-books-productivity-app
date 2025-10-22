import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:presum/constants/constants.dart';


class VisionBoardPage extends StatefulWidget {
  const VisionBoardPage({super.key});

  @override
  State<VisionBoardPage> createState() => _VisionBoardPageState();
}

class _VisionBoardPageState extends State<VisionBoardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Vision Board', style: headingStyle.copyWith(color: backgroundColor)),
        backgroundColor: secondaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
        
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '“Define Your Vision and Plan the Tasks to Make It Happen.”',
                  textAlign: TextAlign.center,
                  style: headingStyle.copyWith(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700], 
                  ),
                ),
              ),
            ),
        
        
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .collection('visionBoard')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
              
                  var goals = snapshot.data!.docs;
              
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        var goal = goals[index];
                        return GoalTile(goal: goal, index: index,);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalDialog,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: backgroundColor,),
      ),
    );
  }

  void _showAddGoalDialog() {
    String goalTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: const Text('Add Goal', style: bodyTextStyle),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Goal Title',
              hintStyle: bodyTextStyle,
            ),
            onChanged: (value) => goalTitle = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: bodyTextStyle),
            ),
            TextButton(
              onPressed: () {
                if (goalTitle.isNotEmpty) {
                  _addGoal(goalTitle);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add', style: bodyTextStyle),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addGoal(String title) async {
    final userId = _auth.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('visionBoard')
        .add({'title': title});
  }
}

// Goal Tile

class GoalTile extends StatelessWidget {
  final QueryDocumentSnapshot goal;
  final int index;

  const GoalTile({super.key, required this.goal, required this.index}); // Add index to constructor

  @override
  Widget build(BuildContext context) {
    String goalId = goal.id;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: backgroundColor,
      child: ExpansionTile(
        initiallyExpanded: index == 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(goal['title'], style: bodyTextStyle),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blueAccent),
                  onPressed: () => _showAddTaskDialog(context, goalId),
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditGoalDialog(context, goal);
                    } else if (value == 'delete') {
                      _deleteGoal(goalId);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
          ],
        ),
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('visionBoard')
                .doc(goalId)
                .collection('tasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              var tasks = snapshot.data!.docs;

              return Column(
                children: tasks.map((task) => TaskTile(task: task)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }



  Future<void> _showAddTaskDialog(BuildContext context, String goalId) {
    String taskTitle = '';
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Task Title'),
            onChanged: (value) => taskTitle = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskTitle.isNotEmpty) {
                  _addTask(goalId, taskTitle);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTask(String goalId, String taskTitle) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visionBoard')
        .doc(goalId)
        .collection('tasks')
        .add({'title': taskTitle, 'completed': false});
  }

  Future<void> _deleteGoal(String goalId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visionBoard')
        .doc(goalId)
        .delete();
  }

  Future<void> _showEditGoalDialog(BuildContext context, QueryDocumentSnapshot goal) {
    String goalTitle = goal['title'];

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Goal'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Goal Title'),
            onChanged: (value) => goalTitle = value,
            controller: TextEditingController(text: goal['title']),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editGoal(goal.id, goalTitle);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editGoal(String goalId, String title) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visionBoard')
        .doc(goalId)
        .update({'title': title});
  }
}

// Task Tile

class TaskTile extends StatelessWidget {
  final QueryDocumentSnapshot task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task['completed'],
        onChanged: (value) {
          _toggleTaskCompletion(task.id, value);
        },
      ),
      title: Text(
        task['title'], 
        style: bodyTextStyle.copyWith(
          decoration: task['completed'] ? TextDecoration.lineThrough : TextDecoration.none,
        ),
        
      ),
      trailing: PopupMenuButton(
        onSelected: (value) {
          if (value == 'edit') {
            _showEditTaskDialog(context, task);
          } else if (value == 'delete') {
            _deleteTask(task.id);
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }

  Future<void> _toggleTaskCompletion(String taskId, bool? value) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visionBoard')
        .doc(task.reference.parent.parent!.id)
        .collection('tasks')
        .doc(taskId)
        .update({'completed': value});
  }

  Future<void> _showEditTaskDialog(BuildContext context, QueryDocumentSnapshot task) {
    String taskTitle = task['title'];

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Task Title'),
            onChanged: (value) => taskTitle = value,
            controller: TextEditingController(text: task['title']),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editTask(task.id, taskTitle);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editTask(String taskId, String title) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visionBoard')
        .doc(task.reference.parent.parent!.id)
        .collection('tasks')
        .doc(taskId)
        .update({'title': title});
  }

  Future<void> _deleteTask(String taskId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visionBoard')
        .doc(task.reference.parent.parent!.id)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
