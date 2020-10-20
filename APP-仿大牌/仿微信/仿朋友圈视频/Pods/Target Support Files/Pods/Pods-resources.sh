#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

realpath() {
  DIRECTORY="$(cd "${1%/*}" && pwd)"
  FILENAME="${1##*/}"
  echo "$DIRECTORY/$FILENAME"
}

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE=$(realpath "${PODS_ROOT}/$1")
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "DFCommon/DFCommon/DFCommon/Resource/back-arrow@2x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/back-arrow@3x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/Expression.plist"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/fail@2x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/fail@3x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/refresh@2x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/refresh@3x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/success@2x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/success@3x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/ClippedExpression.bundle"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/blackArrow.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/blackArrow@2x.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/blueArrow.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/blueArrow@2x.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/grayArrow.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/grayArrow@2x.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/whiteArrow.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/whiteArrow@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/activityMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/activtyMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/EditControl.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/EditControl@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/EditControlSelected.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/EditControlSelected@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/error.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/error@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/facebookMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/facebookMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/ic_square.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/ic_square@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/left_arrow.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/left_arrow@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/mailMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/mailMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/messageMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/messageMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/pause.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/pause@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/play.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/play@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/playButton.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/playButton@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/right_arrow.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/right_arrow@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/saveMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/sliderPoint.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/sliderPoint@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/twitterMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/twitterMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/unplay.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/unplay@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/videoIcon.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/videoIcon@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/MHGallery.bundle"
  install_resource "MJPhotoBrowser/MJPhotoBrowser/MJPhotoBrowser/MJPhotoBrowser.bundle"
  install_resource "MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "DFCommon/DFCommon/DFCommon/Resource/back-arrow@2x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/back-arrow@3x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/Expression.plist"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/fail@2x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/fail@3x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/refresh@2x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/refresh@3x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/success@2x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/success@3x.png"
  install_resource "DFCommon/DFCommon/DFCommon/Resource/ClippedExpression.bundle"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/blackArrow.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/blackArrow@2x.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/blueArrow.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/blueArrow@2x.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/grayArrow.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/grayArrow@2x.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/whiteArrow.png"
  install_resource "EGOTableViewPullRefresh/EGOTableViewPullRefresh/Resources/whiteArrow@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/activityMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/activtyMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/EditControl.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/EditControl@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/EditControlSelected.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/EditControlSelected@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/error.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/error@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/facebookMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/facebookMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/ic_square.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/ic_square@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/left_arrow.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/left_arrow@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/mailMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/mailMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/messageMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/messageMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/pause.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/pause@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/play.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/play@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/playButton.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/playButton@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/right_arrow.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/right_arrow@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/saveMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/sliderPoint.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/sliderPoint@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/twitterMH.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/twitterMH@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/unplay.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/unplay@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/videoIcon.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/Images/videoIcon@2x.png"
  install_resource "MHVideoPhotoGallery/MHVideoPhotoGallery/MMHVideoPhotoGallery/MHGallery.bundle"
  install_resource "MJPhotoBrowser/MJPhotoBrowser/MJPhotoBrowser/MJPhotoBrowser.bundle"
  install_resource "MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "SVProgressHUD/SVProgressHUD/SVProgressHUD.bundle"
fi

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac

  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "`realpath $PODS_ROOT`*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
