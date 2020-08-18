import 'package:flutter/material.dart';
import 'package:loja_virtual_brothesbeer/helpers/validators.dart';
import 'package:loja_virtual_brothesbeer/models/user.dart';
import 'package:loja_virtual_brothesbeer/models/users_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final User user = User();

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Criar conta"),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formkey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __){
                return ListView(
                  padding: EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                          hintText: "Nome completo"
                      ),
                      validator: (name){
                        if(name.isEmpty){
                          return "Campo obrigatório";
                        } else if(name.trim().split(" ").length <= 1){
                          return "Preencha seu nome completo";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (email){
                        if(email.isEmpty){
                          return "Campo obrigatório";
                        } else if (!emailValid(email)){
                          return "E-mail inválido";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return "Campo obrigatório";
                        } else if(pass.length < 6) {
                          return "Senha deve conter no minimo 6 caracteres";
                        } else if(pass.length > 12) {
                          return "Senha deve conter no maximo 12 caracteres";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (pass) => user.password = pass,
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                          hintText: "Confirme sua senha"
                      ),
                      obscureText: true,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return "Campo obrigatório";
                        } else if(pass.length < 6) {
                          return "Senha deve conter no minimo 6 caracteres";
                        } else if(pass.length > 12) {
                          return "Senha deve conter no maximo 12 caracteres";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (pass) => user.confirmPass = pass,
                    ),
                    const SizedBox(height: 16,),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        onPressed: userManager.loading ? null : () {
                          if(formkey.currentState.validate()){
                            formkey.currentState.save();

                            if(user.password != user.confirmPass){
                              scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: const Text("Senhas não coincidem!"),
                                    backgroundColor: Colors.redAccent,
                                  )
                              );
                              return;
                            }
                            userManager.signUp(
                                user: user,
                                onSuccess: (){
                                  Navigator.of(context).pop();
                                },
                                onFail: (e){
                                  scaffoldKey.currentState.showSnackBar(
                                      SnackBar(content: Text("Falha ao cadastrar: $e"),
                                        backgroundColor: Colors.redAccent,
                                      )
                                  );
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
                          "Criar conta",
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
