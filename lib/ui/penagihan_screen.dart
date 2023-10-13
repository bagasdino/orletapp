import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:orletapp/ui/home_screen.dart';
import 'package:orletapp/widget/custom_button.dart';

import '../models/env.dart';
import '../widget/custom_text_form_field.dart';

import 'package:http/http.dart' as http;

final formatter = DateFormat.yM();

class PenagihanScreen extends StatefulWidget {
  @override
  State<PenagihanScreen> createState() => _PenagihanScreenState();
}

class _PenagihanScreenState extends State<PenagihanScreen> {
  DateTime? _selectedDate;
  var biaya = TextEditingController();

  void _presentMonthPicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickefMonth = await showMonthPicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickefMonth;
      _confirmDialog(formatter.format(pickefMonth!));
    });
  }

  Future<void> _confirmDialog(String tanggal) async {
    switch (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Yakin mau menambahkan data penagihan bulan $tanggal'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  title: 'Biaya',
                  hintText: "Biaya",
                  controller: biaya,
                  textType: TextInputType.number,
                  obsecureText: false,
                  textKosong: "Biaya tidak boleh kosong",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      _onSubmit(tanggal);
                    },
                    child: const Text(
                      'Tambahkan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          );
        })) {
      case true:
        print('Confirmed');
        break;

      case false:
        print('Canceled');
        break;

      default:
        print('Canceled');
    }
  }

  Future _onSubmit(String tanggaltagih) async {
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
        Uri.parse("${Env.URL_PREFIX}add_tagihan.php"),
        body: {
          "tgl_tagihan": tanggaltagih,
          "biaya": biaya.text,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        String hasil = data["message"];
        SnackBar snackBar = const SnackBar(
          content: Text('Data berhasil disimpan!'),
          duration: Duration(seconds: 2), // durasi tampilan
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));

        print(data["message"]);
        // _confirmDialog();
      });
    } catch (e) {
      print(e);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 16.0, right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '   PENAGIHAN',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 15,
                ),
                Card(
                  elevation: 50,
                  shadowColor: const Color(0xff9698A9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 79, 92, 243),
                            Color.fromARGB(255, 10, 81, 247),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: double.infinity,
                              height: 15,
                            ),
                            Text(
                              'Penagihan Bulan Agustus',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 5,
                            ),
                            Text(
                              'Rp 25.000.000',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sudah Bayar',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      '25',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Belum Bayar',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      '29',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 15,
                ),
                CustomButton(
                    title: 'Tambah Tagihan',
                    onPressed: () {
                      _presentMonthPicker();
                    }),
              ],
            ),
          )
        ],
      )),
    );
  }
}
