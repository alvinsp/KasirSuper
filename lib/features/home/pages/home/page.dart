import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/home/home.dart';

part 'sections/card_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetDataHomeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.dp16),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              children: [
                _CardSection(
                  label: 'Total Penjualan',
                  value: state.totalSale.toIDR(),
                ),
                Dimens.dp16.height,
                _CardSection(
                  label: 'Total Transaksi',
                  value: state.totalTransaction.toString(),
                ),
                Dimens.dp16.height,
                _CardSection(
                  label: 'Total Produk',
                  value: '${state.totalProduct}',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
