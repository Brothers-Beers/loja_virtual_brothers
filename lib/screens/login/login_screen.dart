import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/helpers/validators.dart';
import 'package:loja_virtual_brothesbeer/models/user.dart';
import 'package:loja_virtual_brothesbeer/models/users_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("ENTRAR"),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
                "CRIAR CONTA",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacementNamed("/signup");
            },
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formkey,
            child: Consumer<UserManager>(
                builder: (_, userManager, __){
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        controller: emailController,
                        enabled: !userManager.loading,
                        decoration: const InputDecoration(
                          hintText: "E-mail",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (email) {
                          if(!emailValid(email)){
                            return "E-mail inválido";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 16,),
                      TextFormField(
                        controller: passController,
                        enabled: !userManager.loading,
                        decoration: const InputDecoration(
                          hintText: "Senha",
                        ),
                        autocorrect: false,
                        validator: (pass) {
                          if (pass.isEmpty || pass.length < 6) {
                            return "Senha inválida!";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            child: const Text("Esqueci minha senha")),
                      ),
                      const SizedBox(height: 16,),
                      SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: userManager.loading ? null : () {
                            if(formkey.currentState.validate()){
                              userManager.signIn(
                                  user: User(
                                      email: emailController.text,
                                      password: passController.text
                                  ),
                                  onFail: (e){
                                    scaffoldKey.currentState.showSnackBar(
                                        SnackBar(content: Text("Falha ao entrar: $e"),
                                          backgroundColor: Colors.redAccent,
                                        )
                                    );
                                  },
                                  onSuccess: (){
                                    Navigator.of(context).pop();
                                  }
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: BorderSide.none),
                          child: userManager.loading ?
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ) :
                          const Text(
                            "Entrar",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          color: primaryColor,
                          disabledColor: primaryColor.withAlpha(140),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: BorderSide.none),
                          child: const Text(
                            "Entrar com o Google",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}
