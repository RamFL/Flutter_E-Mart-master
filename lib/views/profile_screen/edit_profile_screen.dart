import 'dart:io';

import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/views/profile_screen/profile_controller.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import '../../widgets_common/custom_textfield.dart';
// import './profile_screen.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    // ProfileController controller = Get.put(ProfileController());
    ProfileController controller = Get.find<ProfileController>();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //if data image url and controller path is empty
                data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                    ? Image.asset(
                        imgProfile2,
                        width: 120,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    : data['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? Image.network(
                            data['imageUrl'],
                            width: 120,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()
                        : Image.file(File(controller.profileImgPath.value),
                                width: 120, fit: BoxFit.cover)
                            .box
                            .roundedFull
                            .clip(Clip.antiAlias)
                            .make(),
                10.heightBox,
                ourButton(
                    title: "Change Profile Picture",
                    color: redColor,
                    textColor: whiteColor,
                    onPress: () {
                      controller.changeImage(context);
                    }),
                const Divider(),
                20.heightBox,
                CustomTextField(
                    hint: nameHint,
                    title: name,
                    isPass: false,
                    controller: controller.nameController),
                10.heightBox,
                CustomTextField(
                    hint: passwordHint,
                    title: oldpass,
                    isPass: false,
                    controller: controller.oldpassController),
                10.heightBox,
                CustomTextField(
                    hint: passwordHint,
                    title: newpass,
                    isPass: false,
                    controller: controller.newpassController),
                20.heightBox,

                controller.isloading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(redColor))
                    : SizedBox(
                        width: context.screenWidth - 60,
                        child: ourButton(
                          title: "Save",
                          color: redColor,
                          textColor: whiteColor,
                          onPress: () async {
                            controller.isloading(true);

                            //if image is not selected
                            if (controller.profileImgPath.value.isNotEmpty) {
                              await controller.uploadProfileImage();
                            } else {
                              controller.profileImageLink = data['imageUrl'];
                            }

                            //is old password is matched with database password then

                            if (data['password'] ==
                                controller.oldpassController.text) {
                              await controller.changeAuthPassword(
                                email: data['email'],
                                password: controller.oldpassController.text,
                                newpassword: controller.newpassController.text,
                              );

                              await controller.updateProfile(
                                imgUrl: controller.profileImageLink,
                                name: controller.nameController.text,
                                password: controller.newpassController.text,
                              );
                              VxToast.show(context, msg: "updated");
                            } else {
                              VxToast.show(context, msg: "Wrong old Password");
                              controller.isloading(false);
                            }
                          },
                        ),
                      ),
              ],
            )
                .box
                .white
                .shadowSm
                .rounded
                .padding(const EdgeInsets.all(16))
                .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
                .make(),
          ),
        ),
      ),
    );
  }
}
