#!/usr/bin/env python
# encoding: utf-8

import sys
import os
import shutil
import time
import optparse
g_CurrentPath = (os.path.split(os.path.realpath(__file__)))[0];
g_supportRleaseNote = False

def main():
    usage = "usage: %prog [-i <isIphone>] [-s <isSimulator>] [-u <TeamListName>]"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-i", "--I",action="store_true",dest="IphoneBuild", help="Build Ios version, not upload to testFlight",default=None)
    parser.add_option("-s", "--S",action="store_true",dest="SimulatorBuild", help="Build Simulator version, excute simulator",default=None)
    parser.add_option("-u", "--U",action="store",type="string", dest="UpLoad",help="Upload to Fir,SH-\"Testers-SH\",SZ-\"Testers-SZ\"",default=None)
    parser.add_option("-l", "--L",action="store",type="string", dest="Short_link",help="Set custom short link",default=None)
    parser.add_option("--ur", "--UR",action="store",type="string", dest="UpLoadRlease",help="Upload to Fir,SH-\"Testers-SH\",SZ-\"Testers-SZ\"",default=None)
    parser.add_option("-t", "--T",action="store",type="string", dest="Target",help="Build Target",default="SportForum")
    (opt, args) = parser.parse_args();

    t1 = time.time()
    print "param option:%s"%opt
    strSDKVersion = "iphoneos"
    strBuildDir = "Build/Release-iphoneos"

    if opt.SimulatorBuild == True:
        strSDKVersion = "iphonesimulator"
        strBuildDir = "Build/Release-iphonesimulator"

    strCmdCD = "cd \"%s\""%(g_CurrentPath)

    #Remove Build Directory
    print "===== Remove Build Directory....======"
    strBuildDelDir = os.path.join(g_CurrentPath, "Build")
    if os.path.exists(strBuildDelDir):
        shutil.rmtree(strBuildDelDir)

    #Clean Project
    print "===== clean project....======"
    cmdClean = "xcodebuild clean -target \"%s\" -configuration Release"%(opt.Target)
    print "clean project cmd: " + cmdClean
    os.system("%s;%s" % (strCmdCD,cmdClean))

    #Build Project
    print "===== build project....======"
    cmdBuild = "xcodebuild -target \"%s\" -configuration Release CODE_SIGN_IDENTITY=\"%s\""%(opt.Target,"iPhone Developer: Zheng Jie (9747NZ7765)")
    print "build project cmd: " + cmdBuild
    os.system("%s;%s" % (strCmdCD,cmdBuild))

    #Get App Path
    bBuildSuccessfully = False;
    strAppPath = os.path.join(g_CurrentPath, strBuildDir)
    print "App path is: " + strAppPath
    for item in os.listdir(strAppPath):
        if item.endswith(".app"):
            bBuildSuccessfully = True;
            strAppPath = os.path.join(strAppPath,item);
            break;

    if bBuildSuccessfully:
        print "Build Successfully!"
        #If current mode is simulatorbuild, excute simulator
        if opt.SimulatorBuild == True:
            print "===== excute simulator....======"
            cmdSimulatorExcute = "./iphonesim launch \"%s\""%(strAppPath)
            print "excute simulator cmd: " + cmdSimulatorExcute
            os.system("%s;%s" % (strCmdCD,cmdSimulatorExcute))
        if opt.UpLoad or opt.UpLoadRlease:
            #Generate ipa file
            strIpaPath = os.path.join(g_CurrentPath, "RleaseIpa")
            if not os.path.exists(strIpaPath):
                  os.mkdir(strIpaPath)

            if opt.UpLoadRlease:
                global g_supportRleaseNote
                g_supportRleaseNote = True

            strIpaName = "%s_%s.ipa"%(os.path.basename(strAppPath).split(".")[0], update_build_time())
            strIpaPath = os.path.join(strIpaPath, strIpaName)
            if generateIpaFile(strAppPath, strIpaPath):
                strTeamToken = "26f9e120be5711e48eb14a8892d5563e45d895c3"

                if opt.UpLoad == "SH":
                    strTeamToken = "26f9e120be5711e48eb14a8892d5563e45d895c3";
                    print "upload to FIR Account li1025yuan@126.com";

                if opt.UpLoad == "SZ":
                    strTeamToken = "39e90c41c0b711e48bcb68d14bb381704c149057";
                    print "upload to FIR Account yuan.li2@tcl.com";

                if strTeamToken:
                    strShortLink = ""

                    if opt.Short_link:
                        strShortLink = opt.Short_link

                    upLoadIpaFileToTestFlight(strIpaPath,strTeamToken,strShortLink)
                else:
                    print "Team List is empty, not to suppot uploading!";

        t2 = time.time()
        sec_all = (int)(t2-t1)
        print "Total:","%s:%s"%(sec_all/60, sec_all%60)
        print "Finish!"
    else:
        print "Build Error!"

def generateIpaFile(strAppPath,strIpaFilePath):
    print "===== generate ipa file....======"
    print "AppPath is: %s"%(strAppPath)
    print "IpaPath is: %s"%(strIpaFilePath)
    cmdIpaGenerate = "xcrun -sdk iphoneos PackageApplication -v \"%s\" -o \"%s\" --sign \"%s\""%(strAppPath, strIpaFilePath, "iPhone Developer: Zheng Jie (9747NZ7765)")
    print "generate ipa file cmd: " + cmdIpaGenerate
    os.system(cmdIpaGenerate)

    if os.path.exists(strIpaFilePath):
        print "generate ipa file Successfully!!!"
        return True
    else:
        print "generate ipa file Error!!!"
        return False

#General Ios Release Note
def generalIosReleaseNote():
    print "=====generalIosReleaseNote====="
    strReleaseNote = "Just another test version, upload time is %s."%update_build_time()

    strReleaseNotePath = os.path.join(g_CurrentPath, 'ReleaseNote.txt')
    if not os.path.exists(strReleaseNotePath) or (not g_supportRleaseNote):
        print "ReleaseNote.txt file is not exists or not to support releaseNote, path is %s." % strReleaseNotePath
        return strReleaseNote

    fp = open(strReleaseNotePath, "rb")
    fileContent = str(fp.read())
    fp.close()

    #Get ReleaseNote from ReleaseNote.txt file
    nBegin = fileContent.find("_latest_releasenote_begin_<<<")
    nEnd = fileContent.find(">>>_latest_releasenote_end")
    
    if nBegin != -1 and nEnd != -1:
        nSubStrBegin = nBegin + len("_latest_releasenote_begin_<<<")
        nLength = nEnd - nBegin - len("_latest_releasenote_begin_<<<") - 1
        strReleaseNote = fileContent[nSubStrBegin : nSubStrBegin + nLength]
        strReleaseNote = strReleaseNote.replace("__build__time__", update_build_time())
        print "ReleaseNote is %s" % strReleaseNote
        return strReleaseNote

def upLoadIpaFileToTestFlight(strIpaFilePath, strTeamToken, strShortLink):
    print "===== upload ipa file to fir....======"
    ##strNote = "Just another test version, upload time is %s!"%update_build_time()
    strNote = generalIosReleaseNote()
    print "IpaPath is: %s"%(strIpaFilePath)
    #cmdIpaUpload = "curl \"http://testflightapp.com/api/builds.json\" -F file=@\"%s\" -F api_token=\"%s\" -F team_token=\"%s\" -F notes=\"%s\" -F notify=\"%s\" -F distribution_lists=\"%s\" -F replace=\"%s\""%(strIpaFilePath,"77aa9d7f926c880eaaad46f110299df5_ODMyMTQ3MjAxMy0wMS0xNyAwMDo1Njo1OS4xNTUyODE","0c7ee54abd327c54c633c41b472337de_MTc2MjEyMjAxMy0wMS0xNyAwMToxNzowMS40MjUwNzU", strNote, "True", strTeamList, "False")
    
    cmdIpaUpload = "fir publish \"%s\" -T \"%s\" -c \"%s\""%(strIpaFilePath, strTeamToken, strNote)

    if len(strShortLink) > 0:
        cmdIpaUpload = "fir publish \"%s\" -T \"%s\" -c \"%s\" -s \"%s\""%(strIpaFilePath, strTeamToken, strNote, strShortLink)
    
    print "upload ipa file cmd: " + cmdIpaUpload
    os.system(cmdIpaUpload)

#Get Current Build Time
def update_build_time():
    sTime = time.localtime()
    version = "%04d-%02d-%02d-%02d-%02d-%02d"%(sTime.tm_year, sTime.tm_mon, sTime.tm_mday, sTime.tm_hour,sTime.tm_min,sTime.tm_sec)
    return version

if __name__ == '__main__':
    main()

