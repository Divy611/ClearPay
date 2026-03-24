import 'package:clearpay/common/enums.dart';
import 'package:clearpay/state/appstate.dart';
import 'package:clearpay/auth/usermodel.dart';
import 'package:clearpay/state/authstate.dart';
import 'package:clearpay/state/transactionState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clearpay/transactions/requestModel.dart';
import 'package:clearpay/transactions/transactionModel.dart';

class RequestsState extends AppState {
  List<RequestModel>? _sentRequests;
  List<RequestModel>? _receivedRequests;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<RequestModel> get sentRequests {
    if (_sentRequests == null) return [];
    _sentRequests!.sort(
      (a, b) => DateTime.parse(b.createdAt!).compareTo(
        DateTime.parse(a.createdAt!),
      ),
    );
    return _sentRequests!;
  }

  List<RequestModel> get receivedRequests {
    if (_receivedRequests == null) return [];
    _receivedRequests!.sort(
      (a, b) => DateTime.parse(b.createdAt!).compareTo(
        DateTime.parse(a.createdAt!),
      ),
    );
    return _receivedRequests!;
  }

  List<RequestModel> get pendingSentRequests =>
      sentRequests.where((r) => r.status == 'pending').toList();

  List<RequestModel> get pendingReceivedRequests =>
      receivedRequests.where((r) => r.status == 'pending').toList();

  List<RequestModel> get completedRequests {
    final all = <RequestModel>[
      ...?_sentRequests?.where((r) => r.status != 'pending'),
      ...?_receivedRequests?.where((r) => r.status != 'pending'),
    ];
    all.sort((a, b) =>
        DateTime.parse(b.createdAt!).compareTo(DateTime.parse(a.createdAt!)));
    return all;
  }

  Future<void> createRequest(RequestModel request) async {
    try {
      isBusy = true;
      final docRef = firestore.collection(REQUESTS).doc();
      request.id = docRef.id;
      await docRef.set(request.toJson());
      isBusy = false;
      notifyListeners();
    } catch (e) {
      isBusy = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      isBusy = true;
      await firestore
          .collection(REQUESTS)
          .doc(requestId)
          .update({'status': status});
      isBusy = false;
      notifyListeners();
    } catch (e) {
      isBusy = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchRequests(String userId) async {
    try {
      isBusy = true;
      _sentRequests = [];
      _receivedRequests = [];
      final results = await Future.wait([
        firestore
            .collection(REQUESTS)
            .where('requesterId', isEqualTo: userId)
            .get(),
        firestore
            .collection(REQUESTS)
            .where('recipientId', isEqualTo: userId)
            .get(),
      ]);
      _sentRequests = results[0]
          .docs
          .map((doc) => RequestModel.fromJson(doc.data()))
          .toList();
      _receivedRequests = results[1]
          .docs
          .map((doc) => RequestModel.fromJson(doc.data()))
          .toList();
      isBusy = false;
      notifyListeners();
    } catch (e) {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> processPayment(RequestModel request, AuthState authState,
      TransactionState transactionState) async {
    try {
      isBusy = true;
      final amount = double.tryParse(request.amount ?? '');
      if (amount == null || amount <= 0) throw 'Invalid amount';
      final currentBalance = (authState.userModel!.balance ?? 0).toDouble();
      if (currentBalance < amount) {
        throw 'Insufficient balance. You need ₹${(amount - currentBalance).toStringAsFixed(2)} more.';
      }
      final newSenderBalance = (currentBalance - amount).toInt();
      authState.userModel!.balance = newSenderBalance;
      final updatedSender = UserModel(
        balance: newSenderBalance,
        email: authState.userModel!.email,
        userId: authState.userModel!.userId,
        profilePic: authState.userModel!.profilePic,
        displayName: authState.userModel!.displayName,
      );
      await authState.updateUserProfile(updatedSender);
      final recipientQuery = await firestore
          .collection(USERS)
          .where('userId', isEqualTo: request.requesterId)
          .limit(1)
          .get();
      if (recipientQuery.docs.isEmpty) throw 'Recipient not found';
      final recipientDoc = recipientQuery.docs.first;
      final recipientBalance = (recipientDoc.data()['balance'] ?? 0) as num;
      await firestore
          .collection(USERS)
          .doc(request.requesterId)
          .update({'balance': recipientBalance + amount.toInt()});
      transactionState.recordTransaction(
        TransactionModel(
          amount: amount.toInt(),
          recipientName: request.requesterName,
          senderId: authState.userModel!.userId,
          createdAt: DateTime.now().toString(),
          recipientId: request.requesterId,
          senderName: authState.userModel!.displayName,
        ),
      );
      await updateRequestStatus(request.id!, 'completed');
      isBusy = false;
      notifyListeners();
    } catch (e) {
      isBusy = false;
      notifyListeners();
      throw e.toString();
    }
  }

  Future<List<UserModel>> searchUsers(
      String query, String currentUserId) async {
    if (query.trim().isEmpty) return [];
    try {
      final normalised = query.trim().toLowerCase();
      final results = <UserModel>[];
      final seenIds = <String>{};
      final nameSnapshot = await firestore
          .collection(USERS)
          .where('displayNameLower', isGreaterThanOrEqualTo: normalised)
          .where('displayNameLower', isLessThanOrEqualTo: '$normalised\uf8ff')
          .limit(15)
          .get();
      for (final doc in nameSnapshot.docs) {
        final u = UserModel.fromJson(doc.data());
        if (u.userId != currentUserId && !seenIds.contains(u.userId)) {
          results.add(u);
          seenIds.add(u.userId!);
        }
      }
      if (normalised.contains('@')) {
        final emailSnapshot = await firestore
            .collection(USERS)
            .where('email', isEqualTo: normalised)
            .limit(5)
            .get();
        for (final doc in emailSnapshot.docs) {
          final u = UserModel.fromJson(doc.data());
          if (u.userId != currentUserId && !seenIds.contains(u.userId)) {
            results.add(u);
            seenIds.add(u.userId!);
          }
        }
      }
      return results;
    } catch (e) {
      return [];
    }
  }
}
