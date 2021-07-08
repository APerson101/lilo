// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:lilo/models/wallet.dart';
// import 'package:lilo/repositories/user_repo.dart';

// part 'transactions_event.dart';
// part 'transactions_state.dart';

// class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
//   TransactionsBloc({required this.userRepository})
//       : super(TransactionsInitial());
//   UserRepository userRepository;
//   @override
//   Stream<TransactionsState> mapEventToState(
//     TransactionsEvent event,
//   ) async* {
//     // TODO: implement mapEventToState
//     if (event is LoadTransactionsHistory) {
//       //

//       yield TransactionsLoading();
//       var transactions = await userRepository.loadTransactionsHistory();
//       var pendingTransfers = await userRepository.loadPendingTransfer();
//       yield TransactionsLoadSuccess(
//           transactions: transactions,
//           pending: pendingTransfers,
//           walletID: userRepository.wallet!.eWalletID!);
//     }
//   }
// }
