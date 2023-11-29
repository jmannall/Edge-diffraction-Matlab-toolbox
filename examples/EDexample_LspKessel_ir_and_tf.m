% EDexample_LspKessel_ir_and_tf.m

mfile = mfilename('fullpath');
[infilepath,filestem] = fileparts(mfile);

[corners,planecorners] = EDmakegeo_shoebox(0.4,0.64,0.32);
corners(:,2) = corners(:,2) - 0.12;
geoinputdata = struct('corners',corners,'planecorners',planecorners);
Sinputdata = struct('coordinates',[0 0 0.0001]);
Rinputdata = struct('coordinates',[0 0 2]);
controlparameters = struct('fs',48000);
controlparameters.difforder = 3;
controlparameters.docalcir = 1;
controlparameters.savealldifforders = 1;
filehandlingparameters = struct('outputdirectory',[infilepath,filesep,'results']);
filehandlingparameters.filestem = filestem;

EDres_ir = EDmain_convex(geoinputdata,Sinputdata,Rinputdata,struct,controlparameters,filehandlingparameters);

nfft = 4096;
fvec = controlparameters.fs/nfft*[0:nfft/2-1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

controlparameters.ngauss = 24;
controlparameters.difforder = 10;
controlparameters.docalcir = 0;
controlparameters.docalctf = 1;

fvec_tf = fvec(1:100);
controlparameters.frequencies = fvec_tf;

EDres_tf = EDmain_convex(geoinputdata,Sinputdata,Rinputdata,struct,controlparameters,filehandlingparameters);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Present the results
    
ntotlength = size(EDres_ir.irdirect,1);
allirtots = zeros(ntotlength,4);
allirtots(:,1) = EDres_ir.irdirect + EDres.irgeom;
allirtots(:,2) = EDres_ir.irdiff;
allirtots(:,3) = EDres_ir.irhod{2};
allirtots(:,4) = EDres_ir.irhod{3};

cumsumirtots = cumsum(allirtots.').';

tftot = EDres_tf.tftot;

tvec = 1/controlparameters.fs*[0:ntotlength-1];

figure(1)
clf(1)
h = plot(tvec*1e3,cumsumirtots,'-');
set(h(2),'LineWidth',2);
set(h(3),'LineWidth',2);
set(h(4),'LineWidth',2);
g = get(h(1),'Parent');
set(g,'FontSize',14)
grid
g = xlabel('Time   [ms]');
set(g,'FontSize',14)
g = ylabel('Impulse response   [-]');
set(g,'FontSize',14)
axis([6 12 -0.02 0.003])
g = legend('GA','1st-order diffr.','2nd-order diffr.','3rd-order diffr.');
set(g,'FontSize',14,'Location','SouthEast')


F = fft(cumsumirtots,nfft);

figure(2)
clf(2)
h = semilogx(fvec,20*log10(abs(F(1:nfft/2,:))),fvec_tf,20*log10(abs(tftot)),'*');
for ii = 1:4
   set(h(ii),'LineWidth',2) 
end
g = get(h(1),'Parent');
set(g,'FontSize',14)
grid
g = xlabel('Frequency   [Hz]');
set(g,'FontSize',14)
g = ylabel('TF magnitude re. 1m   [dB]');
set(g,'FontSize',14)
g = legend('TF from ir: GA only','TF from ir incl. diffr.1','TF from ir incl. diffr.2','TF from ir incl. diffr.3',['FD TF: Incl. diffr.',int2str(controlparameters.difforder)]);
set(g,'FontSize',14,'Location','SouthEast')
axis([20 20000 -8 4])
