import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partiu_app/Screens/add_evento_screen.dart';
import 'package:partiu_app/Screens/feed_screen.dart';
import 'package:partiu_app/Screens/profile_screen.dart';
import 'package:partiu_app/Screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItens = [
  const FeedScreen(),
  const SearchScreen(),
  const AddEventoScreen(),
  const Text("notification"),
  Profilescreen(uid: FirebaseAuth.instance.currentUser!.uid)
];