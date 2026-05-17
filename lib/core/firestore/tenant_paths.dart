import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constants.dart';

class TenantPaths {
  TenantPaths(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> business(String businessId) =>
      _firestore.collection(FirestoreCollections.businesses).doc(businessId);

  CollectionReference<Map<String, dynamic>> businessSub(
    String businessId,
    String subcollection,
  ) =>
      business(businessId).collection(subcollection);

  CollectionReference<Map<String, dynamic>> products(String businessId) =>
      businessSub(businessId, FirestoreCollections.products);

  CollectionReference<Map<String, dynamic>> offers(String businessId) =>
      businessSub(businessId, FirestoreCollections.offers);

  CollectionReference<Map<String, dynamic>> categories(String businessId) =>
      businessSub(businessId, FirestoreCollections.categories);

  CollectionReference<Map<String, dynamic>> productVariants(String businessId) =>
      businessSub(businessId, FirestoreCollections.productVariants);

  CollectionReference<Map<String, dynamic>> attributes(String businessId) =>
      businessSub(businessId, FirestoreCollections.attributes);

  CollectionReference<Map<String, dynamic>> orders(String businessId) =>
      businessSub(businessId, FirestoreCollections.orders);

  CollectionReference<Map<String, dynamic>> apiKeys(String businessId) =>
      businessSub(businessId, FirestoreCollections.apiKeys);

  DocumentReference<Map<String, dynamic>> user(String uid) =>
      _firestore.collection(FirestoreCollections.users).doc(uid);
}
