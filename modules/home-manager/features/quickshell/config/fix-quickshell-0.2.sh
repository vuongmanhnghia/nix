#!/usr/bin/env bash
# Quickshell 0.2.0 Auto-Fix Script
# Chạy script này sau mỗi lần update từ repo gốc

set -e
cd "$(dirname "$0")/ii"

echo "🔧 Fixing Quickshell 0.2.0 compatibility..."

# 1. Tạo qmldir cho root
echo "module qs
singleton Translation 1.0 Translation.qml
singleton GlobalStates 1.0 GlobalStates.qml
ReloadPopup 1.0 ReloadPopup.qml" > qmldir

# 2. Tạo qmldir cho services
echo "module qs.services
singleton Ai 1.0 Ai.qml
singleton AppSearch 1.0 AppSearch.qml
singleton Audio 1.0 Audio.qml
singleton Battery 1.0 Battery.qml
singleton BluetoothStatus 1.0 BluetoothStatus.qml
singleton Booru 1.0 Booru.qml
BooruResponseData 1.0 BooruResponseData.qml
singleton Brightness 1.0 Brightness.qml
singleton Cliphist 1.0 Cliphist.qml
singleton ConflictKiller 1.0 ConflictKiller.qml
singleton DateTime 1.0 DateTime.qml
singleton EasyEffects 1.0 EasyEffects.qml
singleton Emojis 1.0 Emojis.qml
singleton FirstRunExperience 1.0 FirstRunExperience.qml
singleton HyprlandData 1.0 HyprlandData.qml
singleton HyprlandKeybinds 1.0 HyprlandKeybinds.qml
singleton HyprlandXkb 1.0 HyprlandXkb.qml
singleton Hyprsunset 1.0 Hyprsunset.qml
singleton Idle 1.0 Idle.qml
singleton KeyringStorage 1.0 KeyringStorage.qml
singleton LatexRenderer 1.0 LatexRenderer.qml
singleton MaterialThemeLoader 1.0 MaterialThemeLoader.qml
singleton MprisController 1.0 MprisController.qml
singleton Network 1.0 Network.qml
singleton Notifications 1.0 Notifications.qml
singleton ResourceUsage 1.0 ResourceUsage.qml
singleton SystemInfo 1.0 SystemInfo.qml
singleton TimerService 1.0 TimerService.qml
singleton Todo 1.0 Todo.qml
singleton Wallpapers 1.0 Wallpapers.qml
singleton Weather 1.0 Weather.qml
singleton Ydotool 1.0 Ydotool.qml" > services/qmldir

# 3. Tạo qmldir cho services subdirs
echo "module qs.services.ai
AiMessageData 1.0 AiMessageData.qml
AiModel 1.0 AiModel.qml
ApiStrategy 1.0 ApiStrategy.qml
GeminiApiStrategy 1.0 GeminiApiStrategy.qml
MistralApiStrategy 1.0 MistralApiStrategy.qml
OpenAiApiStrategy 1.0 OpenAiApiStrategy.qml" > services/ai/qmldir

echo "module qs.services.network
WifiAccessPoint 1.0 WifiAccessPoint.qml" > services/network/qmldir

# 4. Tạo qmldir cho common
echo "module qs.modules.common
singleton Appearance 1.0 Appearance.qml
singleton Config 1.0 Config.qml
singleton Directories 1.0 Directories.qml
singleton Icons 1.0 Icons.qml
singleton Images 1.0 Images.qml
singleton Persistent 1.0 Persistent.qml" > modules/common/qmldir

echo "module qs.modules.common.functions
singleton ColorUtils 1.0 ColorUtils.qml
singleton FileUtils 1.0 FileUtils.qml
singleton Fuzzy 1.0 Fuzzy.qml
singleton Levendist 1.0 Levendist.qml
singleton ObjectUtils 1.0 ObjectUtils.qml
singleton Session 1.0 Session.qml
singleton StringUtils 1.0 StringUtils.qml" > modules/common/functions/qmldir

echo "module qs.modules.common.models
AdaptedMaterialScheme 1.0 AdaptedMaterialScheme.qml
FolderListModelWithHistory 1.0 FolderListModelWithHistory.qml" > modules/common/models/qmldir

echo "module qs.modules.common.widgets
AddressBar 1.0 AddressBar.qml
AddressBreadcrumb 1.0 AddressBreadcrumb.qml
ButtonGroup 1.0 ButtonGroup.qml
CircularProgress 1.0 CircularProgress.qml
CliphistImage 1.0 CliphistImage.qml
ClippedFilledCircularProgress 1.0 ClippedFilledCircularProgress.qml
ClippedProgressBar 1.0 ClippedProgressBar.qml
ConfigRow 1.0 ConfigRow.qml
ConfigSelectionArray 1.0 ConfigSelectionArray.qml
ConfigSpinBox 1.0 ConfigSpinBox.qml
ConfigSwitch 1.0 ConfigSwitch.qml
ContentPage 1.0 ContentPage.qml
ContentSection 1.0 ContentSection.qml
ContentSubsection 1.0 ContentSubsection.qml
ContentSubsectionLabel 1.0 ContentSubsectionLabel.qml
CookieWrappedMaterialSymbol 1.0 CookieWrappedMaterialSymbol.qml
CustomIcon 1.0 CustomIcon.qml
DialogButton 1.0 DialogButton.qml
DialogListItem 1.0 DialogListItem.qml
DirectoryIcon 1.0 DirectoryIcon.qml
DragManager 1.0 DragManager.qml
FadeLoader 1.0 FadeLoader.qml
Favicon 1.0 Favicon.qml
FloatingActionButton 1.0 FloatingActionButton.qml
FlowButtonGroup 1.0 FlowButtonGroup.qml
FocusedScrollMouseArea 1.0 FocusedScrollMouseArea.qml
GroupButton 1.0 GroupButton.qml
KeyboardKey 1.0 KeyboardKey.qml
LightDarkPreferenceButton 1.0 LightDarkPreferenceButton.qml
MaterialCookie 1.0 MaterialCookie.qml
MaterialSymbol 1.0 MaterialSymbol.qml
MaterialTextArea 1.0 MaterialTextArea.qml
MaterialTextField 1.0 MaterialTextField.qml
MenuButton 1.0 MenuButton.qml
NavigationRail 1.0 NavigationRail.qml
NavigationRailButton 1.0 NavigationRailButton.qml
NavigationRailExpandButton 1.0 NavigationRailExpandButton.qml
NavigationRailTabArray 1.0 NavigationRailTabArray.qml
NoticeBox 1.0 NoticeBox.qml
NotificationActionButton 1.0 NotificationActionButton.qml
NotificationAppIcon 1.0 NotificationAppIcon.qml
NotificationGroup 1.0 NotificationGroup.qml
NotificationGroupExpandButton 1.0 NotificationGroupExpandButton.qml
NotificationItem 1.0 NotificationItem.qml
NotificationListView 1.0 NotificationListView.qml
OptionalMaterialSymbol 1.0 OptionalMaterialSymbol.qml
PointingHandInteraction 1.0 PointingHandInteraction.qml
PointingHandLinkHover 1.0 PointingHandLinkHover.qml
PopupToolTip 1.0 PopupToolTip.qml
PrimaryTabBar 1.0 PrimaryTabBar.qml
PrimaryTabButton 1.0 PrimaryTabButton.qml
Revealer 1.0 Revealer.qml
RippleButton 1.0 RippleButton.qml
RippleButtonWithIcon 1.0 RippleButtonWithIcon.qml
RoundCorner 1.0 RoundCorner.qml
ScrollEdgeFade 1.0 ScrollEdgeFade.qml
SecondaryTabButton 1.0 SecondaryTabButton.qml
SelectionDialog 1.0 SelectionDialog.qml
SelectionGroupButton 1.0 SelectionGroupButton.qml
StyledBlurEffect 1.0 StyledBlurEffect.qml
StyledFlickable 1.0 StyledFlickable.qml
StyledImage 1.0 StyledImage.qml
StyledIndeterminateProgressBar 1.0 StyledIndeterminateProgressBar.qml
StyledLabel 1.0 StyledLabel.qml
StyledListView 1.0 StyledListView.qml
StyledProgressBar 1.0 StyledProgressBar.qml
StyledRadioButton 1.0 StyledRadioButton.qml
StyledRectangularShadow 1.0 StyledRectangularShadow.qml
StyledScrollBar 1.0 StyledScrollBar.qml
StyledSlider 1.0 StyledSlider.qml
StyledSpinBox 1.0 StyledSpinBox.qml
StyledSwitch 1.0 StyledSwitch.qml
StyledText 1.0 StyledText.qml
StyledTextArea 1.0 StyledTextArea.qml
StyledTextInput 1.0 StyledTextInput.qml
StyledToolTip 1.0 StyledToolTip.qml
StyledToolTipContent 1.0 StyledToolTipContent.qml
ThumbnailImage 1.0 ThumbnailImage.qml
Toolbar 1.0 Toolbar.qml
ToolbarButton 1.0 ToolbarButton.qml
ToolbarTextField 1.0 ToolbarTextField.qml
VerticalButtonGroup 1.0 VerticalButtonGroup.qml
VibrantToolbarButton 1.0 VibrantToolbarButton.qml
WaveVisualizer 1.0 WaveVisualizer.qml
WavyLine 1.0 WavyLine.qml
WindowDialog 1.0 WindowDialog.qml
WindowDialogButtonRow 1.0 WindowDialogButtonRow.qml
WindowDialogSeparator 1.0 WindowDialogSeparator.qml
WindowDialogTitle 1.0 WindowDialogTitle.qml" > modules/common/widgets/qmldir

# 5. Tạo qmldir cho tất cả modules còn lại
for dir in modules/*/; do
  modname=$(basename "$dir")
  if [ "$modname" = "common" ]; then continue; fi
  
  echo "module qs.modules.$modname" > "$dir/qmldir"
  
  for qml in "$dir"*.qml; do
    if [ -f "$qml" ]; then
      component=$(basename "$qml" .qml)
      echo "$component 1.0 $component.qml" >> "$dir/qmldir"
    fi
  done
done

# 6. Fix IdleInhibitor trong services/Idle.qml
if [ -f "services/Idle.qml" ]; then
  # Backup nếu chưa có
  [ ! -f "services/Idle.qml.backup" ] && cp services/Idle.qml services/Idle.qml.backup
  
  # Thay thế sử dụng sed (portable)
  sed -i.tmp 's/property alias inhibit: idleInhibitor.enabled/property bool inhibit: false/' services/Idle.qml
  sed -i.tmp '/^    IdleInhibitor {/,/^    }$/s/^/    \/\/ /' services/Idle.qml
  rm -f services/Idle.qml.tmp
fi

# 7. Fix IdleInhibitor trong SidebarRightContent.qml
if [ -f "modules/sidebarRight/SidebarRightContent.qml" ]; then
  # Backup nếu chưa có
  [ ! -f "modules/sidebarRight/SidebarRightContent.qml.backup" ] && cp modules/sidebarRight/SidebarRightContent.qml modules/sidebarRight/SidebarRightContent.qml.backup
  
  # Comment out IdleInhibitor {}
  sed -i.tmp 's/^                IdleInhibitor {}/                \/\/ IdleInhibitor {} \/\/ Disabled for quickshell 0.2.0/' modules/sidebarRight/SidebarRightContent.qml
  rm -f modules/sidebarRight/SidebarRightContent.qml.tmp
fi

echo ""
echo "✅ Done! Quickshell 0.2.0 fixes applied."
echo ""
echo "📝 Files created:"
echo "   - qmldir files in all module directories"
echo ""
echo "🔧 Files modified:"
echo "   - services/Idle.qml (IdleInhibitor disabled)"
echo "   - modules/sidebarRight/SidebarRightContent.qml (IdleInhibitor disabled)"
echo ""
echo "💾 Backups saved:"
echo "   - services/Idle.qml.backup"
echo "   - modules/sidebarRight/SidebarRightContent.qml.backup"
echo ""
echo "🧪 Test with: quickshell -p ."
echo ""
