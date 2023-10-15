// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks
import 'package:example/Utils/utils.dart';
import 'package:example/pages/home/child/child_home_page.dart';
import 'package:example/pages/home/child/child_video_page.dart';
import 'package:example/providers/child_provider.dart';
import 'package:example/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class SecurityCodePage extends HookWidget {
  const SecurityCodePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final childProvider = Provider.of<ChildProvider>(context);
    final passwordController = useTextEditingController();
    final usernameController = useTextEditingController();
    final userEmailController = useTextEditingController();
    final showPassword = useState(true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Security code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: CustomTextField(
              controller: userEmailController,
              hintText: 'Enter Parent Email:', // Add a hint for user email
              hintStyle: const TextStyle(fontSize: 15, color: Colors.white),

              textAlign: TextAlign.left,
              enableBorder: false,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: CustomTextField(
              controller: usernameController,
              hintText: 'Enter Child Name:',
              hintStyle: const TextStyle(fontSize: 15, color: Colors.white),
              textAlign: TextAlign.left,
              enableBorder: false,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: CustomTextField(
              isPassword: showPassword.value,
              controller: passwordController,
              hintText: 'Enter Security Code:',
              hintStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
              enableBorder: false,
              suffixWidget: InkWell(
                onTap: () {
                  showPassword.value = !showPassword.value;
                },
                child: Icon(showPassword.value
                    ? Icons.visibility
                    : Icons.visibility_off),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 50),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  if (usernameController.text.isEmpty) {
                    Utils.showToast('Enter your name');
                  } else if (userEmailController.text.isEmpty) {
                    Utils.showToast('Enter your Email');
                  } else if (passwordController.text.isEmpty) {
                    Utils.showToast('Enter security code');
                  } else {
                    EasyLoading.show();
                    await childProvider.getLoggedInChild(
                        parentEmail: userEmailController.text,
                        childName: usernameController.text,
                        securityCode: passwordController.text);
                    Utils.navigateTo(context, const ChildHomePage());
                    EasyLoading.dismiss();
                    userEmailController.clear();
                    usernameController.clear();
                    passwordController.clear();
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
    );
  }
}
