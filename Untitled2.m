tic
clean = {};
calEEG = eeg_eegrej( ALLEEG(1), [1 273494;  279079 length(ALLEEG(1).data)] );
clean = clean_asr(ALLEEG(1), 15,  0.25,[],2/3,calEEG ,[-3 3], 0.5, 1);
ALLEEG(2) = clean;
toc