

EEGData=EEG.data;
Data1=[(EEGData(7,:)+EEGData(8,:))./2;(EEGData(3,:)+EEGData(12,:))./2;(EEGData(1,:)+EEGData(14,:))./2;(EEGData(6,:)+EEGData(9,:))./2];
EventLoc=struct2cell(EEG.event);
length=size(EventLoc,3);
EventRange=zeros(length,2);
postSum=zeros(4,78);
RCount=0;
for i=1:length
if(strcmp(EventLoc{3,1,i},'StimulusType')) 
    RCount=RCount+1;
    if(i>1)
        if(EventLoc{1,1,i-1}==EventLoc{1,1,i})        
             ToRemove(RCount)=i-1;
             RCount=RCount+1;
             ToRemove(RCount)=i;
        else
             ToRemove(RCount)=i;
             RCount=RCount+1;
             ToRemove(RCount)=i+1;
        end
    else
        ToRemove(RCount)=i;
        RCount=RCount+1;
        ToRemove(RCount)=i+1;
    end
loc= EventLoc{1,1,i};
    if(loc>14)
EventRange(i,:)=[loc-13 loc+77];
Premean=mean(Data1(:,EventRange(i,1):loc-1),2);
PostData=Data1(:,loc:EventRange(i,2));
sz = size(PostData);
C = PostData - repmat(Premean, [1 sz(2:end)]);
postSum=C+postSum;
    end
end
end

Fs = 128;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = size(PostData,2);             % Length of signal
t = (0:L-1)*T;






Denominator=(size(ToRemove,2))/2;
AvgPostSum=postSum./Denominator; %  divided by number of tARGET events

AvgChnlPostSum=(sum(AvgPostSum,1))./4;
AVG23=(AvgPostSum(2,:)+AvgPostSum(3,:))./2;
save('test1','AvgChnlPostSum');
subplot(3,2,1); plot(1000*t(1:L),AvgPostSum(1,1:L));title('Figure 1: Avg(O1,O2)'); 
hold on
subplot(3,2,2); plot(1000*t(1:L),AvgPostSum(2,1:L));title('Figure 2: Avg(F3,F4)'); 
hold on;
subplot(3,2,3); plot(1000*t(1:L),AvgPostSum(3,1:L));title('Figure 3: Avg(AF3,AF4)'); 
hold on
subplot(3,2,4); plot(1000*t(1:L),AvgPostSum(4,1:L));title('Figure 4: Avg(P7,P8)'); 
hold on
subplot(3,2,5); plot(1000*t(1:L),AvgChnlPostSum(1,1:L));title('Figure 5: Avg of all four channels'); 
hold on
subplot(3,2,6); plot(1000*t(1:L),AVG23(1,1:L));title('Figure 6: Avg of Figure 2 and Figure 3');

% axis([0 78 -15 15]);
hold on

EventLoc(:,:,ToRemove)=[];



length=size(EventLoc,3);
EventRange=zeros(length,2);
postSum=zeros(4,78);
RCount=0;
for i=1:length
    loc= EventLoc{1,1,i};
    if(loc>14)
EventRange(i,:)=[loc-13 loc+77];
Premean=mean(Data1(:,EventRange(i,1):loc-1),2);
PostData=Data1(:,loc:EventRange(i,2));
sz = size(PostData);
C = PostData - repmat(Premean, [1 sz(2:end)]);
postSum=C+postSum;
    end
end



AvgPostSum1=postSum./length;  % Divided by number of non target events
AvgChnlPostSum1=(sum(AvgPostSum1,1))./4;
AVG231=(AvgPostSum1(2,:)+AvgPostSum1(3,:))./2;
save('test1','AvgChnlPostSum');
subplot(3,2,1); plot(1000*t(1:L),AvgPostSum1(1,1:L),'r'); 
subplot(3,2,2); plot(1000*t(1:L),AvgPostSum1(2,1:L),'r');  
subplot(3,2,3); plot(1000*t(1:L),AvgPostSum1(3,1:L),'r');
subplot(3,2,4); plot(1000*t(1:L),AvgPostSum1(4,1:L),'r');
subplot(3,2,5); plot(1000*t(1:L),AvgChnlPostSum1(1,1:L),'r');
subplot(3,2,6); plot(1000*t(1:L),AVG231(1,1:L),'r');
% axis([0 78 -15 15]);
save('T7','AvgPostSum','AvgChnlPostSum','AVG23','AvgPostSum1','AvgChnlPostSum1','AVG231');



  