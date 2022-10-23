import 'package:flutter/material.dart';

import 'service.dart';
import 'uploadfirebasestorage.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  static const String _textAppBar = 'Login Page', _textLogin = 'Login';
  final _userLogin = TextEditingController(), _passLogin = TextEditingController();
  final _userNode = FocusNode(), _passNode = FocusNode();
  bool _obscurePass = true;

  @override
  void dispose() {
    _userLogin.dispose();
    _passLogin.dispose();
    _userNode.dispose();
    _passNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_textAppBar),
        centerTitle: true,
      ),
      body: buildFormLogin(context),
    );
  }

  buildFormLogin(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / checkScreen(context, function: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextFormField(context, 0, 'username', Icons.person, _userLogin, _userNode, _passNode, false),
            const SizedBox(
              height: 10,
            ),
            buildTextFormField(context, 1, 'password', Icons.password, _passLogin, _passNode, null, true),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UploadFirebaseStorage(),
                    ),
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text(_textLogin))
          ],
        ),
      ),
    );
  }

  buildTextFormField(BuildContext context, int index, String textlabel, IconData? icon,
      TextEditingController controller, FocusNode? focus, FocusNode? nextfocus, bool obscure) {
    return TextFormField(
      controller: controller,
      focusNode: focus,
      obscureText: obscure ? _obscurePass : obscure,
      autofocus: index == 0 ? true : false,
      decoration: InputDecoration(
          labelText: textlabel,
          prefixIcon: Icon(icon),
          suffixIcon: obscure
              ? IconButton(
                  onPressed: () {
                    setState(() => _obscurePass = !_obscurePass);
                  },
                  icon: _obscurePass ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                )
              : null),
      onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(focus),
    );
  }
}
