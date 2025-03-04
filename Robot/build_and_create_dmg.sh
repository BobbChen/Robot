#!/bin/bash

# 设置应用名称
APP_NAME="Robot"
# 清理缓存
echo "🚀 正在清理构建缓存"
flutter clean

echo

echo "🚀 重新下载依赖..."
flutter pub get

echo

# Flutter 构建 macOS 应用
echo "🚀 正在构建 macOS 应用..."
flutter build macos

# 检查构建是否成功
if [ ! -d "build/macos/Build/Products/Release/$APP_NAME.app" ]; then
    echo "❌ 构建失败，未找到 $APP_NAME.app！请检查 Flutter 项目。"
    exit 1
fi
echo "✅ 构建成功！"

# 获取屏幕分辨率
SCREEN_WIDTH=$(system_profiler SPDisplaysDataType | awk '/Resolution/{print $2}')
SCREEN_HEIGHT=$(system_profiler SPDisplaysDataType | awk '/Resolution/{print $4}')

# 设定 DMG 窗口大小
DMG_WIDTH=800
DMG_HEIGHT=600

# 计算窗口居中坐标
WINDOW_POS_X=$(( (SCREEN_WIDTH - DMG_WIDTH) / 2 ))
WINDOW_POS_Y=$(( (SCREEN_HEIGHT - DMG_HEIGHT) / 2 ))

# 设置路径
APP_PATH="build/macos/Build/Products/Release/$APP_NAME.app"
DMG_PATH="build/macos/Build/Products/Release/$APP_NAME.dmg"

# 运行 create-dmg
echo "📦 正在创建 DMG 文件..."
create-dmg \
  --window-pos $WINDOW_POS_X $WINDOW_POS_Y \
  --window-size $DMG_WIDTH $DMG_HEIGHT \
  --icon "$APP_NAME" 200 300 \
  --app-drop-link 600 300 \
  $DMG_PATH \
  $APP_PATH

# 检查 DMG 是否成功创建
if [ -f "$DMG_PATH" ]; then
    echo "🎉 DMG 创建成功！文件路径：$DMG_PATH"
else
    echo "❌ DMG 创建失败！"
    exit 1
fi

