import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:orletapp/models/env.dart';
import 'package:orletapp/ui/home_screen.dart';
import 'package:orletapp/widget/custom_button.dart';

import '../widget/custom_text_form_field.dart';

class AddKendaraanScreen extends StatefulWidget {
  final String? username;

  const AddKendaraanScreen(this.username);

  @override
  State<AddKendaraanScreen> createState() => _AddKendaraanScreenState();
}

class _AddKendaraanScreenState extends State<AddKendaraanScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaakun;
  var jenisMobil = TextEditingController();
  var platMobil = TextEditingController();
  var noSIMCard = TextEditingController();
  var imei = TextEditingController();

  @override
  void initState() {
    _namaakun = TextEditingController(text: widget.username);
  }

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
          Uri.parse("${Env.URL_PREFIX}add_mobil.php"),
          body: {
            "id_user": _namaakun.text,
            "jenis_mobil": jenisMobil.text,
            "plat_mobil": platMobil.text,
            "no_simcard": noSIMCard.text,
            "imei": imei.text,
          },
        ).then((value) {
          //print message after insert to database
          //you can improve this message with alert dialog
          var data = jsonDecode(value.body);
          print("errors" + data["message"]);
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

        print("errornya ini " + e.toString());
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
          'Tambah Data Kendaraan',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget inputSection() {
      Widget namaAkunInput() {
        return CustomTextFormField(
          title: 'Nama Akun',
          hintText: "Nama Akun",
          textType: TextInputType.text,
          controller: _namaakun,
          obsecureText: false,
          textKosong: "Nomor SIMCard tidak boleh kosong",
        );
      }

      Widget jenisMobilInput() {
        return CustomTextFormField(
          title: 'Jenis Mobil',
          hintText: "Jenis Mobil",
          textType: TextInputType.text,
          controller: jenisMobil,
          obsecureText: false,
          textKosong: "Jenis mobil tidak boleh kosong",
        );
      }

      Widget platMobilInput() {
        return CustomTextFormField(
          title: 'Plat Mobil',
          hintText: "Plat Mobil",
          textType: TextInputType.text,
          controller: platMobil,
          obsecureText: false,
          textKosong: "Plat Mobil tidak boleh kosong",
        );
      }

      Widget simCardInput() {
        return CustomTextFormField(
          title: 'Nomor SIMCard',
          hintText: "Nomor SIMCard",
          controller: noSIMCard,
          textType: TextInputType.number,
          obsecureText: false,
          textKosong: "Nomor SIMCard tidak boleh kosong",
        );
      }

      Widget imeidInput() {
        return CustomTextFormField(
          title: 'IMEI',
          hintText: "IMEI",
          obsecureText: false,
          controller: imei,
          textType: TextInputType.text,
          textKosong: "IMEI tidak boleh kosong",
        );
      }

      Widget simpanButton() {
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
              namaAkunInput(),
              jenisMobilInput(),
              platMobilInput(),
              simCardInput(),
              imeidInput(),
              simpanButton()
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
            title: const Text(
                'Data kendaraan berhasil disimpan!\nMau menambahkan data kendaraan lagi?'),
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
                              AddKendaraanScreen(_namaakun.text),
                        ),
                      );
                    },
                    child: const Text(
                      'Ya',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false);
                    },
                    child: const Text(
                      'Tidak',
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
