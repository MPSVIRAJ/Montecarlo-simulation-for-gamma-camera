      subroutine tuplesetup
c
c---------------------------------------------------------------------c
c
      implicit none
      include 'egs4comm.for'
c
      real egaussian(1),sgaussian_x(1),sgaussian_y(1)
      real tuptempvarx,tuptempvary
      real float_temporary,zero_float
c
c---------------------------------------------------------------------c
c
      zero_float = 0.0
      egaussian = 0.0
cnew      call norran ( egaussian)
      call rnorml ( egaussian)
c
      sgaussian_x = 0.0
cnew      call norran ( sgaussian_x)
      call rnorml ( sgaussian_x)
c
      sgaussian_y = 0.0
cnew      call norran ( sgaussian_y)
      call rnorml ( sgaussian_y)
c
      xtup3(1) = nactsx
      xtup3(2) = nevent
c
      xtup3(3)  = xin
      xtup3(4)  = yin
      xtup3(5)  = zin
      xtup3(6)  = uin
      xtup3(7)  = vin
      xtup3(8)  = win
c
      xavg=xavg/eavg
      yavg=yavg/eavg
      zavg=zavg/eavg          
c
      xtup3( 9)  =  eavg
      xtup3(10)  =  xavg
      xtup3(11)  =  yavg
      xtup3(12)  =  zavg
cnico
cc      write(outtxt,100) xavg,yavg
cnico
c
cc      xtup3(13)  =  ecountmax
cc      xtup3(14)  =  xcountmax
cc      xtup3(15)  =  ycountmax
cc      xtup3(16)  =  zcountmax
c
cc      xtup3(17)  =  efirst
cc      xtup3(18)  =  xfirst
cc      xtup3(19)  =  yfirst
cc      xtup3(20)  =  zfirst
c
      xtup3(13)  = amax1( 0.0001 , 1.*(eavg + spren * egaussian(1)))
c      float_temporary = eavg + spren * egaussian
c      if (float_temporary.ge.0.0001) then
c         xtup3(13) = float_temporary
c         write(*,'(I2,1X,f5.3)') 1,float_temporary
c      else
c         xtup3(13) = zero_float
c         xtup3(13) = float_temporary
c         write(*,'(I2,1X,f5.3)') 0,float_temporary
c      end if 
c
      if (ispres.eq.1) then
         tuptempvarx = xavg + sgaussian_x(1) * (zdetend - zavg) / 3
         tuptempvary = yavg + sgaussian_y(1) * (zdetend - zavg) / 3
         if ((tuptempvarx.ge.xdetinf).and.(tuptempvarx.le.xdetsup).and.
     a      (tuptempvary.ge.ydetinf).and.(tuptempvary.le.ydetsup)) then
                xtup3(14)  = tuptempvarx
                xtup3(15)  = tuptempvary
         else
                xtup3(14)  = xdetinf - 1.
                xtup3(15)  = ydetinf - 1.
         endif
      else
         xtup3(14)  =  xavg
         xtup3(15)  =  yavg
      endif
c
cc      xtup3(24)  = amax1( 0. , ecountmax + spren * egaussian)
c
      if (ispres.eq.1) then
         tuptempvarx = xcountmax+sgaussian_x(1)*(zdetend - zcountmax)/3
         tuptempvary = ycountmax+sgaussian_y(1)*(zdetend - zcountmax)/3
         if ((tuptempvarx.ge.xdetinf).and.(tuptempvarx.le.xdetsup).and.
     a      (tuptempvary.ge.ydetinf).and.(tuptempvary.le.ydetsup)) then
cc                xtup3(25)  = tuptempvarx
cc                xtup3(26)  = tuptempvary
         else
cc                xtup3(25)  = xdetinf - 1.
cc                xtup3(26)  = ydetinf - 1.
         endif
      else
cc         xtup3(25)  =  xcountmax
cc         xtup3(26)  =  ycountmax
      endif
c
cc      xtup3(27)  = amax1( 0. , efirst + spren * egaussian)
c
      if (ispres.eq.1) then
         tuptempvarx =  xfirst + sgaussian_x(1) * (zdetend - zfirst) / 3
         tuptempvary =  yfirst + sgaussian_y(1) * (zdetend - zfirst) / 3
         if ((tuptempvarx.ge.xdetinf).and.(tuptempvarx.le.xdetsup).and.
     a      (tuptempvary.ge.ydetinf).and.(tuptempvary.le.ydetsup)) then
cc                xtup3(28)  = tuptempvarx
cc                xtup3(29)  = tuptempvary
         else
cc                xtup3(28)  = xdetinf - 1.
cc                xtup3(29)  = ydetinf - 1.
         endif
      else
cc         xtup3(28)  =  xfirst
cc         xtup3(29)  =  yfirst
      endif
c
      xpixel=xpixel/epixel
      ypixel=ypixel/epixel
      zpixel=zpixel/epixel
c
cnew      xtup3(16)  =  epixel
cnew      xtup3(17)  =  amax1( 0. , epixel + spren * egaussian)
cnew      xtup3(18)  =  xpixel
cnew      xtup3(19)  =  ypixel
c      xtup3(34)  =  zpixel
c
cc      xtup3(34)  =  epixmax
cc      xtup3(35)  =  amax1( 0. , epixmax + spren * egaussian)
cc      xtup3(36)  =  xpixmax
cc      xtup3(37)  =  ypixmax
c      xtup3(37)  =  zpixmax          
c
cc      xtup3(38)  = xavg - (xin+uin*(zavg-zin)/win)
cc      xtup3(39)  = yavg - (yin+vin*(zavg-zin)/win)
c
cc      xtup3(40)  = multiplicity
c
cnew      call hfn  (nt_hist,xtup3)
      write(hislun,rec=ilsx) xtup3
c
      return
c
  100 FORMAT(2(F8.4,1X))
      END
c



      SUBROUTINE RNORML(DEVIAS)
C        Generator of a vector of independent Gaussian-distributed 
C        (pseudo-)random numbers, of mean zero and variance one,
C        making use of a uniform pseudo-random generator (RANMAR).
C        The algorithm for converting uniform numbers to Gaussian
C        is that of "Ratio of Uniforms with Quadratic Bounds."  The
C        method is in principle exact (apart from rounding errors),
C        and is based on the variant published by Joseph Leva in
C        ACM TOMS vol. 18(1992), page 449 for the method and 454 for
C        the Fortran algorithm (ACM No. 712).
C        It requires at least 2 and on average 2.74 uniform deviates
C        per Gaussian (normal) deviate.
C   WARNING -- The uniform generator should not produce exact zeroes,
C   since the pair (0.0, 0.5) provokes a floating point exception.
      SAVE  S, T, A, B, R1, R2
      DIMENSION U(24), DEVIAS(1)
      DATA  S, T, A, B / 0.449871, -0.386595, 0.19600, 0.25472/
      DATA  R1, R2/ 0.27597, 0.27846/
C         generate pair of uniform deviates
   50 CALL RANLUX(U)
      V = 1.7156 * (U(2) - 0.5)
      X = U(1) - S
      Y = ABS(V) - T
      Q = X**2 + Y*(A*Y - B*X)
C           accept P if inside inner ellipse
      IF (Q .LT. R1)  GO TO 100
C           reject P if outside outer ellipse
      IF (Q .GT. R2)  GO TO 50
C           reject P if outside acceptance region
      IF (V**2 .GT. -4.0 *ALOG(U(1)) *U(1)**2) GO TO 50
C           ratio of P's coordinates is normal deviate
  100 DEVIAT = V/U(1)
      DEVIAS = DEVIAT
      RETURN
      END

