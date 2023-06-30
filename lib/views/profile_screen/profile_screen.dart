import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/lists.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/servies/firestore_services.dart';
import 'package:emart_app/views/auth_screen/login_screen.dart';
import 'package:emart_app/views/chat_screen/messaging_screen.dart';
import 'package:emart_app/views/orders_screen/orders_screen.dart';
import 'package:emart_app/views/profile_screen/edit_profile_screen.dart';
import 'package:emart_app/views/profile_screen/profile_controller.dart';
import 'package:emart_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:emart_app/widgets_common/loading_indicator.dart';

import 'components/details_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirestoreServices.getUser(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ),
                );
              } else {
                var data = snapshot.data!.docs[0];
                return SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
//Edit profile icon
                        const Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.edit, color: whiteColor),
                        ).onTap(() {
                          controller.nameController.text = data['name'];
                          Get.to(() => EditProfileScreen(data: data));
                        }),

                        //users details Section
                        Row(
                          children: [
                            data['imageUrl'] == ''
                                ? Image.asset(
                                    imgProfile2,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ).box.roundedFull.clip(Clip.antiAlias).make()
                                : Image.network(
                                    data['imageUrl'],
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                            10.widthBox,
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                                "${data['email']}".text.white.make()
                              ],
                            )),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: whiteColor,
                                  ),
                                ),
                                onPressed: () async {
                                  await Get.put(AuthController())
                                      .signoutMethod(context);
                                  Get.offAll(() => const LoginScreen());
                                },
                                child: "Log Out"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make()),
                          ],
                        ),

                        20.heightBox,
                        FutureBuilder(
                          future: FirestoreServices.getCounts(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: loadingIndicator(),
                              );
                            } else {
                              var countData = snapshot.data;

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  detailsCard(
                                      count: countData[0].toString(),
                                      title: "in your cart",
                                      width: context.screenWidth / 3.4),
                                  detailsCard(
                                      count: countData[1].toString(),
                                      title: "in your wishlist",
                                      width: context.screenWidth / 3.4),
                                  detailsCard(
                                      count: countData[2].toString(),
                                      title: "your orders",
                                      width: context.screenWidth / 3.4),
                                ],
                              );
                            }
                          },
                        ),

//Buttons Section
                        40.heightBox,
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: profileButtonsList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    break;
                                  case 1:
                                    Get.to(() => const OrdersScreen());
                                    break;
                                  case 2:
                                    Get.to(() => const WishlistScreen());
                                    break;
                                  case 3:
                                    Get.to(() => const MessagesScreen());
                                    break;
                                }
                              },
                              leading: Image.asset(
                                profileButtonsIcon[index],
                                width: 22,
                              ),
                              title: profileButtonsList[index]
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(color: darkFontGrey);
                          },
                        )
                            .box
                            .white
                            .rounded
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .shadowSm
                            .make(),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
