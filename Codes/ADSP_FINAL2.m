[noisesig1,Fs1]=rdsamp('nstdb/118e06',[],10000);
[noisesig2,Fs2]=rdsamp('nstdb/118e12',[],10000);
[noisesig3,Fs3]=rdsamp('nstdb/118e18',[],10000);
[noisesig4,Fs4]=rdsamp('nstdb/118e24',[],10000);
[MA,MAFs]=rdsamp('nstdb/ma',[],10000);
[BW,BWFs]=rdsamp('nstdb/bw',[],10000);
[EM,EMFs]=rdsamp('nstdb/em',[],10000);

noise = BW+EM+MA; %Total Noise

y4=snr(noisesig4(:,1),noise(:,1))
y2=snr(noisesig3(:,1),noise(:,1))
y3=snr(noisesig2(:,1),noise(:,1))
y1=snr(noisesig1(:,1),noise(:,1))