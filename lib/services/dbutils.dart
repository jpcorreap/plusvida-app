import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbUtils {
  // Collections references
  final CollectionReference usersCol =
      Firestore.instance.collection("usuarios");

  final CollectionReference cuentasCol =
      Firestore.instance.collection("cuentas");

  final CollectionReference utilsCol = Firestore.instance.collection("utils");

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

// Gives to an user the 'profSalud' role
  Future<void> hacerProfSalud(String userID) {
    return usersCol.document(userID).updateData({
      'roles': FieldValue.arrayUnion(['profSalud'])
    });
  }

  Future<void> createDailyCheck(results, userID) async {
    var data = {
      'usuario': userID,
      'fecha': results[0],
      'contacto': results[1],
      'fiebre': results[2],
      'tos': results[3],
      'cabeza': results[4],
      'respirar': results[5],
      'recaido': results[6],
      'vomitoODiarrea': results[7],
      'pruebaCOVID': results[8],
      'enfermedades': results[9]
    };

    dailyCheckCol.add(data);
  }

  void createHouse() {}
}
