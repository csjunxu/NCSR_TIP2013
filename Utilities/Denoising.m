function  [d_im ]    =   Denoising(n_im, par, ori_im)
[h1, w1]     =   size(ori_im);

par.tau1    =   0.1;
par.tau2    =   0.2;
par.tau3    =   0.3;
d_im        =   n_im;
lamada      =   0.02;
v           =   par.nSig;
cnt         =   1;

for k    =  1:par.K

    Dict          =   KMeans_PCA( d_im, par, par.cls_num );
    [blk_arr, wei_arr]     =   Block_matching( d_im, par);
    
    for i  =  1 : 3
        d_im    =   d_im + lamada*(n_im - d_im); %lamada=0.02
        dif     =   d_im-n_im;
        vd      =   v^2-(mean(mean(dif.^2)));
        
        if (i ==1 && k==1)
            par.nSig  = sqrt(abs(vd));            
        else
            par.nSig  = sqrt(abs(vd))*par.lamada; %par.lamada=0.26
        end
        
        [alpha, beta, Tau1]   =   Cal_Parameters( d_im, par, Dict, blk_arr, wei_arr );   
        
        d_im        =   NCSR_Shrinkage( d_im, par, alpha, beta, Tau1, Dict, 1 );

        PSNR        =   csnr( d_im(1:h1,1:w1), ori_im, 0, 0 );
        fprintf( 'Preprocessing, Iter %d : PSNR = %f,   nsig = %3.2f\n', cnt, PSNR, par.nSig );
        cnt   =  cnt + 1;
%         imwrite(d_im./255, 'Results\tmp.tif');
    end
end