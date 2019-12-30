# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import os
import shutil
import matlab.engine
from  zipfile import ZipFile
import pandas as pd
import numpy as np


name = ['PatientSize','PatientWeight','PatientBirthDate'] # dicom image param
item = ['Height','Weight','Birth'] # Excel data param
def examine(data):
    for col,row in data.iterrows(): # 行检测
        k = 0
        for i in item: # 检测 Excel 中的数据是否完整# 直接循环三次
            if row[i]!=row[i]:  # 某一个对应的item为空
                print(row['ID_Date']," 中的参数 ",i," 为空")
                target_dir ='E:\\test\\'+ row['ID_Date']
                os.chdir(target_dir)  # 进入对应目录
                files = os.listdir(os.getcwd()) # 获取文件夹的全部文件
                #print(row['ID_Date'],"------->",files)
                for f in files:
                    if 'bold' in f and f.endswith('zip'):
                        # print("function DICOM ",f)
                        #  文件夹存在
                        if os.path.exists('midTransFile'):
                            print('Folder exists')
                        else:
                            # 文件夹不存在，则创建文件夹，并且解压 一个文件放入该文件夹
                            print('Folder no exists ! ')
                            os.mkdir('midTransFile')
                            print('Folder created Successful ! ')
                        with ZipFile(f,'r') as zipObj:
                            listOfFileNames = zipObj.namelist()
                            for fileName in listOfFileNames:
                                if '.239.' in fileName or '.0239.' in fileName or fileName.endswith('IM0'):
                                    zipObj.extract(fileName,'midTransFile')
                                    break # 找到包含 。239.或者 IM0文件
                        break

                    # 进入文件夹并进行数据的读取
                os.chdir('midTransFile/')
                    # 进入目录读取  读取当前路径下第一张图片
                image = os.listdir(os.getcwd())
                image = image[0]

                eng = matlab.engine.start_matlab()
                imageInfo = eng.dicominfo(image)
                # 修改数据
                try:
                    if imageInfo[name[k]]:
                         print("获得数据",i," ",imageInfo[name[k]])
                         data.loc[data.ID_Date==row['ID_Date'],i]=imageInfo[name[k]]
                         print(data[i])
                    else:
                         print(i,"无法获取")
                # 捕获异常
                except KeyError: # 对于 缺失 关键字的映射
                    print("缺失关键字 ",i)
                k+=1
            else:
                k+=1
                        # data.loc[data.ID_Date==row['ID_Date'],i]=imageInfo[i]

#     循环三次之后，如果存在创建的文件夹则删除  待完善
#     将产生的多余文件夹删除
        if os.path.exists(('E:\\test\\'+row['ID_Date']+'\\midTransFile')):
            print('E:\\test\\'+row['ID_Date']+'\\midTransFile')
            print('Exists Folder :  !!!!  midTransFile  !!!!')
            try:
                shutil.rmtree(('E:\\test\\'+row['ID_Date']+'\\midTransFile'))
            except PermissionError:
                print('Fail to delete this Folder,because it is being used by another process')
                # print('midTransFile Folder delete successful!')

# filter data
def filter(rawData):
    rawData.duplicated(['Subject_INFO'])
    rawData = rawData.drop_duplicates(['Subject_INFO'])
    # delete redundant data for row
    # data row from 11420 to 1204, total 753 person
    print(rawData['SubjectID_Lin_new'].value_counts())
    # count the number of session for each subejct
    # ie.  10616 6 means subjectID=10616 Total session = 6
    rawData['StudyDate'] = (rawData['StudyDate']/10000)
    rawData['StudyDate'] = rawData['StudyDate'].astype('int')
    # get examine data
    rawData = rawData.replace(to_replace='[]',value=np.nan)
    # apply replace [] to nan
    rawData['PatientBirthDate'] = (rawData['PatientBirthDate']/10000)
    # get data type int for notna data
    print('---------------------u局势的发挥就是兑换积分大家是否上帝就发哈手机打开拉萨------------------------')
    rawData['PatientBirthDate'] = rawData[rawData['PatientBirthDate'].notna()]['PatientBirthDate'].astype('int')
    rawData['old'] = rawData['StudyDate']-rawData[rawData['PatientBirthDate'].notna()]['PatientBirthDate'].astype('int')
    # get old for each subejct
    # keep some key 某一个对应的item为空
    item = ['Unnamed: 0','Subject_INFO','SubjectID_Lin_new','简单补全诊断','Chinesename','PatientSex','old','StudyDate','PatientBirthDate','PatientSize','PatientWeight']
    data = rawData[item]
    # data means new data for clearing up
    # renanme columns items
    name = ['ID','ID_Date','SubjectID','Disease','Name','Sex','Old','ExamineYear','Birth','Height','Weight']
    data = np.array(data)
    data = pd.DataFrame(data,columns=name)
    # record unique SubjectID
    subjNum = data.drop_duplicates(['SubjectID'])['SubjectID']
    # 从 1 开始编码 将相同被试编入同一个编号 ，命名格式应选择维 PAT0001
    num = 0
    for i in subjNum:
        num = num + 1
        data.loc[data.SubjectID==i,'ID']=('PAT%05d'%num)
    # 将ID 转换为具有相同文件夹的名称
    data.sort_values(["ID","ID_Date"],inplace=True)
    data = pd.DataFrame(data,columns=name)
    # save new data to specific path
    data.to_excel("D:\\dev\\code\\python\\subejct_updata_info.xlsx",index=0)
    return data



def data_clean():
    # 数据过滤开始
    # load raw data from path
    print('Loading data........waiting............\n')
    rawData = pd.read_excel(r'D:\\data\\data_file_list.xlsx')
    print(filter(rawData))
    print('\n Data has finished resort\n')
    print('----------------------------------\n')

    # 数据过滤结束
    data = pd.read_excel(r'E:\\test\\test.xlsx')  # data path changeable
    name = data.columns
    print("原始属性",name)
    print("原始数据为\n",data)
    print('-----------Programming  Starting----------------\n')
    examine(data)
    print('-----------Programming  End----------------\n')
    print("修改数据为：\n",data)
    data = np.array(data)
    data = pd.DataFrame(data,columns=name)   # 考虑如何追加保存不用覆盖原始数据
    data.to_excel('E:\\test\\new.xlsx')

if __name__=='__main__':
    data_clean()
