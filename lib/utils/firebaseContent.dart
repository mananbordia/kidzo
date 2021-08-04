import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

FirebaseAuth fAuth = FirebaseAuth.instance;
FirebaseFirestore fStore = FirebaseFirestore.instance;

CollectionReference userDataRef = fStore.collection("userData");
CollectionReference groupDataRef = fStore.collection("groupData");
CollectionReference messageDataRef = fStore.collection("messageData");


Uuid fUuid = Uuid();

int fMaxOwnedGroups = 3;