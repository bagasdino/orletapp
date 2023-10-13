import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orletapp/models/env.dart';
import 'package:orletapp/models/mobilaktif.dart';
import 'package:orletapp/ui/add_data_kendaraan.dart';
import 'package:orletapp/ui/add_pelanggan_screen.dart';
import 'package:orletapp/ui/add_penjualan.dart';
import 'package:orletapp/ui/data_pelanggan_screen.dart';
import 'package:orletapp/ui/penagihan_screen.dart';
import 'package:orletapp/widget/half_card.dart';
import 'package:orletapp/widget/icon_menu.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<MobilAktif>>? mobilaktifs;
  final mobilaktifListKey = GlobalKey<_HomeScreenState>();

  @override
  void initState() {
    super.initState();
    mobilaktifs = getMobilList();
    //in first time, this method will be executed
  }

  Future<List<MobilAktif>> getMobilList() async {
    // ignore: prefer_interpolation_to_compose_strings
    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}mobil_aktif.php"));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<MobilAktif> mobilaktifs = items.map<MobilAktif>((json) {
      return MobilAktif.fromJson(json);
    }).toList();

    return mobilaktifs;
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
                    '   PT ORLET NUSANTARA',
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
                                'Penjualan Bulan Agustus',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pelanggan Baru',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mobil Terpasang',
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
                  FutureBuilder<List<MobilAktif>>(
                    future: mobilaktifs,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData)
                        return const CircularProgressIndicator();
                      print("datanyaini" + snapshot.data[0].toString());
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HalfCard(
                            alamat_icon: 'images/icon_mobilactive.png',
                            judul: 'Mobil Aktiv',
                            jumlah: snapshot.data[0].jumlah,
                          ),
                          HalfCard(
                            alamat_icon: 'images/icon_mobilputus.png',
                            judul: 'Mobil Putus',
                            jumlah: snapshot.data[1].jumlah,
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 15,
                  ),
                  Text(
                    '   MENU',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const DataPelangganScreen();
                          }));
                        },
                        child: const IconMenu(
                            iconmenu: 'images/icon_pengguna.png',
                            nama_menu: 'Data\nPelanggan'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PenagihanScreen();
                          }));
                        },
                        child: const IconMenu(
                            iconmenu: 'images/icon_bill.png',
                            nama_menu: 'Penagihan'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const IconMenu(
                          iconmenu: 'images/icon_penjualan.png',
                          nama_menu: 'Penjualan'),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Tambahkan Data',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          const AddPelangganScreen());
                                  Navigator.push(context, route);
                                },
                                child: const IconMenu(
                                    iconmenu: 'images/icon_pengguna.png',
                                    nama_menu: 'Data\nPelanggan'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          const AddKendaraanScreen(""));
                                  Navigator.push(context, route);
                                },
                                child: const IconMenu(
                                    iconmenu: 'images/icon_mobil.png',
                                    nama_menu: 'Data\nKendaraan'),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          const AddPenjualanScreen(""));
                                  Navigator.push(context, route);
                                },
                                child: const IconMenu(
                                    iconmenu: 'images/icon_penjualan.png',
                                    nama_menu: 'Penjualan'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 11, 83, 252),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class Item {
  final String status;
  final String jumlah;

  Item({required this.status, required this.jumlah});
}
