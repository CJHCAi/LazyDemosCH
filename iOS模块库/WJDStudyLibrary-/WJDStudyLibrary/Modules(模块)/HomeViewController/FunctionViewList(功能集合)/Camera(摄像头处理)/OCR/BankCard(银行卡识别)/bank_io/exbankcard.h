/************************************************************************\
�����׵���ʶ�Ƽ����޹�˾
CopyRight (C) 2015

File name: exbankcard.h
  Function : ���п�ʶ��ӿ��ļ�
  Author   : zjm@exocr.com
  Version  : 2015.03.1	V1.2
***************************************************************************/

#ifndef __EX_BANK_CARD_H__
#define __EX_BANK_CARD_H__

//���ļ�ʶ�����ڵ��ԺͿ���ʹ��
#ifdef __cplusplus
extern "C"
#endif
int BankCardRecoFile(const char *szImgFile, unsigned char *pbResult, int nMaxSize);

//�ӿ�
//24λɫ RGB����BGR ʶ��
#ifdef __cplusplus
extern "C"
#endif
int BankCard24(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg24, int iW, int iH, int iPitch, int iLft, int iTop, int iRgt, int iBtm);

//�ӿ�
//����32(0xargb)λ��ͼ��ת��24λ��ͼ��Androidϵͳ��
#ifdef __cplusplus
extern "C"
#endif
int BankCard32(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg32, int iW, int iH, int iPitch, int iLft, int iTop, int iRgt, int iBtm);

//�ӿ�
//����ImageFormat.NV21ֱ������ʶ�𣬲�����java���ת����������߹���Ч��, java��ת��̫����
#ifdef __cplusplus
extern "C"
#endif
int BankCardNV21(unsigned char *pbResult, int nMaxSize, unsigned char *pbY, unsigned char *pbVU, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);

//�ӿ�
//����ImageFormat.NV12ֱ������ʶ��
#ifdef __cplusplus
extern "C"
#endif
int BankCardNV12(unsigned char *pbResult, int nMaxSize, unsigned char *pbY, unsigned char *pbUV, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);

//�ӿ�
//��ȡ�Խ�����
#ifdef __cplusplus
extern "C"
#endif
float GetFocusScore(unsigned char *imgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm);


#endif //__EX_BANK_CARD_H__