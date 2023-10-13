import 'package:flutter/material.dart';

class CardKendaraan extends StatelessWidget {
  const CardKendaraan(
      {super.key,
      required this.namakendaraan,
      required this.plat,
      required this.status});

  final String namakendaraan;
  final String plat;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 50,
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    namakendaraan,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  const Text('Status Kendaraan'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plat),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    status,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
