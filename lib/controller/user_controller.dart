import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Future<bool> loadUserDataInitState() async {
    Future<UsersModel?> userData = SharedPrefercenseService.getUser();
    if (userData != null) {
      return true;
    }
    return false;
  }
}
