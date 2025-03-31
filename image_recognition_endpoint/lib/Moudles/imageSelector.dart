/// @Author: Hui_Loading 3080811164@qq.com
/// @Date: 2025-03-28 19:11:16
/// @LastEditors: Hui_Loading 3080811164@qq.com
/// @LastEditTime: 2025-03-28 21:09:44
/// @FilePath: lib/Moudles/imageSelector.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// AddPhotoWidget 组件，用于展示“添加照片”按钮
class AddPhotoWidget extends StatelessWidget {
  final VoidCallback onTap; // 点击事件回调

  const AddPhotoWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 点击事件触发图片选择
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 设置主轴方向上的对齐方式为居中
            children: [
              Icon(
                Icons.image,
                color: Colors.grey[600],
              ),
              SizedBox(height: 4), // 添加间距以分隔图标和文本
              Text(
                "照片/视频",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// ImagePickerController 负责管理图片选择逻辑
class ImagePickerController extends GetxController {
  var selectedAssets = <AssetEntity>[].obs; // 使用 RxList 来存储已选择的资源
  // 使用 wechat_assets_picker 选择图片
  Future<void> pickAssets(BuildContext context) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 1,
        selectedAssets: selectedAssets,
        specialItemPosition: SpecialItemPosition.prepend,
        specialItemBuilder: (
            BuildContext context,
            AssetPathEntity? path,
            int length,
            ) {
          if (path?.isAll != true) {
            return null;
          }
          return Semantics(
            label: "Use Camera",
            button: true,
            onTapHint: "Use Camera",
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                Feedback.forTap(context);
                final AssetEntity? result = await _pickFromCamera(context);
                if (result != null) {
                  selectedAssets.add(result);
                  Get.back();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(28.0),
                color: Theme.of(context).dividerColor,
                child: const FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(Icons.camera_alt),
                ),
              ),
            ),
          );
        },
      ),
    );
    if (result != null) {
      selectedAssets.assignAll(result); // 更新已选资源
    }
  }

  // 删除选中的图片
  void removeAsset(AssetEntity asset) {
    selectedAssets.remove(asset);
  }

  // 预览图片
  void previewAssets(BuildContext context, int index) async {
    await AssetPickerViewer.pushToViewer(
      context,
      currentIndex: index,
      previewAssets: selectedAssets,
      themeData: AssetPicker.themeData(Colors.blue),
      selectedAssets: selectedAssets,
      selectorProvider: DefaultAssetPickerProvider(selectedAssets: selectedAssets),
      specialPickerType: null,
    );
  }
}



///PublishImageArea 组件用于展示已选择的图片，并提供删除功能
class PublishImageArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ImagePickerController controller = Get.find(); // 获取控制器

    return Obx(() {
      if (controller.selectedAssets.isEmpty) {
        return Align(
          alignment: Alignment.centerLeft,
          child: AddPhotoWidget(
            onTap: () => controller.pickAssets(context), // 点击添加照片或视频
          ),
        );
      } else {
              return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.previewAssets(context, 0); // 预览图片或视频
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image(
                            image: AssetEntityImageProvider(
                              controller.selectedAssets.first,
                              isOriginal: false, // 优先加载缩略图以提高性能
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // 如果是视频，添加播放图标
                    if (controller.selectedAssets.first.type == AssetType.video)
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: (){
                                controller.previewAssets(context, 0); // 预览图片或视频
                              },
                              icon: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white38,
                                size: 32,
                              ),)



                        ),
                      ),
                    // 删除按钮始终放在右上角
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          controller.removeAsset(controller.selectedAssets.first); // 删除图片或视频
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        
      }
    });
  }
}
Future<AssetEntity?> _pickFromCamera(BuildContext c) {
  return CameraPicker.pickFromCamera(
    c,
    pickerConfig: const CameraPickerConfig(enableRecording: true),
  );
}