import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radhe/app/components/common_methos.dart';
import 'package:radhe/app/components/custom_dialog.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/models/category_model.dart';
import 'package:radhe/models/user_model.dart';
import 'package:radhe/utils/process_indicator.dart';

import '../../models/expenses_model.dart';
import '../../models/product_model.dart';

class DataController extends GetxController {
  RxList<UserModel> userList = <UserModel>[].obs;
  static Circle processIndicator = Circle();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future fetchUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      userList.assignAll(
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
      userList.refresh();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Stream<List<ExpenseModel>> getUserExpenses(String userId) {
    return FirebaseFirestore.instance
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      List<ExpenseModel> expenses = snapshot.docs
          .map((doc) => ExpenseModel.fromJson(doc.data()))
          .toList();

      // Sort the expenses locally by date in descending order
      expenses.sort((a, b) => b.date.compareTo(a.date));

      return expenses;
    });
  }

  Future addExpense({
    required double amount,
    required String description,
    required String userId,
    required BuildContext context,
  }) async {
    processIndicator.show(context);
    try {
      // Add expense to 'expenses' collection
      DocumentReference expenseRef = await FirebaseFirestore.instance
          .collection('expenses')
          .add(ExpenseModel(
            id: '',
            userId: userId,
            amount: amount,
            description: description,
            date: DateTime.now(),
          ).toJson());

      // Get the document ID of the newly added expense
      String expenseId = expenseRef.id;

      // Update the same document in the 'expenses' collection with additional data
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expenseId)
          .update({
        'id': expenseId,
      });

      processIndicator.hide(context);
      CommonMethod.getXSnackBar(
        "Success",
        "Expense added successfully",
        success,
      );
      print('Expense added successfully');
    } catch (e) {
      processIndicator.hide(context);
      CommonMethod.getXSnackBar("Failed", "Error adding expense: $e", red);
    }
  }

  Stream<double> getTotalExpenseStream(String userId) async* {
    yield await getTotalExpense(userId);
  }

  Future<double> getTotalExpense(String userId) async {
    try {
      // Query expenses for the specified user
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();

      // Calculate the total expense amount
      double totalExpense = querySnapshot.docs.fold(0, (total, doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        return total + (data['amount'] ?? 0.0);
      });

      return totalExpense;
    } catch (e) {
      // Handle errors
      print('Error calculating total expense: $e');
      return 0.0; // Return 0 if an error occurs
    }
  }
}
