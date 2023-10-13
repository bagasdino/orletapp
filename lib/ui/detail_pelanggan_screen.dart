import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orletapp/models/mobil_pelanggan.dart';
import 'package:orletapp/models/pelanggan.dart';
import 'package:orletapp/widget/card_kendaraan.dart';
import 'package:orletapp/widget/card_list_pelanggan.dart';
import 'package:orletapp/widget/custom_button.dart';
import 'package:orletapp/widget/custom_button_half.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/env.dart';
import '../models/tagih.dart';
import '../widget/list_detail.dart';
import 'package:http/http.dart' as http;

import 'add_data_kendaraan.dart';

class DetailPelangganScreen extends StatefulWidget {
  final Pelanggan pelanggan;
  const DetailPelangganScreen({super.key, required this.pelanggan});

  @override
  State<DetailPelangganScreen> createState() => _DetailPelangganScreenState();
}

class _DetailPelangganScreenState extends State<DetailPelangganScreen> {
  late Future<List<MobilPelanggan>> mobilpelanggans;
  final mobilpelangganListKey = GlobalKey<_DetailPelangganScreenState>();

  String tagiane = '-';
  late Future<List<Tagih>> tagihs;
  final tagihListKey = GlobalKey<_DetailPelangganScreenState>();

  @override
  void initState() {
    super.initState();
    mobilpelanggans = getDataMobilList();
    tagihs = getDataTagihan();
  }

  Future<List<MobilPelanggan>> getDataMobilList() async {
    try {
      final response = await http.get(Uri.parse(
          "${Env.URL_PREFIX}mobil_pelanggan.php?id_user=" +
              widget.pelanggan.username));

      final items = json.decode(response.body);
      final itembeneran = items.cast<Map<String, dynamic>>();

      List<MobilPelanggan> mobilpelanggans = items.map<MobilPelanggan>((json) {
        return MobilPelanggan.fromJson(json);
      }).toList();

      return mobilpelanggans;
    } catch (e) {
      print(e);
    }

    return mobilpelanggans;
  }

  Future<List<Tagih>> getDataTagihan() async {
    try {
      final response = await http.get(Uri.parse(
          "${Env.URL_PREFIX}show_tagihan.php?id_user=" +
              widget.pelanggan.username));
      String cipeng = response.body;
      var parsedJson = json.decode(cipeng);
      String tagihane = parsedJson[0]["jumlah_tagihan"];

      int amount = int.parse(tagihane);
      final currencyFormat =
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      String formattedAmount = currencyFormat.format(amount.toDouble());

      print("datanyainis" + tagihane);
      setState(() {
        tagiane = formattedAmount;
      });
      //  List<Tagih> tagihs = itemss.map<Tagih>((json) {
      //    return Tagih.fromJson(json);
      //   }).toList();

      //return tagihane.toString();
    } catch (e) {
      print("datanyainiss" + e.toString());
    }

    return tagihs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Pelanggan',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Card(
                  elevation: 50,
                  shadowColor: const Color(0xff9698A9),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailWidget(
                              judul: 'Nama', isi: widget.pelanggan.nama),
                          DetailWidget(
                              judul: 'Alamat', isi: widget.pelanggan.alamat),
                          DetailWidget(
                              judul: 'No WA', isi: widget.pelanggan.nomor_wa),
                          DetailWidget(
                              judul: 'Username',
                              isi: widget.pelanggan.username),
                          DetailWidget(
                              judul: 'Password',
                              isi: widget.pelanggan.password),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  'Kendaraan',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<MobilPelanggan>>(
                  future: mobilpelanggans,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData)
                      return const Text('Belum ada data kendaraan');
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = snapshot.data[index];
                          return GestureDetector(
                            child: CardKendaraan(
                                namakendaraan: data.jenis_mobil,
                                plat: data.plat_mobil,
                                status: data.status),
                            onTap: () {},
                          );
                        });
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),
                CustomButton(
                    title: 'Tambah Data Kendaraan',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddKendaraanScreen(widget.pelanggan.username),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 10.0,
                ),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Tagihan',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tagiane,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              SizedBox(
                                width: 120,
                              ),
                              Text('Belum dibayar'),
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButtonHalf(
                                  title: 'Tagih Sekarang',
                                  onPressed: () async {
                                    String nomor = widget.pelanggan.nomor_wa;

                                    try {
                                      mobilpelanggans.then((dataList) {
                                        final namamobilList = dataList
                                            .map((map) =>
                                                map.jenis_mobil.toString())
                                            .toList();
                                        final platList = dataList
                                            .map((map) =>
                                                map.plat_mobil.toString())
                                            .toList();
                                        var whatsappUrl = "whatsapp://send?phone=" +
                                            nomor +
                                            "&text=Assamualaikum\nMohon maaf untuk biaya Pulsa GPS :\nBiaya : *" +
                                            tagiane +
                                            "*\n \nMobil : \n$namamobilList\n$platList\n "
                                                "\nBisa di transfer ke rekening \n4610519551\nMOCHAMAD USMAN\nBCA\n \nmohon sertakan screenshot bukti pembayaran jika sudh melakukan pembayaran\nTERIMAKASIH";
                                        try {
// ignore: deprecated_member_use
                                          launch(whatsappUrl);
                                        } catch (e) {
                                          print('errorrnya ini' + e.toString());
                                        }
                                      });
                                    } catch (e) {
                                      print("Error: $e");
                                    }
                                  }),
                              CustomButtonHalf(
                                  title: 'Sudah Bayar', onPressed: () {})
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Lihat Riwayat Pembayaran',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
