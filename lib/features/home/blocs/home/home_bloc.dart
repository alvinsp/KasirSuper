import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/product/product.dart';
import 'package:kasirsuper/features/transaction/transaction.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<GetDataHomeEvent>((event, emit) async {
      final products = await ProductService.getAll('');

      final transactions = await TransactionService.getAll(null);

      final transactionsSale = await TransactionService.getAll(TypeEnum.paid);

      num totalSale = 0;

      for (var element in transactionsSale) {
        totalSale += (element.amount - element.discount);
      }

      emit(state.copyWith(
        totalProduct: products.length,
        totalTransaction: transactions.length,
        totalSale: totalSale,
      ));
    });
  }
}
