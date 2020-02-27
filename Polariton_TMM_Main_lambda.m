%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% last update 25Feb2020, lne %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code computes the anti-crossing between a cavity mode and a dipole with 
% the tranfer matrix method. It sweeps over the wavelength in order to compute
% the anti-crossing

clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lambda=(900:0.5:1000)*1e-9;

dz=10e-9;

NN=50e16*1e6;                             %% electron density [m-3]
LLambda12=[900:10:1000]*1e-9;             %% Central wavelength of the dipole

for ii =1:length(LLambda12)

N=NN(1);
lambda12=LLambda12(ii);

input_Polariton_d

clear z n nt t zz zv

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Discretisation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% here, I descretize the grid z and the optical index n

t  = layer(:,1);
nt = layer(:,2:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j=1:length(t)
  
  if j==1
    zz(1) = t(1);
    zv{1} = 0:dz:t(1); 
    z     = zv{1};
    n     = repmat((zv{j}'*0+1),[1 length(lambda)] ) .* repmat(nt(j,:),[length(zv{j}') 1]);
  else
    zz(j) = zz(end)+t(j);
    zv{j} = (zz(end-1)+dz):dz:zz(end);
    z     = [ z  zv{j} ];
    n     = [ n  ; repmat((zv{j}'*0+1),[1 length(lambda)] ) .* repmat(nt(j,:),[length(zv{j}') 1])  ];
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for l=1:length(lambda)

  [AA,BB,psi] = TMM_f(zz,zv,nt(:,l),nL,nR,lambda(l));
  
  A(:,l,ii)  = AA;
  B(:,l,ii)  = BB;
  %size(psi.')
  %PSI(:,l,i)= psi.';
  %size(psi)
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%X0fig=-3500; Y0fig=100;
X0fig=100; Y0fig=100;
Wfig=1500;Hfig=900;

figure('Name','Results','position',[X0fig Y0fig Wfig Hfig])

FS=15;
LW=2;
idx=find(abs(lambda-lambda0)==min(abs(lambda-lambda0)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii=1:length(LLambda12)

R(ii,:) = abs(B(1,:,ii)).^2;
T(ii,:) = (nR/nL) * abs(A(end,:,ii)).^2 ;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(1,1,1,'fontsize',FS)
hold on;grid on;

pcolor(lambda*1e9,(LLambda12-lambda0)*1e9,R)

colormap(jet)
shading flat
colorbar
xlabel('Wavelength (nm)')
ylabel('de-tuning (nm)')

caxis([0 1.01])
xlim([lambda(1) lambda(end)]*1e9)
ylim( ([LLambda12(1) LLambda12(end)]-lambda0)*1e9 )
title('Polariton anti-crossing')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
