import 'package:example/Utils/utils.dart';
import 'package:example/pages/auth_page/signup_page.dart';
import 'package:example/pages/home/child/security_code.dart';
import 'package:flutter/material.dart';

class StarterPage extends StatelessWidget {
  const StarterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Access Limit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Utils.navigateTo(context, const SignupPage());
                },
                child: const Text(
                  'Parent',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(25),
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Utils.navigateTo(context, const SecurityCodePage());
                  },
                  child: const Text(
                    'Child',
                    style: TextStyle(fontSize: 20),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
