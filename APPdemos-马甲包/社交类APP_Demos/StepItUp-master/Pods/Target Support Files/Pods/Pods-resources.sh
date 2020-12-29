#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

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
    *.xcassets)
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
          install_resource "MessageDisplayKit/MessageDisplayKit/Resources/AddGroupMemberBtn@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/AddGroupMemberBtnHL@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/avator@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/CellBlueSelected@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/CellGraySelected@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/CellNotSelected@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/CellRedSelected@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/contacts_add_friend@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/contacts_add_newmessage@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/contacts_add_photo@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/contacts_add_scan@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/contacts_add_voip@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/ContactsPanelDotRect@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/face@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/face_HL@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/Fav_Cell_Loc@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/input-bar-background.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/input-bar-background@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/input-bar-flat.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/input-bar-flat@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/input-field-cover.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/input-field-cover@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/keyborad@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/keyborad_HL@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/MessageVideoPlay@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/MoreFunctionFrame@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/msg_chat_voice_unread.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/msg_chat_voice_unread@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/multiMedia@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/multiMedia_HL@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/MultiSelectedPanelBkg@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/MultiSelectedPanelConfirmBtnbKG@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/placeholderImage@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/ReceiverVoiceNodePlaying000@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/ReceiverVoiceNodePlaying001@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/ReceiverVoiceNodePlaying002@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/ReceiverVoiceNodePlaying003@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/ReceiverVoiceNodePlaying@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordCancel@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingBkg@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingSignal001@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingSignal002@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingSignal003@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingSignal004@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingSignal005@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingSignal006@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingSignal007@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/RecordingSignal008@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/SearchIcon@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion0@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion10@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion11@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion12@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion13@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion14@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion15@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion1@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion2@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion3@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion4@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion5@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion6@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion7@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion8@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/section0_emotion9@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/SenderVoiceNodePlaying000@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/SenderVoiceNodePlaying001@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/SenderVoiceNodePlaying002@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/SenderVoiceNodePlaying003@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/SenderVoiceNodePlaying@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_friendcard@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_location@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_myfav@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_openapi@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_pic@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_video@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_videovoip@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_voiceinput@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_voipvoice@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/sharemore_wxtalk@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/voice@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/voice_HL@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/VoiceBtn_Black@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/VoiceBtn_BlackHL@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/weChatBubble_Receiving_Cavern@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/weChatBubble_Receiving_Solid@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/weChatBubble_Sending_Cavern@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/weChatBubble_Sending_Solid@2x.png"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/en.lproj"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/SECoreTextView.bundle"
                    install_resource "MessageDisplayKit/MessageDisplayKit/Resources/zh-Hans.lproj"
                    install_resource "Nimbus/src/overview/resources/NimbusOverviewer.bundle"
                    install_resource "Nimbus/src/photos/resources/NimbusPhotos.bundle"
                    install_resource "Nimbus/src/webcontroller/resources/NimbusWebController.bundle"
                    install_resource "XMPPFramework/Extensions/Roster/CoreDataStorage/XMPPRoster.xcdatamodel"
                    install_resource "XMPPFramework/Extensions/XEP-0045/CoreDataStorage/XMPPRoom.xcdatamodeld"
                    install_resource "XMPPFramework/Extensions/XEP-0045/CoreDataStorage/XMPPRoom.xcdatamodeld/XMPPRoom.xcdatamodel"
                    install_resource "XMPPFramework/Extensions/XEP-0045/HybridStorage/XMPPRoomHybrid.xcdatamodeld"
                    install_resource "XMPPFramework/Extensions/XEP-0045/HybridStorage/XMPPRoomHybrid.xcdatamodeld/XMPPRoomHybrid.xcdatamodel"
                    install_resource "XMPPFramework/Extensions/XEP-0054/CoreDataStorage/XMPPvCard.xcdatamodeld"
                    install_resource "XMPPFramework/Extensions/XEP-0054/CoreDataStorage/XMPPvCard.xcdatamodeld/XMPPvCard.xcdatamodel"
                    install_resource "XMPPFramework/Extensions/XEP-0115/CoreDataStorage/XMPPCapabilities.xcdatamodel"
                    install_resource "XMPPFramework/Extensions/XEP-0136/CoreDataStorage/XMPPMessageArchiving.xcdatamodeld"
                    install_resource "XMPPFramework/Extensions/XEP-0136/CoreDataStorage/XMPPMessageArchiving.xcdatamodeld/XMPPMessageArchiving.xcdatamodel"
                    install_resource "XMPPFramework/Xcode/ServerlessDemo/ServerlessDemo.xcdatamodel"
                    install_resource "${BUILT_PRODUCTS_DIR}/QBImagePicker.bundle"
          
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
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
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
