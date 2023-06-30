import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/home_controller.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];

  var placingOrder = false.obs;

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  //text controllers for shipping details

  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  //change payment method(index)

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }
  HomeController homeController = Get.find();
  //orders collection
  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    homeController.getUsername().then((value) async {
      await firestore.collection(ordersCollection).doc().set({
        'order_code': "233981237",
        'order_date': FieldValue.serverTimestamp(),
        'order_by': currentUser!.uid,
        'order_by_name': value,
        'order_by_email': currentUser!.email,
        'order_by_address': addressController.text,
        'order_by_city': cityController.text,
        'order_by_state': stateController.text,
        'order_by_pincode': pincodeController.text,
        'order_by_phone': phoneController.text,
        'shipping_method': "Home Delivery",
        'payment_method': orderPaymentMethod,
        'order_placed': true,
        'order_confirmed': false,
        'order_on_delivery': false,
        'order_delivered': false,
        'total_amount': totalAmount,
        'orders': FieldValue.arrayUnion(products),
      });
    });

    placingOrder(false);
  }

// For getting ordered products details
  getProductDetails() {
    products.clear();
    for (int i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'title': productSnapshot[i]['title'],
        'qty': productSnapshot[i]['qty'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
      });
    }
  }

  //After placing order we need to clear the cart
  clearCart() {
    for (int i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
