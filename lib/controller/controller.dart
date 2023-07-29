// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../model/item_model.dart';
import '../services/remote_services.dart';

class HomeController extends GetxController {
  var colorItems = List<ColorModel>.empty().obs;
  String? errorMessages = ''.obs.toString();
  var offset = 0.obs.toInt();
  var refreshController = RefreshController();
  var itemItems = List<ProductModel>.empty().obs;
  var itemEditLists = List<ProductModel>.empty().obs;

  var loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItem();

    fetchColors();
  }

  Future<void> fetchItem() async {
    loading.value = true;
    itemItems.clear();
    var getItems = await RemoteServices.fetchItems();
    loading.value = false;
    if (getItems != null) {
      for (int i = 0; i < 10; i++) {
        itemItems.add(ProductModel.fromJson(getItems[i]));
      }
      offset = 1;
    }
  }

  Future<void> fetchItemLoadmore(int page) async {
    var getItems = await RemoteServices.fetchItems();
    if (getItems != null) {
      refreshController.loadComplete();
      if (getItems.length <= (page - 1) * 10) {
        refreshController.loadNoData();
        offset = 1;
      } else {
        if ((getItems.length > page * 10)) {
          for (int i = (page - 1) * 10; i < page * 10; i++) {
            itemItems.add(ProductModel.fromJson(getItems[i]));
          }
        } else
          for (int i = (page - 1) * 10; i < getItems.length; i++) {
            itemItems.add(ProductModel.fromJson(getItems[i]));
          }

        offset += 1;
      }
    }
  }

  Future<void> fetchColors() async {
    loading.value = true;
    colorItems.clear();
    var getColors = await RemoteServices.fetchColors();
    loading.value = false;
    if (getColors != null) {
      getColors.forEach((item) {
        colorItems.add(ColorModel.fromJson(item));
      });
    }
  }

  void onTapNameTextField(value, int index, List<ProductModel> listItem) {
    listItem[index].name = value;
    for (var editElement in itemEditLists) {
      if (editElement.id == listItem[index].id) {
        editElement.name = value;
      }
    }
  }

  void onTapColorTextField(value, int index, List<ProductModel> listItem) {
    var colorUpdateId = colorItems.any((element) => element.name ==value)
        ? colorItems.where((element) => element.name ==value).first.id
        : null;
    listItem[index].color = colorUpdateId;
    for (var editElement in itemEditLists) {
      if (editElement.id == listItem[index].id) {
        editElement.color = colorUpdateId;
      }
    }
  }

  void onTapSkuTextField(value, int index, List<ProductModel> listItem) {
   listItem[index].sku = value;
    for (var editElement in itemEditLists) {
      if (editElement.id ==listItem[index].id) {
        editElement.sku = value;
      }
    }
  }
  
}
