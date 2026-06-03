
// File: lib/core/firebase/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floreria_ajolote/core/models/user_profile.dart';
import 'package:floreria_ajolote/core/models/order.dart' as app_order;
import 'package:floreria_ajolote/core/models/product.dart';
import 'package:floreria_ajolote/core/models/service.dart';
import 'package:floreria_ajolote/core/models/employee.dart';
import 'package:floreria_ajolote/core/models/occasion.dart';
import 'package:floreria_ajolote/core/models/event.dart';
import 'package:floreria_ajolote/core/models/vendor.dart';
import 'package:floreria_ajolote/core/models/batch.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Profile
  Stream<UserProfile?> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map(
          (snap) => snap.exists ? UserProfile.fromFirestore(snap) : null,
        );
  }

  Future<void> createUserProfile(UserProfile profile) {
    return _db.collection('users').doc(profile.uid).set(profile.toFirestore());
  }

  // Orders
  Stream<List<app_order.Order>> getOrders() {
    return _db.collection('orders').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => app_order.Order.fromFirestore(doc)).toList());
  }

    Stream<app_order.Order?> getOrder(String orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((snap) => snap.exists ? app_order.Order.fromFirestore(snap) : null);
  }

  Future<void> addOrder(app_order.Order order) {
    return _db.collection('orders').add(order.toFirestore());
  }

  Future<void> updateOrder(app_order.Order order) {
    return _db.collection('orders').doc(order.id).update(order.toFirestore());
  }

  Future<void> deleteOrder(String id) {
    return _db.collection('orders').doc(id).delete();
  }

  // Products
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());
  }

  Future<void> addProduct(Product product) {
    return _db.collection('products').add(product.toFirestore());
  }

    Future<void> updateProduct(Product product) {
    return _db.collection('products').doc(product.id).update(product.toFirestore());
  }

  Future<void> deleteProduct(String id) {
    return _db.collection('products').doc(id).delete();
  }

  // Services
  Stream<List<Service>> getServices() {
    return _db.collection('services').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Service.fromFirestore(doc)).toList());
  }

    Future<void> addService(Service service) {
    return _db.collection('services').add(service.toFirestore());
  }

  Future<void> updateService(Service service) {
    return _db.collection('services').doc(service.id).update(service.toFirestore());
  }

  Future<void> deleteService(String id) {
    return _db.collection('services').doc(id).delete();
  }

  // Employees (Unified with users collection)
  Stream<List<Employee>> getEmployees() {
    return _db
        .collection('users')
        .where('role', whereIn: ['UserRole.employee', 'UserRole.admin'])
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              final roleStr = data['role'] ?? 'UserRole.employee';
              final role = UserRole.values.firstWhere(
                (e) => e.toString() == roleStr,
                orElse: () => UserRole.employee,
              );
              return Employee(
                id: doc.id,
                name: data['displayName'] ?? '',
                role: data['puestoTrabajo'] ?? (role == UserRole.admin ? 'Administrador' : 'Empleado'),
                email: data['email'] ?? '',
                phoneNumber: data['phoneNumber'],
                photoUrl: data['photoURL'],
              );
            }).toList());
  }

  Future<void> addEmployee(Employee employee) {
    final docRef = _db.collection('users').doc();
    final isAuthAdmin = employee.role.toLowerCase() == 'administrador' || employee.role.toLowerCase() == 'admin';
    final userRole = isAuthAdmin ? UserRole.admin : UserRole.employee;
    final newUserProfile = UserProfile(
      uid: docRef.id,
      email: employee.email,
      displayName: employee.name,
      role: userRole,
      phoneNumber: employee.phoneNumber,
      puestoTrabajo: employee.role,
    );
    return docRef.set(newUserProfile.toFirestore());
  }

  Future<void> updateEmployee(Employee employee) {
    final isAuthAdmin = employee.role.toLowerCase() == 'administrador' || employee.role.toLowerCase() == 'admin';
    final userRole = isAuthAdmin ? UserRole.admin : UserRole.employee;
    return _db.collection('users').doc(employee.id).update({
      'displayName': employee.name,
      'email': employee.email,
      'role': userRole.toString(),
      'puestoTrabajo': employee.role,
      'phoneNumber': employee.phoneNumber,
      'photoURL': employee.photoUrl,
    });
  }

  Future<void> deleteEmployee(String id) {
    return _db.collection('users').doc(id).delete();
  }
  
    // Occasions
  Stream<List<Occasion>> getOccasions() {
    return _db.collection('occasions').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Occasion.fromFirestore(doc)).toList());
  }

    Future<void> addOccasion(Occasion occasion) {
    return _db.collection('occasions').add(occasion.toFirestore());
  }

  Future<void> updateOccasion(Occasion occasion) {
    return _db.collection('occasions').doc(occasion.id).update(occasion.toFirestore());
  }

  Future<void> deleteOccasion(String id) {
    return _db.collection('occasions').doc(id).delete();
  }

  // Generic method to add a document
  Future<DocumentReference> addDocument(String collectionPath, Map<String, dynamic> data) {
    return _db.collection(collectionPath).add(data);
  }

  // Generic method to update a document
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) {
    return _db.collection(collectionPath).doc(docId).update(data);
  }

  // Events (EVENTO)
  Stream<List<Event>> getEvents(String userId) {
    return _db
        .collection('events')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Event.fromFirestore(doc)).toList());
  }

  Future<void> addEvent(Event event) {
    return _db.collection('events').add(event.toFirestore());
  }

  Future<void> deleteEvent(String id) {
    return _db.collection('events').doc(id).delete();
  }

  // Vendors (PROVEEDOR)
  Stream<List<Vendor>> getVendors() {
    return _db.collection('vendors').snapshots().map((snap) =>
        snap.docs.map((doc) => Vendor.fromFirestore(doc)).toList());
  }

  Future<void> addVendor(Vendor vendor) {
    return _db.collection('vendors').add(vendor.toFirestore());
  }

  Future<void> updateVendor(Vendor vendor) {
    return _db.collection('vendors').doc(vendor.id).update(vendor.toFirestore());
  }

  Future<void> deleteVendor(String id) {
    return _db.collection('vendors').doc(id).delete();
  }

  // Batches (LOTE)
  Stream<List<Batch>> getBatches(String productId) {
    return _db
        .collection('batches')
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Batch.fromFirestore(doc)).toList());
  }

  Future<void> addBatch(Batch batch) async {
    await _db.collection('batches').add(batch.toFirestore());
    // Auto increment main product stock
    await _db.collection('products').doc(batch.productId).update({
      'stock': FieldValue.increment(batch.quantity),
    });
  }
}
