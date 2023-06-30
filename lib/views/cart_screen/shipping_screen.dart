import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/views/cart_screen/payment_method.dart';
import 'package:emart_app/widgets_common/custom_textfield.dart';
import 'package:emart_app/widgets_common/our_button.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          title: "Continue",
          color: redColor,
          textColor: whiteColor,
          onPress: () {
            if(controller.addressController.text.length > 10) {
              Get.to(() => const PaymentMethods());
            } else {
              VxToast.show(context, msg: "Please fill the form");
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomTextField(
                hint: "Address",
                isPass: false,
                title: "Address",
                controller: controller.addressController),
            CustomTextField(
                hint: "City",
                isPass: false,
                title: "City",
                controller: controller.cityController),
            CustomTextField(
                hint: "State",
                isPass: false,
                title: "State",
                controller: controller.stateController),
            CustomTextField(
                hint: "PIN Code",
                isPass: false,
                title: "PIN Code",
                controller: controller.pincodeController),
            CustomTextField(
                hint: "Phone",
                isPass: false,
                title: "Phone",
                controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
