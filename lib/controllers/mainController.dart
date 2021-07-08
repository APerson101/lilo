import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lilo/controllers/authentication.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/views/main_home/main_home.dart';

// enum PageType { dashboard, profile, transactions, cards, about, settings }

class MainController extends GetxController {
  AuthenticationController controller = Get.find();
  Rx<PageType> _currentPage = PageType.dashboard.obs;
  Rx<PageType> get currentPage => _currentPage;
  RxInt _thisNumber = 0.obs;
  int index = 0;
  int get currentIndex => index;

  RxInt get number => _thisNumber;

  @override
  void onInit() {
    super.onInit();
  }

  changePage(PageType newPage) {
    index = newPage.index;
    print(index);
    _currentPage.value = newPage;
  }

  updateNumber() {
    _thisNumber += 5;
  }
}
