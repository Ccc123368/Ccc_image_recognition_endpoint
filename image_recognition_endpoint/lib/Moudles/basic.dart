import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @Author: Hui_Loading 3080811164@qq.com
/// @Date: 2025-03-28 18:49:08
/// @LastEditors: Hui_Loading 3080811164@qq.com
/// @LastEditTime: 2025-03-28 18:50:05
/// @FilePath: lib/Moudles/basic.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置
// 可编辑字段

Widget buildEditableField(
    String label,
    TextEditingController controller,
    Function(String) onChanged) {
  return Container(
    height: 60, // 设置统一高度
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Row(
      children: [
        const SizedBox(width: 20),
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),

        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            ),
            onChanged: (value) => onChanged(value),
          ),
        ),
      ],
    ),
  );
}