
// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/controller.dart';
import '../../model/item_model.dart';

class ItemBuilder extends StatefulWidget {
  ItemBuilder({
    super.key,
    required this.index,
    required this.listItem,
    this.isEdit = false,
    this.isEnable = true,
  });
  int index;
  List<ProductModel> listItem;
  bool isEdit ;
  bool isEnable;

  @override
  State<ItemBuilder> createState() => _ItemBuilderState();
}

class _ItemBuilderState extends State<ItemBuilder> {
  final controller = Get.find<HomeController>();
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
          autofocus: widget.isEdit,
          onChanged: (value) =>controller.onTapNameTextField(
            value,
            widget.index,
            widget.listItem,
          ),

          enabled: widget.isEdit,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.listItem[widget.index].errorDescription,
                style: const TextStyle(
                  color: Colors.grey,
                )),
            TextField(
              enabled: widget.isEdit,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              controller: skuController,
              onChanged: (value) => controller.onTapSkuTextField(
                value,
                widget.index,
                widget.listItem,
              ),
 
            ),
            TextField(
              enabled: widget.isEdit,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              controller: colorController,
              onChanged: (value) => controller.onTapColorTextField(
                value,
                widget.index,
                widget.listItem,
              ),

            ),
          ],
        ),
        // trailing icon update
        trailing: widget.isEnable
            ? IconButton(
                icon: Icon(
                  Icons.auto_fix_normal,
                  color: widget.isEdit ? Colors.blueAccent : Colors.red,
                ),
                onPressed: () {
                  _onRightButton();
                })
            : null);
  }

  void _onRightButton() {
     setState(() {
      widget.isEdit = true;
    });
    controller.itemEditLists.add(widget.listItem[widget.index]);
    var colorUpdateId = controller.colorItems.any((element) => element.name == colorController.text)
        ? controller.colorItems.where((element) => element.name == colorController.text).first.id
        : null;
    for (var editElement in controller.itemEditLists) {
      if (editElement.id == widget.listItem[widget.index].id) {
        editElement.name = nameController.text;
        editElement.sku = skuController.text;
        editElement.color = colorUpdateId;
      }
    }
  }


}
