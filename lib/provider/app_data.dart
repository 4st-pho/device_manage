import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manage_devices_app/model/device.dart';
import 'package:manage_devices_app/model/team.dart';
import 'package:manage_devices_app/model/user.dart' as model;
import 'package:manage_devices_app/services/clound_firestore/device_method.dart';
import 'package:manage_devices_app/services/clound_firestore/team_method.dart';
import 'package:manage_devices_app/services/clound_firestore/user_method.dart';

class AppData extends ChangeNotifier {
  List<model.User> teamMember = [];
  List<model.User> allUser = [];
  List<Team> allTeam = [];
  List<Device> myDevice = [];
  List<Device> teamDevice = [];
  model.User? currentUser;

  Future<void> getUserSameTeam(BuildContext context) async {
    teamMember = await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getUserSameTeam(context);
  }

  bool isContainList(Device device, List<Device> devices) {
    for (var element in devices) {
      if (element.name == device.name) {
        return true;
      }
    }
    return false;
  }

  Future<void> getMyDevice(BuildContext context) async {
    final currentUser = context.read<AppData>().currentUser;
    myDevice = await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getDeviceById(currentUser!.id);
  }
  Future<void> getTeamDevice(BuildContext context) async {
    final currentUser = context.read<AppData>().currentUser;
    teamDevice = await DeviceMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getDeviceById(currentUser!.teamId);
  }



  Future<void> getCurrentUser() async {
    currentUser =
        await UserMethod(firebaseFirestore: FirebaseFirestore.instance).getUser(
      FirebaseAuth.instance.currentUser!.uid,
    );
  }

  Future<void> getAllTeam() async {
    allTeam = await TeamMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllTeam();
  }

  Future<void> getAllUser() async {
    allUser = await UserMethod(firebaseFirestore: FirebaseFirestore.instance)
        .getAllUser();
  }
}
