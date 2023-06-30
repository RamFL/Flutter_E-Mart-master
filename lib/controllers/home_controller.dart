import 'package:emart_app/consts/consts.dart';

class HomeController extends GetxController {

  @override
  void onInit() {
    getUsername();
    super.onInit();
  }



  RxInt currentNavIndex = 0.obs;


  Future<String> getUsername() async {
    String n = '';
     await firestore
        .collection(usersCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        n =  value.docs.single['name'];
      }
    });
    return n;
    // ignore: dead_code
    print(n);
  }
}
