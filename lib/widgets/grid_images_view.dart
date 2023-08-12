// ignore_for_file: must_be_immutable
//@dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_save/image_save.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:xigyu_manager/utils/utils.dart';

///九宫格图片

class ImagesGridviewWidget extends StatefulWidget {
  int max;
  List<MyImage> images = [];

  ImagesGridviewWidget(this.max);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ImagesGridviewWidgetState();
  }
}

class ImagesGridviewWidgetState extends State<ImagesGridviewWidget> {
//  List<String> _titles = [
//    'assets/images/1.jpg',
//    'assets/images/2.jpg',
//    'assets/images/3.jpg',
//    'assets/images/4.jpg',
//    'assets/images/5.jpg',
//    'assets/images/6.jpg',
//    'assets/images/7.jpg',
//    'assets/images/8.jpg',
//    'assets/images/9.jpg'
//  ];

  String _movingValue; // 记录正在移动的值
  List<AssetEntity> assets = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var gradWidth = width - 30; //9宫格的大小
    var itemWidth = gradWidth / 3; //某张图片拖动时 的大小

    // TODO: implement build
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 1),
      children: buildItems(itemWidth),
      physics: NeverScrollableScrollPhysics(), //禁止滚动
      shrinkWrap: true,
    );
  }

  // 生成GridView的items
  List<Widget> buildItems(var itemWidth) {
    List<Widget> items = List<Widget>();
    widget.images.forEach((myimage) {
//      items.add(draggableItem(itemWidth, myimage.uuid));
      items.add(baseItem(itemWidth, myimage, Colors.white.withOpacity(0.8)));
    });
    if (items.length < widget.max || items.length == 0) {
      items.add(pickerImageButton(
        itemWidth,
      ));
    }
    return items;
  }

  // 生成可拖动的item
  Widget draggableItem(itemWidth, value) {
    return Draggable(
      data: value,
      child: DragTarget(
        builder: (context, candidateData, rejectedData) {
          return baseItem(itemWidth, value, Colors.white);
        },
        onWillAccept: (moveData) {
//          print('=== onWillAccept: $moveData ==> $value');

          var accept = moveData != null;
          if (accept) {
            exchangeItem(moveData, value, false);
          }
          return accept;
        },
        onAccept: (moveData) {
//          print('=== onAccept: $moveData ==> $value');
          exchangeItem(moveData, value, true);
        },
        onLeave: (moveData) {
//          print('=== onLeave: $moveData ==> $value');
        },
      ),
      feedback: baseItem(itemWidth, value, Colors.white.withOpacity(0.8)),
      childWhenDragging: null,
      onDragStarted: () {
//        print('=== onDragStarted');
        setState(() {
          _movingValue = value;
        });
      },
      onDraggableCanceled: (Velocity velocity, Offset offset) {
//        print('=== onDraggableCanceled');
        setState(() {
          _movingValue = null;
        });
      },
      onDragCompleted: () {
//        print('=== onDragCompleted');
      },
    );
  }

  MyImage getMyImageByuuid(String uuid) {
    for (int i = 0; i < widget.images.length; ++i) {
      if (widget.images[i].uuid.compareTo(uuid) == 0) {
        return widget.images[i];
      }
    }

    return null;
  }

  // 基础展示的item 此处设置width,height对GridView 无效，主要是偷懒给feedback用
  Widget baseItem(itemWidth, value, bgColor) {
//    if (value == _movingValue) {
//      return Container();
//    }
//
//    Asset asset = getMyImageByuuid(value).asset;

    return Container(
      width: itemWidth,
      height: itemWidth,
      color: bgColor,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Image.file(
            File(value.asset),
            width: itemWidth,
            height: itemWidth,
            fit: BoxFit.cover,
          ),
          new Positioned(
            right: 0.08,
            top: 0.08,
            child: new GestureDetector(
//                onTap: onCancel,
              child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.images.remove(value);
                      });
                    },
                    child: new Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  )),
            ),
          ),
        ],
      ),

//        child: Text(
//          value,
//          textAlign: TextAlign.center,
//          style: TextStyle(
//              fontWeight: FontWeight.bold,
//              fontSize: 20,
//              color: Colors.yellowAccent),
//        ),
    );
  }

  // 重新排序
  void exchangeItem(moveData, toData, onAccept) {
    setState(() {
      MyImage tomyImage = getMyImageByuuid(toData);
      var toIndex = widget.images.indexOf(tomyImage);

      MyImage movemyImage = getMyImageByuuid(moveData);

      widget.images.remove(movemyImage);
      widget.images.insert(toIndex, movemyImage);

      if (onAccept) {
        _movingValue = null;
      }
    });
  }

  Widget pickerImageButton(
    itemWidth,
  ) {
    return GestureDetector(
        onTap: _showImagePicker,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: itemWidth,
          height: itemWidth,
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: Colors.grey,
                size: itemWidth / 3,
              ),
              Text(
                "照片/拍摄",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ));
  }

  /// 弹出拍照或相册对话框
  void _showImagePicker() {
    if (widget.images.length >= widget.max) {
      showToast('请先添加配件');
      return;
    }
    hideKeyboard(context);
    showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(10),
          height: 56 * 2.toDouble(),
          child: Column(
            children: ListTile.divideTiles(tiles: [
              ListTile(
                title: Center(child: Text("拍摄")),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                  title: Center(child: Text("相册")),
                  onTap: () {
                    Navigator.of(context).pop();
                    _getImage(ImageSource.gallery);
                  })
            ], color: Colors.grey)
                .toList(),
          ),
        );
      },
      elevation: 10,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
    );
  }

  ///选取图片
  _getImage(ImageSource source) async {
    var imagePath = '';
    if (source == ImageSource.gallery) {
      List<AssetEntity> temp = [];
      AssetPickerConfig pickerConfig = AssetPickerConfig(
          maxAssets: widget.max - widget.images.length,
          specialPickerType: SpecialPickerType.wechatMoment,
//            requestType: RequestType.image,
//            allowSpecialItemWhenEmpty: true,
          specialItemBuilder: (
            BuildContext context,
            AssetPathEntity path,
            int length,
          ) {
            if (path?.isAll != true) {
              return null;
            }
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final AssetEntity result = await CameraPicker.pickFromCamera(
                  context,
                  pickerConfig: const CameraPickerConfig(enableRecording: true),
                );
                if (result == null) {
                  return;
                }
                final AssetPicker<AssetEntity, AssetPathEntity> picker =
                    context.findAncestorWidgetOfExactType();
                final DefaultAssetPickerBuilderDelegate builder =
                    picker.builder as DefaultAssetPickerBuilderDelegate;
                final DefaultAssetPickerProvider p = builder.provider;
                await p.switchPath(p.currentPath);
                p.selectAsset(result);
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            );
          },
          specialItemPosition: SpecialItemPosition.prepend,
          sortPathDelegate: SortPathDelegate.common);
      if (assets.length > 0) {
        if (assets[0].type == AssetType.image) {
          pickerConfig = AssetPickerConfig(
              maxAssets: widget.max - widget.images.length,
//              specialPickerType: SpecialPickerType.wechatMoment,
              requestType: RequestType.image,
//            allowSpecialItemWhenEmpty: true,
              specialItemBuilder: (
                BuildContext context,
                AssetPathEntity path,
                int length,
              ) {
                if (path?.isAll != true) {
                  return null;
                }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final AssetEntity result =
                        await CameraPicker.pickFromCamera(
                      context,
                      pickerConfig:
                          const CameraPickerConfig(enableRecording: true),
                    );
                    if (result == null) {
                      return;
                    }
                    final AssetPicker<AssetEntity, AssetPathEntity> picker =
                        context.findAncestorWidgetOfExactType();
                    final DefaultAssetPickerBuilderDelegate builder =
                        picker.builder as DefaultAssetPickerBuilderDelegate;
                    final DefaultAssetPickerProvider p = builder.provider;
                    await p.switchPath(p.currentPath);
                    p.selectAsset(result);
                  },
                  child: const Center(
                    child: Icon(Icons.camera_enhance, size: 42.0),
                  ),
                );
              },
              specialItemPosition: SpecialItemPosition.prepend,
              sortPathDelegate: SortPathDelegate.common);
        }
      }
      temp = await AssetPicker.pickAssets(
        context,
        pickerConfig: pickerConfig,
      );
      if (temp == null) {
        return;
      }
      print(temp);
      assets.addAll(temp);
      var i = 0;
      assets.forEach((element) {
        element.file.then((value) {
          i++;
          String uuid = Uuid().v1();
          widget.images.add(MyImage(value.path, uuid));
          if (i == assets.length) {
            if (!mounted) return;
            setState(() {});
          }
        });
      });
    } else {
      // bool isGranted = await checkPermissionCamera(context);
      // if (!isGranted) return;
      var pick = await ImagePicker().getImage(source: source);
      if (pick == null) return;
      imagePath = pick.path;
      String uuid = Uuid().v1();
//      if (Platform.isIOS) {
      pick
          .readAsBytes()
          .then((value) => ImageSave.saveImage(value, '$uuid.jpg'));
//      }
      widget.images.add(MyImage(imagePath, uuid));
      if (!mounted) return;
      setState(() {});
    }
  }

  clearAll() {
    setState(() {
      widget.images.clear();
    });
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}

class MyImage {
  String asset;
  String uuid;
  MyImage(this.asset, this.uuid);
}
