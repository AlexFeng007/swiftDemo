#Author zhangbin

CURRENT_PATH="$(pwd)"

#生成的APP名称
APPNAME=$(basename ${CURRENT_PATH}/*.app .app)
echo "app name is ${APPNAME}"

if [[ $APPNAME = "*" ]];then
  echo "请放入需要破解的app"
  exit 1
fi

#输出ipa文件的路径
OUTDIR="${CURRENT_PATH}/output"

#payload路径
PAYLOAD="${OUTDIR}/Payload"

#init
rm -rf ${OUTDIR}
mkdir -p ${PAYLOAD}
mv ${APPNAME}.app ${PAYLOAD}/${APPNAME}.app


#Framework dir
FrameworkDir="${OUTDIR}/Payload/${APPNAME}.app/Frameworks"



#蒲公英apiKey 正式(e53c597558485ab1b1ba73dd8bfbf341) other(76736be78d4f78c705a2268cf2456371) 线上（578af0c0beb67c46214fcddbd47d567c）
PAPIKEY="e53c597558485ab1b1ba73dd8bfbf341"
#蒲公英uKey 正式(943a103e759017ecca7b81f1c144ca07) other(23e20856e2312b07cff7afb6a6363426) 线上(f54aca38f2e137b80616e3c25225b350)
PUKEY="943a103e759017ecca7b81f1c144ca07"

#替换的provision
provision_name="yycInhouseProfile.mobileprovision"
FKYWidget_name="yycInhousewidgetProfile.mobileprovision"

rule_path="ResourceRules.plist"

#替换的ce
distribution_name="iPhone Distribution: Yao Fang Information Technology (Shanghai) Co., Ltd."

#-----------resign-------------
cd ${OUTDIR}
mkdir -p ${PAYLOAD}
mv ${APPNAME}.app ${PAYLOAD}/${APPNAME}.app

rm -rf ./Payload/${APPNAME}.app/PlugIns/FKYWidget.appex/_CodeSignature
rm -rf ./Payload/${APPNAME}.app/PlugIns/NotificationService.appex/_CodeSignature
rm -rf ./Payload/${APPNAME}.app/_CodeSignature
#change provision
cp ${CURRENT_PATH}/$provision_name ./Payload/${APPNAME}.app/embedded.mobileprovision
cp ${CURRENT_PATH}/$FKYWidget_name ./Payload/${APPNAME}.app/PlugIns/FKYWidget.appex/embedded.mobileprovision
cp ${CURRENT_PATH}/$provision_name ./Payload/${APPNAME}.app/PlugIns/NotificationService.appex/embedded.mobileprovision
#make rulepath
cp ${CURRENT_PATH}/$rule_path ./Payload/${APPNAME}.app/PlugIns/FKYWidget.appex/$rule_path
cp ${CURRENT_PATH}/$rule_path ./Payload/${APPNAME}.app/PlugIns/NotificationService.appex/$rule_path
cp ${CURRENT_PATH}/$rule_path ./Payload/${APPNAME}.app/$rule_path

/usr/libexec/PlistBuddy -x -c "print :Entitlements " /dev/stdin <<< $(security cms -D -i Payload/*.app/PlugIns/FKYWidget.appex/embedded.mobileprovision) > entitlements.plist
/usr/libexec/PlistBuddy -x -c "print :Entitlements " /dev/stdin <<< $(security cms -D -i Payload/*.app/PlugIns/NotificationService.appex/embedded.mobileprovision) > entitlements.plist
/usr/libexec/PlistBuddy -x -c "print :Entitlements " /dev/stdin <<< $(security cms -D -i Payload/*.app/embedded.mobileprovision) > entitlements.plist

#codesign framework
for file in $(ls ${FrameworkDir})
    do
        /usr/bin/codesign -f -s "$distribution_name" --entitlements entitlements.plist ${FrameworkDir}/${file}
    done
  #codesign app


/usr/bin/codesign -f -s "$distribution_name" --resource-rules ./Payload/${APPNAME}.app/PlugIns/FKYWidget.appex/ResourceRules.plist --entitlements entitlements.plist ./Payload/${APPNAME}.app/PlugIns/FKYWidget.appex
/usr/bin/codesign -f -s "$distribution_name" --resource-rules ./Payload/${APPNAME}.app/PlugIns/NotificationService.appex/ResourceRules.plist --entitlements entitlements.plist ./Payload/${APPNAME}.app/PlugIns/NotificationService.appex
/usr/bin/codesign -f -s "$distribution_name" --resource-rules ./Payload/${APPNAME}.app/ResourceRules.plist --entitlements entitlements.plist ./Payload/${APPNAME}.app

zip -qr New_${APPNAME}.ipa Payload

echo "resign done"


#-----------update 蒲公英-------------
echo "curl -F file=@${OUTDIR}/New_${APPNAME}.ipa -F uKey=${PUKEY} -F _api_key=${PAPIKEY} http://www.pgyer.com/apiv1/app/upload"
curl -F "file=@${OUTDIR}/New_${APPNAME}.ipa" -F "uKey=${PUKEY}" -F "_api_key=${PAPIKEY}" "http://www.pgyer.com/apiv1/app/upload"
echo "上传完成\n\n"

cd ${CURRENT_PATH}

#--------------------end--------------





