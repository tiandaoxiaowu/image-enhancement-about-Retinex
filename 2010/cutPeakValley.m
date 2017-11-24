function nidata = cutPeakValley( idata , lowEndCutPercentage , highEndCutPercentage )
    prc_loend = lowEndCutPercentage; prc_hiend = 100-highEndCutPercentage;
    low_end = prctile(idata(:), prc_loend);
    high_end = prctile(idata(:), prc_hiend);
    
    nidata = (idata-low_end)/(high_end-low_end);
    nidata = min(1, nidata);
    nidata = max(0, nidata);
end