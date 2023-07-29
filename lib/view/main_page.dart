// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../controller/controller.dart';
import '../model/item_model.dart';

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
    controller.fetchItem();

    // controller.fetchItems();
    // controller.fetchColors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listView(),
    );
  }

  Widget listView() {
    return Obx(() => controller.loading.value
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
                  onRefresh: () {
                    controller.refreshController.resetNoData();
                    controller.fetchItem();
                  },
                  onLoading: () {
                    controller.fetchItemLoadmore(controller.offset.toInt());
                  },
                  child: ListView.separated(
                      // shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return itemList(
                          index: index,
                          listItem: controller.itemItems,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(thickness: 0.5);
                      },
                      itemCount: controller.itemItems.length),
                ),
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    for (var element in controller.itemItems) {
                      element.name.length > 50 ? controller.errorMessages = "${controller.errorMessages} + ${element.name} must be less than 50 characters" : null;
                      element.sku.length > 20 ? controller.errorMessages = "SKU ${element.sku} must be less than 20 characters" : null;
                    }
                    controller.errorMessages!.isEmpty ? _dialogBuilder(context) : EasyLoading.showError(controller.errorMessages!);
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submit Change'),
          content: SizedBox(
            height: 200,
            width: 200,
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return itemList(
                    index: index,
                    listItem: controller.editItems,
                    isEdit: false,
                  );
                },
                itemCount: controller.editItems.length),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                controller.editItems.clear();
              },
            ),
          ],
        );
      },
    );
  }
}

class itemList extends StatefulWidget {
  itemList({super.key, required this.index, required this.listItem, this.isEdit = true});
  int index;
  List<ProductModel> listItem;
  bool isEdit;

  @override
  State<itemList> createState() => _itemListState();
}

class _itemListState extends State<itemList> {
  final HomeController controller = Get.put(HomeController());
  late final nameController;
  late final skuController;
  late final colorController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.listItem[widget.index].name);
    skuController = TextEditingController(text: widget.listItem[widget.index].sku);
    colorController = TextEditingController(
        text: controller.colorItems.any((element) => element.id == widget.listItem[widget.index].color)
            ? controller.colorItems.where((element) => element.id == widget.listItem[widget.index].color).first.name
            : "No Color");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.network(
          widget.listItem[widget.index].image,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 30,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "No Image",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        title: TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          controller: nameController,
          enabled: widget.isEdit,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.listItem[widget.index].errorDescription, style: TextStyle(color: widget.isEdit == false ? Colors.grey : Colors.black)),
            TextField(
              enabled: widget.isEdit,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              controller: skuController,
            ),
            TextField(
              enabled: widget.isEdit,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              controller: colorController,
            ),
          ],
        ),
        // trailing icon update
        trailing: widget.isEdit
            ? IconButton(
                icon: const Icon(Icons.auto_fix_normal),
                onPressed: controller.errorMessages!.isEmpty
                    ? () {
                        controller.updateItem(
                          controller.itemItems[widget.index].id,
                          nameController.text,
                          colorController.text,
                          skuController.text,
                        );
                        EasyLoading.showSuccess('Great Success!');
                      }
                    : () {
                        EasyLoading.showError(controller.errorMessages.toString());
                      },
              )
            : null);
  }
}
