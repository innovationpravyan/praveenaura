import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import '../constants/app_constants.dart';
import '../exceptions/app_exceptions.dart';

class FirebaseService {
  FirebaseService._();

  static final FirebaseService _instance = FirebaseService._();

  factory FirebaseService() => _instance;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth getter
  FirebaseAuth get auth => _auth;

  // Firestore getter
  FirebaseFirestore get firestore => _firestore;

  // Storage getter
  FirebaseStorage get storage => _storage;

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Auth methods
  Future<UserCredential> signInWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      developer.log('Attempting to sign in with email: $email');

      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      developer.log('Sign in successful for user: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      developer.log('Auth error during sign in: ${e.code} - ${e.message}');
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      developer.log('Unexpected error during sign in: $e');
      throw AuthException.unknown(e.toString());
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      developer.log('Attempting to create user with email: $email');

      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      developer.log('User creation successful: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      developer.log('Auth error during user creation: ${e.code} - ${e.message}');
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      developer.log('Unexpected error during user creation: $e');
      throw AuthException.unknown(e.toString());
    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      developer.log('Attempting to sign in with credential');

      final result = await _auth.signInWithCredential(credential);

      developer.log('Credential sign in successful: ${result.user?.uid}');
      return result;
    } on FirebaseAuthException catch (e) {
      developer.log('Auth error during credential sign in: ${e.code} - ${e.message}');
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      developer.log('Unexpected error during credential sign in: $e');
      throw AuthException.unknown(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      developer.log('Attempting to sign out user: ${currentUser?.uid}');

      // Clear any cached data if needed
      await _auth.signOut();

      developer.log('Sign out successful');
    } catch (e) {
      developer.log('Error during sign out: $e');
      throw AuthException.unknown('Sign out failed: ${e.toString()}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      developer.log('Sending password reset email to: $email');

      await _auth.sendPasswordResetEmail(email: email.trim());

      developer.log('Password reset email sent successfully');
    } on FirebaseAuthException catch (e) {
      developer.log('Auth error during password reset: ${e.code} - ${e.message}');
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      developer.log('Unexpected error during password reset: $e');
      throw AuthException.unknown(e.toString());
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        developer.log('Sending email verification to: ${user.email}');
        await user.sendEmailVerification();
        developer.log('Email verification sent successfully');
      }
    } on FirebaseAuthException catch (e) {
      developer.log('Auth error during email verification: ${e.code} - ${e.message}');
      throw AuthException(_getAuthErrorMessage(e.code), e.code);
    } catch (e) {
      developer.log('Unexpected error during email verification: $e');
      throw AuthException.unknown(e.toString());
    }
  }

  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      developer.log('User reloaded successfully');
    } catch (e) {
      developer.log('Error reloading user: $e');
      throw AuthException.unknown('Failed to reload user: ${e.toString()}');
    }
  }

  // Firestore methods for Users
  Future<void> createUserDocument(UserModel user) async {
    try {
      developer.log('Creating user document for: ${user.uid}');

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toFirestore());

      developer.log('User document created successfully');
    } on FirebaseException catch (e) {
      developer.log('Firestore error creating user document: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error creating user document: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      developer.log('Fetching user data for: $uid');

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        developer.log('User data fetched successfully');
        return UserModel.fromFirebase(doc.data()!, uid);
      }

      developer.log('User document does not exist');
      return null;
    } on FirebaseException catch (e) {
      developer.log('Firestore error fetching user data: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error fetching user data: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Future<void> updateUserDocument(UserModel user) async {
    try {
      developer.log('Updating user document for: ${user.uid}');

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update(user.toFirestore());

      developer.log('User document updated successfully');
    } on FirebaseException catch (e) {
      developer.log('Firestore error updating user document: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error updating user document: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Future<void> updateLastLoginTime(String uid) async {
    try {
      developer.log('Updating last login time for: $uid');

      final now = DateTime.now();
      await _firestore.collection(AppConstants.usersCollection).doc(uid).update({
        'lastLoginAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      });

      developer.log('Last login time updated successfully');
    } on FirebaseException catch (e) {
      developer.log('Firestore error updating last login: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error updating last login: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Future<void> deleteUserDocument(String uid) async {
    try {
      developer.log('Deleting user document for: $uid');

      await _firestore.collection(AppConstants.usersCollection).doc(uid).delete();

      developer.log('User document deleted successfully');
    } on FirebaseException catch (e) {
      developer.log('Firestore error deleting user document: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error deleting user document: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  // Generic Firestore CRUD operations
  Future<String> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      developer.log('Adding document to collection: $collection');

      final docRef = await _firestore.collection(collection).add(data);

      developer.log('Document added with ID: ${docRef.id}');
      return docRef.id;
    } on FirebaseException catch (e) {
      developer.log('Firestore error adding document: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error adding document: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getDocument(String collection, String documentId) async {
    try {
      developer.log('Getting document: $documentId from collection: $collection');

      final doc = await _firestore.collection(collection).doc(documentId).get();

      if (doc.exists) {
        developer.log('Document retrieved successfully');
        return doc.data();
      }

      developer.log('Document does not exist');
      return null;
    } on FirebaseException catch (e) {
      developer.log('Firestore error getting document: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error getting document: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Future<void> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      developer.log('Updating document: $documentId in collection: $collection');

      await _firestore.collection(collection).doc(documentId).update(data);

      developer.log('Document updated successfully');
    } on FirebaseException catch (e) {
      developer.log('Firestore error updating document: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error updating document: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      developer.log('Deleting document: $documentId from collection: $collection');

      await _firestore.collection(collection).doc(documentId).delete();

      developer.log('Document deleted successfully');
    } on FirebaseException catch (e) {
      developer.log('Firestore error deleting document: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error deleting document: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDocuments(
      String collection, {
        Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)? queryBuilder,
        int? limit,
      }) async {
    try {
      developer.log('Getting documents from collection: $collection');

      Query<Map<String, dynamic>> query = _firestore.collection(collection);

      if (queryBuilder != null) {
        query = queryBuilder(query);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final result = await query.get();

      developer.log('Retrieved ${result.docs.length} documents');
      return result;
    } on FirebaseException catch (e) {
      developer.log('Firestore error getting documents: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error getting documents: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDocumentsStream(
      String collection, {
        Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)? queryBuilder,
        int? limit,
      }) {
    try {
      developer.log('Creating documents stream for collection: $collection');

      Query<Map<String, dynamic>> query = _firestore.collection(collection);

      if (queryBuilder != null) {
        query = queryBuilder(query);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      return query.snapshots();
    } catch (e) {
      developer.log('Error creating documents stream: $e');
      // Return an error stream
      return Stream.error(FirestoreException.unknown(e.toString()));
    }
  }

  // Storage methods
  Future<String> uploadFile(String path, File file, {String? fileName}) async {
    try {
      final name = fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
      developer.log('Uploading file to: $path/$name');

      final ref = _storage.ref().child(path).child(name);
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      developer.log('File uploaded successfully, URL: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      developer.log('Storage error uploading file: ${e.code} - ${e.message}');
      throw StorageExceptionExtension.getStorageErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error uploading file: $e');
      throw StorageException.unknown(e.toString());
    }
  }

  Future<String> uploadFileFromBytes(
      String path,
      List<int> bytes, {
        String? fileName,
        String? mimeType,
      }) async {
    try {
      final name = fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
      developer.log('Uploading bytes to: $path/$name');

      final ref = _storage.ref().child(path).child(name);
      final metadata = mimeType != null ? SettableMetadata(contentType: mimeType) : null;
      final uploadTask = ref.putData(Uint8List.fromList(bytes), metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      developer.log('Bytes uploaded successfully, URL: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      developer.log('Storage error uploading bytes: ${e.code} - ${e.message}');
      throw StorageExceptionExtension.getStorageErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error uploading bytes: $e');
      throw StorageException.unknown(e.toString());
    }
  }

  Future<void> deleteFile(String url) async {
    try {
      developer.log('Deleting file: $url');

      final ref = _storage.refFromURL(url);
      await ref.delete();

      developer.log('File deleted successfully');
    } on FirebaseException catch (e) {
      developer.log('Storage error deleting file: ${e.code} - ${e.message}');
      throw StorageExceptionExtension.getStorageErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error deleting file: $e');
      throw StorageException.unknown(e.toString());
    }
  }

  // Batch operations
  WriteBatch createBatch() {
    developer.log('Creating Firestore batch');
    return _firestore.batch();
  }

  Future<void> commitBatch(WriteBatch batch) async {
    try {
      developer.log('Committing Firestore batch');

      await batch.commit();

      developer.log('Batch committed successfully');
    } on FirebaseException catch (e) {
      developer.log('Firestore error committing batch: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error committing batch: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  // Transaction
  Future<T> runTransaction<T>(
      Future<T> Function(Transaction transaction) updateFunction,
      ) async {
    try {
      developer.log('Running Firestore transaction');

      final result = await _firestore.runTransaction(updateFunction);

      developer.log('Transaction completed successfully');
      return result;
    } on FirebaseException catch (e) {
      developer.log('Firestore error in transaction: ${e.code} - ${e.message}');
      throw FirestoreExceptionExtension.getFirestoreErrorMessage(e.code, e.message ?? '');
    } catch (e) {
      developer.log('Unexpected error in transaction: $e');
      throw FirestoreException.unknown(e.toString());
    }
  }

  // Helper methods
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password provided';
      case 'email-already-in-use':
        return 'An account already exists with this email address';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support';
      case 'too-many-requests':
        return 'Too many unsuccessful attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'invalid-credential':
        return 'The provided credentials are invalid';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different user account';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication. Please sign in again';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}

// Extensions for error handling
extension FirestoreExceptionExtension on FirestoreException {
  static FirestoreException getFirestoreErrorMessage(String code, String message) {
    switch (code) {
      case 'permission-denied':
        return FirestoreException.permissionDenied();
      case 'not-found':
        return FirestoreException.notFound();
      case 'aborted':
        return FirestoreException.aborted();
      case 'already-exists':
        return FirestoreException.alreadyExists();
      case 'unavailable':
        return FirestoreException.unavailable();
      case 'deadline-exceeded':
        return FirestoreException.unknown('Request deadline exceeded');
      case 'resource-exhausted':
        return FirestoreException.unknown('Resource exhausted');
      case 'cancelled':
        return FirestoreException.unknown('Operation was cancelled');
      default:
        return FirestoreException.unknown(message.isNotEmpty ? message : 'Unknown Firestore error');
    }
  }
}

extension StorageExceptionExtension on StorageException {
  static StorageException getStorageErrorMessage(String code, String message) {
    switch (code) {
      case 'unauthorized':
        return StorageException.unauthorized();
      case 'object-not-found':
        return StorageException.objectNotFound();
      case 'quota-exceeded':
        return StorageException.quotaExceeded();
      case 'unauthenticated':
        return StorageException.unknown('Authentication required');
      case 'retry-limit-exceeded':
        return StorageException.unknown('Maximum retry time exceeded');
      case 'invalid-checksum':
        return StorageException.unknown('File integrity check failed');
      case 'cancelled':
        return StorageException.unknown('Upload was cancelled');
      default:
        return StorageException.unknown(message.isNotEmpty ? message : 'Unknown Storage error');
    }
  }
}

// Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});