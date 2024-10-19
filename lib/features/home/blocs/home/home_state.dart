part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.totalProduct = 0,
    this.totalSale = 0,
    this.totalTransaction = 0,
  });

  factory HomeState.initial() {
    return const HomeState();
  }

  final num totalSale;
  final num totalTransaction;
  final num totalProduct;

  HomeState copyWith({
    num? totalSale,
    num? totalTransaction,
    num? totalProduct,
  }) {
    return HomeState(
      totalProduct: totalProduct ?? this.totalProduct,
      totalSale: totalSale ?? this.totalSale,
      totalTransaction: totalTransaction ?? this.totalTransaction,
    );
  }

  @override
  List<Object> get props => [totalProduct, totalSale, totalTransaction];
}
