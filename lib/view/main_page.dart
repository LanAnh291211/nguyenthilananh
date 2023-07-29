// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controller/controller.dart';
import 'widget/itemBuilder.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listView(),
    );
  }

  Widget listView() {
    return Obx(() {
      var submitButton = ElevatedButton(
        onPressed: () {
          _onSubmitButton();
        },
        child: const Text('SUBMIT'),
      );
      return controller.loading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 9,
                  child: SmartRefresher(
                    enablePullUp: true,
                    controller: controller.refreshController,
                    onRefresh: _onRefresh,
                    onLoading: () => controller.fetchItemLoadmore(controller.offset.toInt()),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ItemBuilder(
                            index: index,
                            listItem: controller.itemItems,
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(thickness: 0.5),
                        itemCount: controller.itemItems.length),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: submitButton,
                ),
              ],
            );
    });
  }

  void _onSubmitButton() {
    for (var element in controller.itemEditLists) {
      element.name.length > 50 || element.name.isEmpty
          ? controller.errorMessages = "${controller.errorMessages}. + ${element.name} is required and must be less than 50 characters "
          : null;
      element.sku.length > 20 || element.sku.isEmpty
          ? controller.errorMessages = "${controller.errorMessages}. + SKU ${element.sku} is required and must be less than 20 characters"
          : null;
    }
    for (int i = 0; i < controller.itemItems.length; i++) {
      setState(() {
        ItemBuilder(
          index: i,
          listItem: controller.itemItems,
          isEdit: false,
          isEnable: false,
        );
      });
    }

    for (var element in controller.itemItems) {
      for (var editElement in controller.itemEditLists) {
        if (element.id == editElement.id) {
          element.name = editElement.name;
          element.sku = editElement.sku;
        }
      }
    }
    controller.errorMessages!.isEmpty ? _dialogBuilder(context) : EasyLoading.showError(controller.errorMessages!);
  }

  void _onRefresh() {
    controller.refreshController.resetNoData();
    controller.fetchItem();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Change'),
          content: SizedBox(
            height: 200,
            width: 300,
            child: controller.itemEditLists.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ItemBuilder(
                        index: index,
                        listItem: controller.itemEditLists,
                        isEdit: false,
                        isEnable: false,
                      );
                    },
                    itemCount: controller.itemEditLists.length)
                : const Center(
                    child: Text("No change"),
                  ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                controller.itemEditLists.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
