import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbUtils {
  // Collections references
  final CollectionReference usersCol =
      Firestore.instance.collection("usuarios");

  final CollectionReference housesCol = Firestore.instance.collection("casas");

  final CollectionReference cuentasCol =
      Firestore.instance.collection("cuentas");

  final CollectionReference utilsCol = Firestore.instance.collection("utils");

  final CollectionReference utilidadesCol =
      Firestore.instance.collection("utilidades");

  final CollectionReference dailyCheckCol =
      Firestore.instance.collection("chequeosDiarios");

  // -------------------
  // READ operations
  // -------------------

  // Gives a Future with current Auth user ID
  Future<String> getCurrentUserID() async {
    print("ENTRÓ A MIRAR EL CURRENT USER ID");
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid.toString();
  }

  // Returns current Auth user information
  Future getProfileInfo() async {
    String uid = await getCurrentUserID();
    print(uid);
    return cuentasCol.document(uid).get();
  }

  // Returns doc of an user
  DocumentReference getUser(id) {
    return usersCol.document(id);
  }

  // Returns doc of a house
  DocumentReference getHouse(id) {
    return housesCol.document(id);
  }

  // Returns protocol demo user information
  Future getProtocol() async {
    return utilsCol.document("me6UnxaDZS2ElGj7uvGb").get();
  }

  // Return snapshot for users collection
  Stream<QuerySnapshot> usersSnapshots() {
    return usersCol.snapshots();
  }

  // Return snapshot for an specific user
  Stream<DocumentSnapshot> getUserSnapshot(userID) {
    return usersCol
        .document(userID)
        .snapshots(); // Si fuera .snapshots() me saca es el Stream<QuerySnapshot>
  }

  Stream<QuerySnapshot> riskSnapshots() {
    return dailyCheckCol.snapshots();
  }

  Stream<QuerySnapshot> getMyPatients(nurseID) {
    print("SE VA A IR A BUSCAR CON EL ID " + nurseID);
    return usersCol
        .where('enfermera', isEqualTo: nurseID)
        .orderBy("riesgo", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getHouseInfo(houseID) {
    return usersCol.where('casa', isEqualTo: houseID).snapshots();
  }

  Stream<QuerySnapshot> getMyHouse(cabezaDeHogarID) {
    return usersCol.where('casa', isEqualTo: cabezaDeHogarID).snapshots();
  }

  // Get a QuerySnapshot with all documents of municipios
  Future<QuerySnapshot> getMunicipios() {
    return utilsCol
        .document("registro")
        .collection("municipios")
        .getDocuments();
  }

  // Get a QuerySnapshot with all documents of municipios
  DocumentReference getEPSs() {
    return utilsCol.document("eps");
  }

  // Get a QuerySnapshot with all documents of municipios
  DocumentReference getDailyCheckQuestions() {
    return utilidadesCol.document("preguntasChequeos");
  }

  // Get a QuerySnapshot with all documents of tipos de identificacion
  Future<QuerySnapshot> getTiposDoc() {
    return utilsCol
        .document("registro")
        .collection("tiposIdentificacion")
        .getDocuments();
  }

  // Get a QuerySnapshot with all registro document of nacionalidades
  DocumentReference getAllRegistro() {
    return utilsCol.document("registro");
  }

  // -------------------
  // CREATE operations
  // -------------------
  Future createProfile(uid) async {
    return await cuentasCol.document(uid).setData({
      'usersIDs': [],
      'usernames': [],
    });
  }

  // Creates a new user, then makes a relationship between it and the logged user
  // Finally, it returns the new added user ID onto a Future
  /* Future<String> createUser(userID, data, username) async {
    String authUID = await getCurrentUserID();

    cuentasCol.document(authUID).get().then((document) => print(document));


    .updateData({
        'usersIDs': FieldValue.arrayUnion([userID]),
        'usernames': FieldValue.arrayUnion([username])
      }).then((value) => userID);


    // First of all, user is created onto users collection
    return usersCol.document(userID).setData(data).then((value) {
      // Later, it needs to be updated in profiles collection
    });
  }*/

// Gives to an user the 'profSalud' role
  Future<void> hacerProfSalud(String userID) {
    return usersCol.document(userID).updateData({
      'roles': FieldValue.arrayUnion(['profSalud'])
    });
  }

  Future<void> createDailyCheck(results, userID) async {
    results['usuario'] = userID;
    dailyCheckCol.add(results);
  }

  Future updateHouseOfAccount(houseID) async {
    String authUID = await getCurrentUserID();
    return cuentasCol.document(authUID).updateData({
      'casa': houseID,
    });
  }

  Future createHouse(houseID, data) async {
    // First of all, user is created onto users collection
    return housesCol.document(houseID).setData(data).then((value) {
      // Later, it needs to be updated in profiles collection
      return updateHouseOfAccount(houseID);
    });
  }

  Future<String> createUser(userID, data, username) async {
    String authUID = await getCurrentUserID();
    // First of all, user is created onto users collection
    return usersCol.document(userID).setData(data).then((value) {
      // Later, it needs to be updated in profiles collection
      return cuentasCol.document(authUID).updateData({
        'usersIDs': FieldValue.arrayUnion([userID]),
        'usernames': FieldValue.arrayUnion([username])
      }).then((value) => userID);
    });
  }
}
