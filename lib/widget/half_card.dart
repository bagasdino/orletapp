import 'package:flutter/material.dart';

class HalfCard extends StatelessWidget {
  const HalfCard(
      {super.key,
      required this.alamat_icon,
      required this.judul,
      required this.jumlah});

  final String alamat_icon;
  final String judul;
  final String jumlah;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 50,
      shadowColor: const Color(0xff9698A9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(alamat_icon),
                ),
                const SizedBox(
                  width: 140,
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      judul,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.background),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                Text(
                  jumlah,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.background),
                  textAlign: TextAlign.left,
                ),
              ]),
        ),
      ),
    );
  }
}
