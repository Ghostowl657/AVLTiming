%%% analysis of data %%%
aveTime = mean(runTime,3);
diffChord = diff(aveTime,1,1);
diffSpan = diff(aveTime,1,2);

aveData = mean(data,3);
diffAlphaChord = diff(aveData(:,:,1,1),1);
diffcLChord = diff(aveData(:,:,1,2),1);
diffcDChord = diff(aveData(:,:,1,3),1);
diffcL1Chord = diff(aveData(:,:,1,4),1);
diffCmaChord = diff(aveData(:,:,1,5),1);
diffCnbChord = diff(aveData(:,:,1,6),1);
diffClpChord = diff(aveData(:,:,1,7),1);

diffAlphaSpan = diff(aveData(:,:,1,1),2);
diffcLSpan = diff(aveData(:,:,1,2),2);
diffcDSpan = diff(aveData(:,:,1,3),2);
diffcL1Span = diff(aveData(:,:,1,4),2);
diffCmaSpan = diff(aveData(:,:,1,5),2);
diffCnbSpan = diff(aveData(:,:,1,6),2);
diffClpSpan = diff(aveData(:,:,1,7),2);