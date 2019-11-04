
file = load('BCICIV_calib_ds1a.mat'); %读入文件 .mat格式的脑电数据
% 将Raw Data切片成多个trial文件
% 读入标签
labels = file.mrk.y;
% 读入EEG数据
Data = file.cnt;
% 采样率为 100Hz
Fs = 100;
% Event标记的时间
ev_lats = file.mrk.pos;
Data = Data';% 转换为channel * sample 
%脑电数据处理之前，将Data转换为channel*sample
% transform  EEGData=[sample,channel]  into EPO = [sample,channel,tria] 
% Fs sample rate
% data_latencise 来自mrk.p 
epoch_range=[-0.2 0.8];
wnd =round(epoch_range(1)*Fs):round(epoch_range(2)*Fs);
% 共有200个数据样本  mrk.p 表示每个样本标记的时间，latency
% wnd -20 80共计101个样本点，对200个Event 以latency为起点
% 59个通道各取101个样本点，
% channel*sample*trials
EPO = Data(:,repmat(ev_lats,length(wnd),1)+repmat(wnd',1,length(ev_lats)));
EPO = reshape(EPO,size(EPO,1),[],length(ev_lats));
EPO=double(EPO);

