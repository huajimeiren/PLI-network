clc
clear all
load erpbuchonghou1 
load erpbuchonghou2 
load erpbuchonghou3
clearvars  -except  erpbuchonghou1 erpbuchonghou2 erpbuchonghou3
sx=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;16;17;18; ... 
    19;20;21;22;23;15;24;32;33;41;25;26;27;28; ... 
    29;30;31;34;35;36;37;38;39;40;42;43;44;45;46; ... 
    47;48;49;50;51;52;53;54;55;56;57;58;59;60];
erpbuchonghou1=erpbuchonghou1(sx,:,:);
erpbuchonghou2=erpbuchonghou2(sx,:,:);
erpbuchonghou3=erpbuchonghou3(sx,:,:);
channameCopy={[];[];[];[];[];[];[]};
className={'Prefrontal',' Frontal' ,'Temporal','Central','Postcentral','Parietal','Occipital'};
VX={'FP1','FPZ','FP2','AF3','AF4','F7','F5','F3','F1','FZ','F2', ... 
    'F4','F6','F8','FC5','FC3','FC1','FCZ','FC2','FC4','FC6','FT8','FT7','T7', ... 
    'T8','TP7','TP8','C5','C3','C1','CZ','C2','C4','C6','CP5','CP3','CP1','CPZ','CP2', ...
    'CP4','CP6','P7','P5','P3','P1','PZ','P2','P4','P6','P8','PO7','PO5','PO3', ...
    'POZ','PO4','PO6','PO8','O1','OZ','O2'}';
Class=[ones(5,1); 2*ones(16,1) ;3*ones(6,1) ;4*ones(7,1); 5*ones(7,1); 6*ones(9,1) ;7*ones(10,1)];
erp1=[mean(erpbuchonghou1(1:5,:,:),1);mean(erpbuchonghou1(6:21,:,:),1) ;mean(erpbuchonghou1(22:27,:,:),1);mean(erpbuchonghou1(28:34,:,:),1) ... 
  ; mean(erpbuchonghou1(35:41,:,:),1) ;mean(erpbuchonghou1(42:50,:,:),1) ;mean(erpbuchonghou1(51:60,:,:),1) ];
erp2=[mean(erpbuchonghou2(1:5,:,:),1);mean(erpbuchonghou2(6:21,:,:),1) ;mean(erpbuchonghou2(22:27,:,:),1);mean(erpbuchonghou2(28:34,:,:),1) ... 
  ; mean(erpbuchonghou2(35:41,:,:),1) ;mean(erpbuchonghou2(42:50,:,:),1) ;mean(erpbuchonghou2(51:60,:,:),1) ];
erp3=[mean(erpbuchonghou3(1:5,:,:),1);mean(erpbuchonghou3(6:21,:,:),1) ;mean(erpbuchonghou3(22:27,:,:),1);mean(erpbuchonghou3(28:34,:,:),1) ... 
  ; mean(erpbuchonghou3(35:41,:,:),1) ;mean(erpbuchonghou3(42:50,:,:),1) ;mean(erpbuchonghou3(51:60,:,:),1) ];
%% 脑网络
for t = 1:6
    sjphase=[];
    ttt={225:275;281:321;174:204;280:320;459:489;620:633};
%% 1
for i=1:1798
for chan=1:60
z=hilbert(squeeze(erpbuchonghou1(chan,ttt{t},i)));
xr=real(z);
xi=imag(z);
sjphase(chan,:)=atan2(xi,xr);
end
for h=1:60
    for j=1:60
      pli1(h,j,i)= abs(sum(sign(sjphase(h,:)-sjphase(j,:)))/length(ttt{t}));
    end
end
end
%% 2
sjphase=[];
for i=1:1799
for chan=1:60
z=hilbert(squeeze(erpbuchonghou2(chan,ttt{t},i)));
xr=real(z);
xi=imag(z);
sjphase(chan,:)=atan2(xi,xr);
end
for h=1:60
    for j=1:60
      pli2(h,j,i)= abs(sum(sign(sjphase(h,:)-sjphase(j,:)))/length(ttt{t}));
    end
end
end
%% 3
sjphase=[];
for i=1:1800
for chan=1:60
z=hilbert(squeeze(erpbuchonghou3(chan,ttt{t},i)));
xr=real(z);
xi=imag(z);
sjphase(chan,:)=atan2(xi,xr);
end
for h=1:60
    for j=1:60
      pli3(h,j,i)= abs(sum(sign(sjphase(h,:)-sjphase(j,:)))/length(ttt{t}));
    end
end
end
%% p
for h=1:60
    for j=1:60
        if h==j
        pvalue(h,j,1)=0;
        pvalue(h,j,2)=0;       
        else
             [p1,table,c1] = anova1([squeeze(pli1(h,j,1:1798)),squeeze(pli2(h,j,1:1798)),squeeze(pli3(h,j,1:1798))],[],'off');
             [c,m,v,nms] = multcompare(c1,'display','off');        
             pp1= num2cell(c) ;
        pp=pp1{1,6};
        pp2=pp1{2,6};
        pvalue(h,j,1)=pp;
        pvalue(h,j,2)=pp2;
        end
    end
end
%% 
addh=eye(60,60);
pvalue1=pvalue(:,:,2)+addh;
pvalue1(pvalue1>0.005)=0;
pvalue1(pvalue1<0.005&pvalue1~=0)=1;
Data=pvalue1;
figure
CC=circosChart(Data,Class,'PartName',VX,'ClassName',className);
CC=CC.draw();
CC.setLine('LineWidth',2)
CC.setPartLabel('FontName','Times New Roman','FontSize',4)
CC.setClassLabel('FontName','Times New Roman','FontSize',8)
saveas(gcf,['fig', num2str(4*(t-1)+2),'.fig']); 
pvalue2=pvalue(:,:,1)+addh;
pvalue2(pvalue2>0.005)=0;
pvalue2(pvalue2<0.005&pvalue2~=0)=1;
Data=pvalue2;
figure
CC=circosChart(Data,Class,'PartName',VX,'ClassName',className);
CC=CC.draw();
CC.setLine('LineWidth',2)
CC.setPartLabel('FontName','Times New Roman','FontSize',4)
CC.setClassLabel('FontName','Times New Roman','FontSize',8)
saveas(gcf,['fig', num2str(4*(t-1)+4),'.fig']); 
end     
pli1=[];pli2=[];pli3=[]; pvalue=[];pvalue1=[];pvalue2=[];
for t = 1:6
    sjphase=[];
    ttt={225:275;281:321;174:204;280:320;459:489;620:633};
%% 1
for i=1:1798
for chan=1:7
z=hilbert(squeeze(erp1(chan,ttt{t},i)));
xr=real(z);
xi=imag(z);
sjphase(chan,:)=atan2(xi,xr);
end
for h=1:7
    for j=1:7
      pli1(h,j,i)= abs(sum(sign(sjphase(h,:)-sjphase(j,:)))/length(ttt{t}));
    end
end
end
%% 2
sjphase=[];
for i=1:1799
for chan=1:7
z=hilbert(squeeze(erp2(chan,ttt{t},i)));
xr=real(z);
xi=imag(z);
sjphase(chan,:)=atan2(xi,xr);
end
for h=1:7
    for j=1:7
      pli2(h,j,i)= abs(sum(sign(sjphase(h,:)-sjphase(j,:)))/length(ttt{t}));
    end
end
end
%% 3
sjphase=[];
for i=1:1800
for chan=1:7
z=hilbert(squeeze(erp3(chan,ttt{t},i)));
xr=real(z);
xi=imag(z);
sjphase(chan,:)=atan2(xi,xr);
end
for h=1:7
    for j=1:7
      pli3(h,j,i)= abs(sum(sign(sjphase(h,:)-sjphase(j,:)))/length(ttt{t}));
    end
end
end
%% p
for h=1:7
    for j=1:7
        if h==j
        pvalue(h,j,1)=0;
        pvalue(h,j,2)=0;       
        else
             [p1,table,c1] = anova1([squeeze(pli1(h,j,1:1798)),squeeze(pli2(h,j,1:1798)),squeeze(pli3(h,j,1:1798))],[],'off');
             [c,m,v,nms] = multcompare(c1,'display','off');        
             pp1= num2cell(c) ;
        pp=pp1{1,6};
        pp2=pp1{2,6};
        pvalue(h,j,1)=pp;
        pvalue(h,j,2)=pp2;
        end
    end
end
%% 
addh=eye(7,7);
pvalue1=pvalue(:,:,2)+addh;
pvaluebian=-log10(pvalue1);
matrixplot(pvaluebian,'DisplayOpt','off', 'ColorBar','off','Grid','on','XVarNames',channameCopy,'YVarNames',channameCopy);
caxis([0 3])
set(gcf,'unit','centimeters','Position',[1 1 3.47 3.33 ]);
saveas(gcf,['fig', num2str(4*(t-1)+1),'.fig']);
pvalue2=pvalue(:,:,1)+addh;
pvaluebian2=-log10(pvalue2);
matrixplot(pvaluebian2,'DisplayOpt','off', 'ColorBar','off','Grid','on','XVarNames',channameCopy,'YVarNames',channameCopy);
set(gcf,'unit','centimeters','Position',[1 1 3.47 3.33 ]);
caxis([0 3])
saveas(gcf,['fig', num2str(4*(t-1)+3),'.fig']); 
end 



%% 画图
%% 第一列
for i=1:6
	%打开的fig文件酌情修改路径
    hf(i)=open(['fig', num2str(4*(i-1)+1),'.fig']);%打开fig
    fig(i)=get(hf(i), 'CurrentAxes');%获取绘制的图像
end
figure
set(gcf,'unit','centimeters','Position',[1 1 3.5 19 ]);
ha = tight_subplot(6,1,[.005 .01],[.001 .001],[.001 .001]);
for i=1:6
	%看要绘制多少行多少列酌情改变
    axes(ha(i));
    axChildren = get(fig(i),'Children');%获取绘制的图像
    caxis([0 3])
    copyobj(axChildren, gca);%复制到当前图窗里
   close(hf(i));%关掉已经复制的图像
    %下面是对图片进行设置，请酌情修改
axis off
end
%% 第二列
for i=1:6
	%打开的fig文件酌情修改路径
    hf(i)=open(['fig', num2str(4*(i-1)+2),'.fig']);%打开fig
    fig(i)=get(hf(i), 'CurrentAxes');%获取绘制的图像
end
figure
ha = tight_subplot(6,1,[.043 .043],[.043 .043],[.15 .15]);
set(gcf,'unit','centimeters','Position',[1 1 4 25 ]);
for i=1:6
	%看要绘制多少行多少列酌情改变
    axes(ha(i));
    axChildren = get(fig(i),'Children');%获取绘制的图像
    caxis([0 3])
    copyobj(axChildren, gca);%复制到当前图窗里
   close(hf(i));%关掉已经复制的图像
    %下面是对图片进行设置，请酌情修改
axis off
end
%% 第三列
for i=1:6
	%打开的fig文件酌情修改路径
    hf(i)=open(['fig', num2str(4*(i-1)+3),'.fig']);%打开fig
    fig(i)=get(hf(i), 'CurrentAxes');%获取绘制的图像
end
figure
set(gcf,'unit','centimeters','Position',[1 1 3.5 19 ]);
ha = tight_subplot(6,1,[.005 .01],[.001 .001],[.001 .001]);
for i=1:6
	%看要绘制多少行多少列酌情改变
    axes(ha(i));
    axChildren = get(fig(i),'Children');%获取绘制的图像
    caxis([0 3])
    copyobj(axChildren, gca);%复制到当前图窗里
   close(hf(i));%关掉已经复制的图像
    %下面是对图片进行设置，请酌情修改
axis off
end
%% 第四列
for i=1:6
	%打开的fig文件酌情修改路径
    hf(i)=open(['fig', num2str(4*(i-1)+4),'.fig']);%打开fig
    fig(i)=get(hf(i), 'CurrentAxes');%获取绘制的图像
end
figure
ha = tight_subplot(6,1,[.043 .043],[.043 .043],[.15 .15]);
set(gcf,'unit','centimeters','Position',[1 1 4 25 ]);
for i=1:6
	%看要绘制多少行多少列酌情改变
    axes(ha(i));
    axChildren = get(fig(i),'Children');%获取绘制的图像
    caxis([0 3])
    copyobj(axChildren, gca);%复制到当前图窗里
   close(hf(i));%关掉已经复制的图像
    %下面是对图片进行设置，请酌情修改
axis off
end
