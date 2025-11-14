import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart' as local; // Add alias

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    return userCredential.user;
  }

  // Save transaction - use the alias 'local.Transaction'
  Future<void> saveTransaction(local.Transaction transaction) async {
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('transactions')
        .doc(transaction.id)
        .set({
      'amount': transaction.amount,
      'category': transaction.category,
      'description': transaction.description,
      'date': transaction.date,
      'isIncome': transaction.isIncome,
      'type': transaction.type,
    });
  }

  // Get user transactions stream
  Stream<List<local.Transaction>> getTransactions() {
    if (currentUser == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      return local.Transaction( // Use alias here
        id: doc.id,
        amount: data['amount'],
        category: data['category'],
        description: data['description'],
        date: (data['date'] as Timestamp).toDate(),
        isIncome: data['isIncome'],
        type: data['type'],
      );
    }).toList());
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }
}