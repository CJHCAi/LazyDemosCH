//
//  BMKVersion.h
//  BMapKit
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


/*****������־��*****
 V0.1.0�� ���԰�
 ֧�ֵ�ͼ�������������
 ֧��POI����
 ֧��·������
 ֧�ֵ�����빦��
 --------------------
 V1.0.0����ʽ������
 ��ͼ�������������㴥��������
 ��ע��������
 POI��·������
 ������롢���������
 ��λͼ��
 --------------------
 V1.1.0��
 ���ߵ�ͼ֧��
 --------------------
 V1.1.1��
 ����suggestionSearch�ӿ�
 ���Զ�̬����annotation title
 fixС�ڴ�й¶����
 --------------------
 V1.2.1��
 ����busLineSearch�ӿ�
 �޸���λȦ��Χ�ڲ����϶���ͼ��bug
*********************/

/**
 *��ȡ��ǰ��ͼAPI�İ汾��
 *return  ���ص�ǰAPI�İ汾��
 */
UIKIT_STATIC_INLINE NSString* BMKGetMapApiVersion()
{
	return @"1.2.2";
}
