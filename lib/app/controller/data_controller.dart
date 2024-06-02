
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:radhe/app/components/common_methos.dart';
import 'package:radhe/app/utils/colors.dart';
import 'package:radhe/models/user_model.dart';
import 'package:radhe/utils/process_indicator.dart';

import '../../models/expenses_model.dart';

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


Stream<List<ExpenseModel>> getUserLastExpenses(String userId) {
  return FirebaseFirestore.instance
      .collection('expenses')
      .where('userId', isEqualTo: userId)
      .orderBy('date', descending: true)
      .limit(2)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data()))
        .toList();
  });
}



  Stream<List<ExpenseModel>> getAllExpenses() {
    return FirebaseFirestore.instance
        .collection('expenses')
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
    // required String description,
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
            // description: description,
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

  Future updateExpense({
    required String expenseId,
    required double amount,
    // required String description,
    required String userId,
    required BuildContext context,
  }) async {
    processIndicator.show(context);
    try {
      // Update expense in 'expenses' collection
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expenseId)
          .update({
        'userId': userId,
        'amount': amount,
        // 'description': description,
        // 'date': DateTime.now(),
      });

      processIndicator.hide(context);
      CommonMethod.getXSnackBar(
        "Success",
        "Expense updated successfully",
        success,
      );
      print('Expense updated successfully');
    } catch (e) {
      processIndicator.hide(context);
      CommonMethod.getXSnackBar("Failed", "Error updating expense: $e", red);
    }
  }

  Future deleteExpense({
    required String expenseId,
    required BuildContext context,
  }) async {
    processIndicator.show(context);
    try {
      // Delete expense from 'expenses' collection
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expenseId)
          .delete();

      processIndicator.hide(context);
      CommonMethod.getXSnackBar(
        "Success",
        "Expense deleted successfully",
        success,
      );
      print('Expense deleted successfully');
    } catch (e) {
      processIndicator.hide(context);
      CommonMethod.getXSnackBar("Failed", "Error deleting expense: $e", red);
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

  Stream<double> getAllTotalExpenseStream() async* {
    yield await getAllTotalExpense();
  }

  Future<double> getAllTotalExpense() async {
    try {
      // Query expenses for the specified user
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('expenses').get();

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

  Future<void> deleteUserAndExpenses(String userId) async {
    try {
      // Delete all expenses associated with the user
      await deleteAllExpenses(userId);

      // Delete the user document
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      print('User $userId and their associated expenses have been deleted.');
    } catch (e) {
      // Handle errors
      print('Error deleting user and expenses: $e');
    }
  }

  Future<void> deleteAllExpenses(String userId) async {
    try {
      // Get a reference to the 'expenses' collection
      CollectionReference expensesRef =
          FirebaseFirestore.instance.collection('expenses');

      // Create a new write batch
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Query expenses for the specified user
      QuerySnapshot querySnapshot =
          await expensesRef.where('userId', isEqualTo: userId).get();

      // Iterate through each document in the query result and add delete operations to the batch
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });

      // Commit the batch
      await batch.commit();

      print('All expenses for user $userId have been deleted.');
    } catch (e) {
      // Handle errors
      print('Error deleting expenses: $e');
    }
  }

  Future<UserModel?> getUserModel(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        UserModel model = UserModel.fromJson(userData);
        return model;
      } else {
        print('User document with ID $userId does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching user document: $e');
      return null;
    }
  }
}
