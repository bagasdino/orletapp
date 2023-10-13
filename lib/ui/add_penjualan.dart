import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:orletapp/models/env.dart';
import 'package:orletapp/ui/add_data_kendaraan.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_form_field.dart';

final formatter = DateFormat.yMd();

class AddPenjualanScreen extends StatefulWidget {
  final String? username;
  const AddPenjualanScreen(this.username);

  @override
  State<AddPenjualanScreen> createState() => _AddPenjualanScreenState();
}

class _AddPenjualanScreenState extends State<AddPenjualanScreen> {
  late TextEditingController _namaakun;

  DateTime? _selectedDate;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void initState() {
    _namaakun = TextEditingController(text: widget.username);
  }

  var jumlah = TextEditingController();

  // define a list of options for the dropdown
  final List<String> _paketGPS = [
    "Paket 650.000",
    "Paket 800.000",
    "Paket 1.000.000"
  ];

  final _formKey = GlobalKey<FormState>();

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
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        String tanggal = dateFormat.format(_selectedDate!);
        int id_paket = _paketGPS.indexOf(_selectedPaketGPS!) + 1;
        String paket = id_paket.toString();
        return await http.post(
          Uri.parse("${Env.URL_PREFIX}add_penjualan.php"),
          body: {
            "id_user": _namaakun.text,
            "id_paket": paket,
            "tanggal_beli": tanggal,
            "jumlah": jumlah.text,
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
  }

  //the selected value
  String? _selectedPaketGPS;
  int? _selectedPaketGPSint;

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Text(
          'Tambah Data Penjualan',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget inputSection() {
      Widget tanggalInput() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal Pemasangan'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_selectedDate == null
                    ? 'Pilih Tanggal'
                    : formatter.format(_selectedDate!)),
                IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_month))
              ],
            ),
          ],
        );
      }

      Widget usernameInput() {
        return CustomTextFormField(
          title: 'Nama akun',
          hintText: "Nama akun",
          textType: TextInputType.text,
          controller: _namaakun,
          obsecureText: false,
          textKosong: "Nama akun tidak boleh kosong",
        );
      }

      Widget paketGPSInput() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Paket GPS'),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              width: 300,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30)),
              child: DropdownButton<String>(
                value: _selectedPaketGPS,
                onChanged: (value) {
                  setState(() {
                    _selectedPaketGPS = value;
                  });
                },
                hint: const Center(
                  child: Text(
                    'Pilih Paket GPS',
                  ),
                ),
                underline: Container(),
                icon: const Icon(
                  Icons.arrow_downward,
                  color: Colors.blue,
                ),
                isExpanded: true,
                items: _paketGPS
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ))
                    .toList(),
                selectedItemBuilder: (BuildContext context) => _paketGPS
                    .map((e) => Center(
                          child: Text(
                            e,
                            style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        );
      }

      Widget jenisKendaraanInput() {
        return CustomTextFormField(
          title: 'Jumlah',
          hintText: "Jumlah",
          controller: jumlah,
          textType: TextInputType.number,
          obsecureText: false,
          textKosong: "Jumlah tidak boleh kosong",
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
              tanggalInput(),
              usernameInput(),
              paketGPSInput(),
              jenisKendaraanInput(),
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
                              AddKendaraanScreen(_namaakun.text),
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
