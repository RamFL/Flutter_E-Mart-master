import 'package:emart_app/consts/consts.dart';
import 'package:intl/intl.dart' as intl;

import 'components/order_place_details.dart';
import 'components/order_status.dart';

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            orderStatus(
              color: Colors.blue,
              icon: Icons.thumb_up_alt,
              title: "Order Placed",
              showDone: data['order_placed'],
            ),
            orderStatus(
              color: Colors.green,
              icon: Icons.done,
              title: "Confirmed",
              showDone: data['order_confirmed'],
            ),
            orderStatus(
              color: Colors.yellow,
              icon: Icons.directions_bike_rounded,
              title: "On Delivery",
              showDone: data['order_on_delivery'],
            ),
            orderStatus(
              color: Colors.red,
              icon: Icons.done_all,
              title: "Delivered",
              showDone: data['order_delivered'],
            ),
            const Divider(),
            10.heightBox,
            Column(
              children: [
                orderPlaceDetails(
                  title1: "Order Code",
                  title2: "Shipping Method",
                  d1: data['order_code'],
                  d2: data['shipping_method'],
                ),
                orderPlaceDetails(
                  title1: "Order Date",
                  title2: "Payment Method",
                  d1: intl.DateFormat()
                      .add_yMd()
                      .format((data['order_date'].toDate())),
                  d2: data['payment_method'],
                ),
                orderPlaceDetails(
                  title1: "payment Status",
                  title2: "Delivery Status",
                  d1: "Unpaid",
                  d2: "Order Placed",
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Shipping Address".text.fontFamily(semibold).make(),
                          "${data['order_by_name']}".text.make(),
                          "${data['order_by_email']}".text.make(),
                          "${data['order_by_address']}".text.make(),
                          "${data['order_by_city']}".text.make(),
                          "${data['order_by_state']}".text.make(),
                          "${data['order_by_phone']}".text.make(),
                          "${data['order_by_pincode']}".text.make(),
                        ],
                      ),
                      SizedBox(
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Total amount".text.fontFamily(semibold).make(),
                            "${data['total_amount']}"
                                .text
                                .color(redColor)
                                .fontFamily(bold)
                                .make(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).box.white.outerShadowMd.make(),
            const Divider(),
            10.heightBox,
            "Ordered Product"
                .text
                .size(16)
                .color(darkFontGrey)
                .fontFamily(semibold)
                .makeCentered(),
            10.heightBox,
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(data['orders'].length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    orderPlaceDetails(
                      title1: data['orders'][index]['title'],
                      title2: data['orders'][index]['tprice'],
                      d1: "${data['orders'][index]['qty']}x",
                      d2: "Refundable",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: 30,
                        height: 20,
                        color: Color(data['orders'][index]['color']),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            ).box.white.outerShadowMd.make(),
            20.heightBox,
          ],
        ),
      ),
    );
  }
}
