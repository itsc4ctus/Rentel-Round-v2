import 'package:hive/hive.dart';
import 'package:rentel_round/Notification/notificationServices.dart';

import '../Models/status_model.dart';

class StatusServices {
  Box<status>? statusBox;
  Box<status>? completedStatusBox;
  Box<status>? completedDealBox;

  Future<void> openBox() async {
    statusBox = await Hive.openBox("satusBox");
    completedStatusBox = await Hive.openBox("compledtedStatusBox");
    completedDealBox = await Hive.openBox("completedDealBox");
  }

  Future<void> closeBox() async {
    await statusBox!.close();
    await completedStatusBox!.close();
    completedDealBox!.close();
  }

  Future<void> addStatus(status status) async {
    if (statusBox == null) {
      await openBox();
    }
    await statusBox!.add(status);
  }

  Future<void> addCompletedStatus(status status) async {
    if (completedStatusBox == null) {
      await openBox();
    }
    await completedStatusBox!.add(status);
  }

  Future<void> addCompletedDealStatus(status status) async {
    if (completedDealBox == null) {
      await openBox();
    }
    await completedDealBox!.add(status);
  }

  Future<List<status>> getStatus() async {
    if (statusBox == null) {
      await openBox();
    }
    return statusBox!.values.toList();
  }

  Future<List<status>> getCompletedStatus() async {
    if (completedStatusBox == null) {
      await openBox();
    }
    return completedStatusBox!.values.toList();
  }

  Future<List<status>> getCompletedDealStatus() async {
    if (completedDealBox == null) {
      await openBox();
    }
    return completedDealBox!.values.toList();
  }

  Future<void> deleteStatus(String customerId) async {
    if (statusBox == null) {
      await openBox();
    }
    for (var key in statusBox!.keys) {
      final selectedstatus = statusBox!.get(key) as status;
      if (selectedstatus.cId == customerId) {
        await statusBox!.delete(key);
      }
    }
  }

  Future<void> deleteCompletedStatus(String customerId) async {
    if (completedStatusBox == null) {
      await openBox();
    }
    for (var key in completedStatusBox!.keys) {
      final selectedstatus = completedStatusBox!.get(key) as status;
      if (selectedstatus.cId == customerId) {
        await completedStatusBox!.delete(key);
      }
    }
  }

  Future<void> updateStatus(String customerID, status updatedStatus) async {
    if (statusBox == null) {
      await openBox();
    }
    for (var key in statusBox!.keys) {
      final Status = statusBox!.get(key) as status;
      if (Status.cId == customerID) {
        await statusBox!.put(key, updatedStatus);
        break;
      }
    }
  }

  Future<void> updateCompletedStatus(
      String customerID, status updatedStatus) async {
    if (completedStatusBox == null) {
      await openBox();
    }
    if (completedDealBox == null) {
      await openBox();
    }
    for (var key in completedStatusBox!.keys) {
      final Status = completedStatusBox!.get(key) as status;
      if (Status.cId == customerID) {
        await completedStatusBox!.put(key, updatedStatus);
        break;
      }
    }
    for (var key in completedDealBox!.keys) {
      final Status = completedDealBox!.get(key) as status;
      if (Status.cId == customerID) {
        await completedDealBox!.put(key, updatedStatus);
        break;
      }
    }
  }

  Future<void> clearBox() async {
    if (completedStatusBox == null) {
      await openBox();
    }
    if (completedDealBox == null) {
      await openBox();
    }
    if (statusBox == null) {
      await openBox();
    }
    await statusBox!.clear();
    await completedDealBox!.clear();
    await completedStatusBox!.clear();
  }

  Future<void> expiredCustomerNotification() async {
    await openBox();
    final currentTime = DateTime.now();
    for (var status in statusBox!.values) {
      if (status.endDate.isBefore(currentTime)) {
        await NotificationServices().showNotification(
            id: status.hashCode,
            title: "Rental period over",
            body: "Rental period of ${status.cName} is over!");
      }
    }
  }
}
