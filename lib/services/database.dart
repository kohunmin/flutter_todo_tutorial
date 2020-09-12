import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseServices {
  uploadUserInfo(String userId, Map userMap) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .setData(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  updateTask(String userId, Map taskMap) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("tasks")
        .add(taskMap);
  }

  getTasks(String userId) async {
    return await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("tasks")
        .snapshots();
  }

  updateCompleted(String userId, String taskId, Map taskMap) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("tasks")
        .document(taskId)
        .updateData(taskMap);
  }

  deleteTask(String userId, String taskId) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("tasks")
        .document(taskId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }
}
