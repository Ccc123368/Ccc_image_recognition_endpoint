/// @Author: Hui_Loading 3080811164@qq.com
/// @Date: 2024-09-15 14:11:03
/// @LastEditors: Hui_Loading 3080811164@qq.com
/// @LastEditTime: 2025-03-28 19:35:30
/// @FilePath: lib/Permissions/Systemstart_getPermissions.dart
/// @Description: 启动前权限检测


import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';


//权限审查
Future<void> checkPermission() async {
  print("开始审查权限");
  Permission permission = Permission.location;
  List<Permission> permissions = [
    // Permission.location,//定位
    Permission.storage,//存储
    Permission.camera,//相机
    Permission.photos,//图片权限
    //还缺一个前台服务
  ];
  
  
  for(var permission in permissions){
    PermissionStatus status = await permission.status;
    //打印正在检测的权限名称
    print('正在检测的权限名称为$permission');
    print('权限状态$status');
    if (status.isGranted) {
      //权限通过
      // LogI("权限检测已通过");
    } else if (status.isDenied) {
      //权限拒绝， 需要区分IOS和Android，二者不一样
      await requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      // 权限永久拒绝，且不在提示，需要进入设置界面
      Fluttertoast.showToast(msg: "权限永久拒绝且不再提示，需要您手动进入设置界面进行设置");
      await openAppSettings();
    } else if (status.isRestricted) {
      //TODO 活动限制（例如，设置了家长///控件，仅在iOS以上受支持。
      Fluttertoast.showToast(msg: "$permission 权限获取受到限制，需要您手动进入设置界面进行设置");
      await openAppSettings();
    } else {
      //第一次申请
      await requestPermission(permission);
    }
  }
  
}



//申请权限
Future<void> requestPermission(Permission permission) async {
  //LogI("申请权限功能被调用");
  //Permission.locationAlways.request();
  PermissionStatus status = await permission.request();
  print('权限状态$status');
  if (!status.isGranted) {
    //请求权限
    // Permission.locationAlways.request();
    //LogI("自动拉起权限申请失败，请手动赋予");
    Fluttertoast.showToast(msg: "自动拉起权限申请失败，请手动赋予${permission.toString()}");
    openAppSettings();
  }
}

