%----------------------------------------------------------------------
% Weisheng Dong, Lei Zhang, Guangming Shi, and Xin Li.,"Nonlocally
% centralized sparse representation for image restoration", IEEE Trans. on
% Image Processing, vol. 22, no. 4, pp. 1620-1630, Apr. 2013.
%--------------------------------------------------------------------------
clear;
addpath 'Utilities';
Original_image_dir    =    'Data\Denoising_test_images';
fpath         =   fullfile(Original_image_dir, '*.png');
im_dir        =   dir(fpath);
im_num        =   length(im_dir);


for nSig     =   [60 80 100]
    ALLPSNR = [];
    ALLSSIM = [];
    for i = 1:im_num
        par              =    Parameters_setting( nSig );
        par.I        =   double( imread(fullfile(Original_image_dir, im_dir(i).name)) );
        randn('seed',0);
        par.nim          =    par.I + nSig*randn(size( par.I ));
        tic
        [im, PSNR, SSIM]   =    NCSR_Denoising( par );
        toc
        ALLPSNR = [ALLPSNR PSNR];
        ALLSSIM = [ALLSSIM SSIM];
        imname = sprintf('NCSR_nSig%d_%s',nSig,im_dir(i).name);
        imwrite(im./255, imname);
        fprintf('%s: PSNR = %3.2f  SSIM = %f\n', im_dir(i).name, PSNR, SSIM);
    end
    meanPSNR=mean(ALLPSNR);
    meanSSIM=mean(ALLSSIM);
    name = sprintf('NCSR_nSig%d.mat',nSig);
    save(name,'meanPSNR','ALLPSNR','meanSSIM','ALLSSIM','nSig');
end

