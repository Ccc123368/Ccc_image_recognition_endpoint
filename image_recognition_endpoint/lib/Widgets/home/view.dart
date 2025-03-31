import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Moudles/basic.dart';
import '../../Moudles/imageSelector.dart';
import 'logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  TextEditingController shipNum_controller = TextEditingController();
  TextEditingController warehouseNum_controller = TextEditingController();
  TextEditingController freightyardNum_controller = TextEditingController();
  TextEditingController rulerLength_controller = TextEditingController();
  final ImagePickerController imagePickerControllercontroller = Get.put(ImagePickerController());


  @override
  Widget build(BuildContext context) {
    final logic = Get.put(HomeLogic());
    final state = Get.find<HomeLogic>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text("图像信息上传终端"),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20,),
          Text("声明：",style: TextStyle(fontSize: 20),),
          Text("你可以在这里添加声明。。。。。。。。。。。"),
          SizedBox(height: 50,),
          Divider(),
          buildEditableField(
              "船号:",
              shipNum_controller,(value){
                state.shipNum.value = value;
          }
          ),
          buildEditableField(
              "仓号:",
              warehouseNum_controller,(value){
            state.shipNum.value = value;
          }
          ),

          buildEditableField(
              "货场编号:",
              freightyardNum_controller,(value){
            state.shipNum.value = value;
          }
          ),
          // buildEditableField(
          //     "检尺长:",
          //     rulerLength_controller,(value){
          //   state.shipNum.value = value;
          // }
          // ),

          Row(
            children: [
              Column(
                children: [
                  Text("RGB图片"),
                  PublishImageArea(),
                ],
              ),
              SizedBox(width: 20,),
              Column(
                children: [
                  Text("深度图"),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.green
                    ),
                    child: Center(child: Text("深度图选择器")),
                  )
                ],
              ),

            ],
          ),
          SizedBox(height: 30,),
          ElevatedButton(
              onPressed: (){
                Fluttertoast.showToast(msg:
                    "船号：${state.shipNum.value}\n"
                    "仓号:${state.warehouseNum.value}\n"
                    "货场编号:${state.freightyardNum.value}\n"
                    "检尺长:${state.rulerLength.value}\n"
                );
              }, child: Text("提交材料")
          )
        ],
      ),
    );
  }
}
