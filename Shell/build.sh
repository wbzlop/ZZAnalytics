#！/bin/bash
echo ***AnalyticsSDK开始打包***
export version="1.0.0"

#修改XZZStrategySDK.podspec 的版本号
sed -ig 's/s.version.*=.*/s.version='"\'$version\'"'/' AnalyticsSDK.podspec

#获取当前脚本的路径
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
echo "打包AnalyticsSDK的脚本路径${SHELL_FOLDER}"

#移除存在的framework
rm -rf ${SHELL_FOLDER}/AnalyticsSDK-*

#开始打包
pod package AnalyticsSDK.podspec
#pod package LFAdSDK.podspec --dynamic

echo ***打包成功***

export frameworkPath=$(find ${SHELL_FOLDER}/AnalyticsSDK-${version} -name *.framework)

#移除framework中快捷文件,避免导出的SDK包过大
rm -rf ${frameworkPath}/Headers
rm -rf ${frameworkPath}/AnalyticsSDK
cp -a ${frameworkPath}/Versions/A/Headers  ${frameworkPath}/Headers
cp -a ${frameworkPath}/Versions/A/AnalyticsSDK  ${frameworkPath}/AnalyticsSDK
rm -rf ${frameworkPath}/Versions
rm -rf ${frameworkPath}/Modules


mv 
#移除ZZAdSDKMraid.podspecg文件
rm -rf ${SHELL_FOLDER}/AnalyticsSDK.podspecg

echo 最新包路径: ${frameworkPath}

export SDKReleasePath=${SHELL_FOLDER}/ESDKRelease
export SDKDemoLibPath=${SDKReleasePath}/ESDKFrameworkTest/lib

echo ***拷贝文件到发布文件夹中***
rm -rf ${SDKReleasePath}/AnalyticsSDK.framework
cp -a ${frameworkPath} ${SDKReleasePath}/AnalyticsSDK.framework

echo ***开始拷贝最新SDK包到发布文件夹Demo工程中待用***
if [ ! -d $SDKDemoLibPath ]; then

echo 找不到Demo工程的lib路径，终止拷贝;
exit;

else
#更新SDK发布包中的SDK包
rm -rf ${SDKDemoLibPath}/AnalyticsSDK.framework
cp -a ${frameworkPath} ${SDKDemoLibPath}/AnalyticsSDK.framework

echo ***拷贝最新SDK到Demo中成功了***
fi

echo ***移除原始的framework***
rm -rf ${SHELL_FOLDER}/AnalyticsSDK-*
