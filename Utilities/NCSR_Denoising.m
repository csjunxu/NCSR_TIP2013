function [im_out, PSNR, SSIM ]   =  NCSR_Denoising( par )
nim           =   par.nim;
[h,  w, ch]     =   size(nim);
par.step      =   1;
par.h         =   h;
par.w         =   w;
dim           =   uint8(zeros(h, w, ch));
ori_im        =   zeros(h,w);

if  ch == 3
    n_im           =   rgb2ycbcr( uint8(nim) );
    dim(:,:,2)     =   n_im(:,:,2);
    dim(:,:,3)     =   n_im(:,:,3);
    n_im           =   double( n_im(:,:,1));
    
    if isfield(par, 'I')
        ori_im         =   rgb2ycbcr( uint8(par.I) );
        ori_im         =   double( ori_im(:,:,1));
    end
else
    n_im           =   nim;
    
    if isfield(par, 'I')
        ori_im             =   par.I;
    end
end
fprintf('PSNR of the noisy image = %f \n', csnr(n_im(1:h,1:w), ori_im, 0, 0) );

[d_im]     =   Denoising(n_im, par, ori_im);


if isfield(par,'I')
   [h, w, ch]  =  size(par.I);
   PSNR      =  csnr( d_im(1:h,1:w), ori_im, 0, 0 );
   SSIM      =  cal_ssim( d_im(1:h,1:w), ori_im, 0, 0 );
end

if ch==3
    dim(:,:,1)   =  uint8(d_im);
    im_out       =  double(ycbcr2rgb( dim ));
else
    im_out  =  d_im;
end
return;