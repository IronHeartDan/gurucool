import 'dart:convert';

import 'package:gurucool/models/user.dart';
import 'package:gurucool/screens/auth_screen.dart';
import 'package:gurucool/screens/home_screen.dart';
import 'package:gurucool/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    splash();
    super.initState();
  }

  Future splash() async {
    // await secureStorage.delete(key: "user");
    await Future.delayed(const Duration(seconds: 2));
    var check = await secureStorage.read(key: "user");
    print(check);
    if (!mounted) return;
    if (check == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
              (route) => false);
      return;
    }

    var user = jsonDecode(check);
    context.read<UserState>().setUser(User.fromJson(user));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: HexColor("#531778"),
      width: size.width,
      height: size.height,
      child: Center(
        child: Image.asset("assets/gurucool.jpg"),
      ),
    );
  }
}
