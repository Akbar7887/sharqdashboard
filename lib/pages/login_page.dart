import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

import '../models/ui.dart';
import '../services/producer_repository.dart';
import 'Home.dart';

TextEditingController _user = TextEditingController();
TextEditingController _password = TextEditingController();
Repository repository = Repository();
final _keyUser = GlobalKey<FormState>();
final _keyPassword = GlobalKey<FormState>();
bool visiblepassvord = true;

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Material(
        child: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Container(
            // alignment: Alignment.center,
            child: Text(Ui.name,
                style: GoogleFonts.openSans(
                  fontSize: 50,
                  fontWeight: FontWeight.w200,
                ))),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Text("Вход",
              style: GoogleFonts.openSans(
                fontSize: 50,
                fontWeight: FontWeight.w200,
              )),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
            width: 700,
            height: 400,
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    // color: Colors.amber,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 400,
                            child: Form(
                              key: _keyUser,
                              child: TextFormField(
                                  controller: _user,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Просим заполнить пользователя";
                                    }
                                  },
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                      ),
                                      //Theme.of(context).backgroundColor,
                                      labelText: "Пользователь",
                                      // labelStyle: TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            width: 0.5,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            width: 0.5,
                                          )))),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 400,
                          child: Form(
                              key: _keyPassword,
                              child: TextFormField(
                                  controller: _password,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Просим заполнить пароль";
                                    }
                                  },
                                  obscureText: visiblepassvord,
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          (visiblepassvord)
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            visiblepassvord = !visiblepassvord;
                                          });
                                        },
                                      ),
                                      prefixIcon: Icon(
                                        Icons.vpn_key_rounded,
                                      ),
                                      //Theme.of(context).backgroundColor,
                                      labelText: "Пароль",
                                      // labelStyle: TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(width: 0.5)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide:
                                              BorderSide(width: 0.5))))),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })),
        SizedBox(
          height: 30,
        ),
        Container(
          width: 200,
          height: 80,
          // color: Colors.black87,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          // color: Colors.black,
          child: ElevatedButton(
            onPressed: () {
              if (_keyUser.currentState!.validate() == false) {
                return;
              }
              if (_keyPassword.currentState!.validate() == false) {
                return;
              }
              repository
                  .login(_user.text.trim(), _password.text.trim())
                  .then((value) {
                if (value) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                } else {
                  print("Error");

                  Toast.show("Не правильно указан пользователь или пароль",
                      duration: Toast.lengthShort, gravity: Toast.bottom);
                }
              }).catchError((onError) {
                Toast.show("Не правильно указан пользователь или пароль",
                    duration: Toast.lengthShort, gravity: Toast.bottom);
              });
            },
            child: Text("ВОЙТИ",
                style: GoogleFonts.openSans(
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                )),
            style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all(Colors.black87),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 0.5)))),
          ),
        )
      ],
    ));
  }
}
