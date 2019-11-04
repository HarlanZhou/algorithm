
file = load('BCICIV_calib_ds1a.mat'); %�����ļ� .mat��ʽ���Ե�����
% ��Raw Data��Ƭ�ɶ��trial�ļ�
% �����ǩ
labels = file.mrk.y;
% ����EEG����
Data = file.cnt;
% ������Ϊ 100Hz
Fs = 100;
% Event��ǵ�ʱ��
ev_lats = file.mrk.pos;
Data = Data';% ת��Ϊchannel * sample 
%�Ե����ݴ���֮ǰ����Dataת��Ϊchannel*sample
% transform  EEGData=[sample,channel]  into EPO = [sample,channel,tria] 
% Fs sample rate
% data_latencise ����mrk.p 
epoch_range=[-0.2 0.8];
wnd =round(epoch_range(1)*Fs):round(epoch_range(2)*Fs);
% ����200����������  mrk.p ��ʾÿ��������ǵ�ʱ�䣬latency
% wnd -20 80����101�������㣬��200��Event ��latencyΪ���
% 59��ͨ����ȡ101�������㣬
% channel*sample*trials
EPO = Data(:,repmat(ev_lats,length(wnd),1)+repmat(wnd',1,length(ev_lats)));
EPO = reshape(EPO,size(EPO,1),[],length(ev_lats));
EPO=double(EPO);

