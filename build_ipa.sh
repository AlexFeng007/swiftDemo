#!/bin/bash
#
# 类型
type=$1

DATE=$(date +%m%d_%H%M)
IFS=$'\n'
workspaceExt=".xcworkspace"
tempPath=""

#工程绝对路径
#cd $1
project_path=$(pwd)
#build文件夹路径
build_path=${project_path}/build

#工程配置文件路径
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
project_infoplist_path=${project_path}/${project_name}/"Supporting Files"/Info.plist
echo $project_infoplist_path
#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${project_infoplist_path})
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${project_infoplist_path})
#取bundle Identifier前缀
bundlePrefix=$(/usr/libexec/PlistBuddy -c "print CFBundleIdentifier" `find . -name "*-Info.plist"` | awk -F$ '{print $1}')

echo "version"$bundleShortVersion
cd $project_path
echo "***clean  start**"

#删除bulid目录
if  [ -d ${build_path} ];then
rm -rf ${build_path}

echo "***clean build_path success***"
fi

cd ${project_path}
mkdir -p ${project_path}/build

#去掉xcode源码末尾的空格
#find . -name "*.[hm]" | xargs sed -Ee 's/ +$//g' -i ""


#find .xcworkspace
for workspacePath in `find ${project_path} -name "$project_name$workspaceExt" -print`
do
tempPath=${workspacePath}
break
done

final_name=$project_name"_v"$bundleShortVersion"_"$DATE"_"$type

xcodebuild \
-workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${project_name} \
-configuration Debug \
clean \
build \
-derivedDataPath ${project_path}/build

if [[ -e  ${project_path}/build ]]; then
    echo "xcodebuild success"
else
    echo "xcodebuild failed"
    #statements
fi

#xcrun -sdk iphoneos PackageApplication \
#        -v ${project_path}/build/Build/Products/Debug-iphoneos/${project_name}.app \
#        -o ${project_path}/build/${final_name}.ipa


xcodebuild -scheme ${project_name} archive \
-archivePath ${project_path}/build/${project_name}.xcarchive

xcodebuild -exportArchive -exportFormat ipa \
-archivePath "${project_path}/build/${project_name}.xcarchive" \
-exportPath "${project_path}/build/${project_name}.ipa" \
-exportProvisioningProfile "7.7测试文件"

#xcodebuild -exportArchive \
#        -exportFormat IPA \
#        -archivePath "${project_path}/${project_name}.xcarchive"  \
#        -exportPath "${build_path}/${project_name}.ipa"

xcodebuild -exportArchive -archivePath $PWD/build/myApp.xcarchive -exportOptionsPlist exportOptions.plist -exportPath $PWD/build

if [[ -e ${project_path}/build/${final_name} ]]; then
    echo "Build ipa success"
    open ${project_path}/build/
else
    echo "Build ipa failed"
    #statements
fi

# #打开ipa所在的文件夹
open ${project_path}/build/

#'Guangdong Yihao Pharmaceutical Co., Ltd.'

done


