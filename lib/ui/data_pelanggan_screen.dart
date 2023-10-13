import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orletapp/models/env.dart';
import 'package:orletapp/widget/card_list_pelanggan.dart';

import '../models/pelanggan.dart';
import 'detail_pelanggan_screen.dart';
import 'package:http/http.dart' as http;

class DataPelangganScreen extends StatefulWidget {
  const DataPelangganScreen({super.key});

  @override
  State<DataPelangganScreen> createState() => _DataPelangganScreenState();
}

class _DataPelangganScreenState extends State<DataPelangganScreen> {
  late Future<List<Pelanggan>> pelanggans;
  final pelangganListKey = GlobalKey<_DataPelangganScreenState>();
  @override
  void initState() {
    super.initState();
    pelanggans = getPelangganList();
  }

  Future<List<Pelanggan>> getPelangganList() async {
    final response = await http.get(Uri.parse("${Env.URL_PREFIX}list.php"));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Pelanggan> pelanggans = items.map<Pelanggan>((json) {
      return Pelanggan.fromJson(json);
    }).toList();

    return pelanggans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Data Pelanggan',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: FutureBuilder<List<Pelanggan>>(
                    future: pelanggans,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();

                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = snapshot.data[index];
                            return GestureDetector(
                              child: CardDataPelanggan(
                                  nama: data.nama,
                                  kota: data.alamat,
                                  jmlKendaraan: data.jml),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPelangganScreen(pelanggan: data),
                                  ),
                                );
                              },
                            );
                          });
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
