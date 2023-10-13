import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orletapp/models/env.dart';
import 'package:orletapp/ui/add_penjualan.dart';
import 'package:orletapp/widget/custom_snackbar_error.dart';
import 'package:orletapp/widget/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

import '../widget/custom_button.dart';
import 'add_data_kendaraan.dart';

class AddPelangganScreen extends StatefulWidget {
  const AddPelangganScreen({super.key});

  @override
  State<AddPelangganScreen> createState() => _AddPelangganScreenState();
}

class _AddPelangganScreenState extends State<AddPelangganScreen> {
  final _formKey = GlobalKey<FormState>();

  //inisialize field
  var nama = TextEditingController();
  var noWA = TextEditingController();
  var alamat = TextEditingController();
  var namaakun = TextEditingController();
  var password = TextEditingController();

  Future _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return const Dialog(
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Mengirim data...')
                  ],
                ),
              ),
            );
          });

      await Future.delayed(const Duration(seconds: 3));

      try {
        return await http.post(
          Uri.parse("${Env.URL_PREFIX}add_pelanggan.php"),
          body: {
            "nama": nama.text,
            "nomor_wa": noWA.text,
            "alamat": alamat.text,
            "username": namaakun.text,
            "password": password.text,
          },
        ).then((value) {
          //print message after insert to database
          //you can improve this message with alert dialog
          var data = jsonDecode(value.body);
          String hasil = data["message"];
          print(data["message"]);
          _confirmDialog();
        });
      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Stack(children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFC72C41),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Oh snap!",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            "Data tidak berhasil disimpan!. Server sedang down!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          "images/icon_alert.png",
                          height: 48,
                          width: 40,
                        ),
                      ],
                    ),
                  ))
            ])));

        print("nggak bisa kirim ke server");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Text(
          'Tambah Pelanggan Baru',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget inputSection() {
      Widget namaInput() {
        return CustomTextFormField(
          title: 'Nama',
          hintText: "Nama",
          controller: nama,
          textType: TextInputType.text,
          obsecureText: false,
          textKosong: "Nama tidak boleh kosong",
        );
      }

      Widget nowaInput() {
        return CustomTextFormField(
          title: 'Nomor Whatsapp',
          hintText: "Nomor Whatsapp",
          controller: noWA,
          obsecureText: false,
          textType: TextInputType.number,
          textKosong: "Nomor whatsapp tidak boleh kosong",
        );
      }

      Widget alamatInput() {
        return CustomTextFormField(
          title: 'Alamat',
          hintText: "Alamat",
          textType: TextInputType.text,
          controller: alamat,
          obsecureText: false,
          textKosong: "Alamat tidak boleh kosong",
        );
      }

      Widget namaakunInput() {
        return CustomTextFormField(
          title: 'Nama Akun',
          hintText: "Nama Akun",
          controller: namaakun,
          textType: TextInputType.text,
          obsecureText: false,
          textKosong: "Nama akun tidak boleh kosong",
        );
      }

      Widget passwordInput() {
        return CustomTextFormField(
          title: 'Password',
          controller: password,
          hintText: "Password",
          textType: TextInputType.text,
          obsecureText: true,
          textKosong: "Password tidak boleh kosong",
        );
      }

      Widget signInButton() {
        return CustomButton(
          title: "Simpan",
          onPressed: () {
            _onSubmit();
          },
        );
      }

      return Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: const Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(17.0),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              namaInput(),
              nowaInput(),
              alamatInput(),
              namaakunInput(),
              passwordInput(),
              signInButton()
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          children: [title(), inputSection()],
        ),
      ),
    );
  }

  Future<void> _confirmDialog() async {
    switch (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Data pelanggan berhasil disimpan!'),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddPenjualanScreen(namaakun.text),
                        ),
                      );
                    },
                    child: const Text(
                      'Ok',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          );
        })) {
      case true:
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        print('Confirmed');
        break;

      case false:
        print('Canceled');
        break;

      default:
        print('Canceled');
    }
  }
}
