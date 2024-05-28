      subroutine histin
c
c-----------------------------------------------------------c
c
      implicit none
      include 'egs4comm.for'
c
      character*80 title, indstring, tuple_title
      integer k_loop, id_seq, lpage, nchan_x, nchan_y, kt
      real x_min, x_max, y_min, y_max, valmax
c
      data tuple_title / ' SLAB DETECTOR TUPLE 20  '/
      data k_loop, nchan_x, nchan_y / 0 , 0 , 0 /
      data x_min, x_max, y_min, y_max, valmax / 5 * 0.0 /
      data id_seq, k_loop, lpage / 0 , 0 , 60 /
c
cnico 
cc      open(unit=outtxt,file='out_txt',form='formatted',status='new')
cc      write(outtxt,*) 'x	y' 
cnico 

c-------------------------------------------------------c
c         set parameter for hbook package --------------c
c
cnew      call hlimit( maxmem )
c
cnew      open (22, file='output_histin')
c
cnew      call houtpu( 22 )
cnew      call hermes( 22 )
c
cnew      call hpagsz( lpage  )
c
c----------------------------------------------------------
c
c
      write(*,50)
c
c----------------------------------------------------------------------c
c
cnew      open( unit=ltyfil,file='xtest.hist'
cnew     a,         form='formatted',status='old'     )
c
c----------------------------------------------------------------------c
c
cnew      write(*,*) 'opening histograms file',
cnew     a                           hislun,histofilename
c
c-----------------------------------------------------------
      open(unit=hislun,file=histofilename,
     a   form='unformatted',recl=(4*15),access='direct',status='new')
cnew     a   form='unformatted',recl=1024,access='direct',status='new')
c
cnew      call hropen(hislun,'x_ray',histofilename,'N',1024,istat)
cnew      call hropen(hislun,'x_ray',histofilename,'N',1024,istat)
cnew      call hcdir (xray_memdir,'r')
cnew      write ( * , 90) istat,xray_memdir
c
      k_loop=0
c
cnew   10 read(ltyfil,110,err=30,end=40) id_seq,nchan_x,x_min,x_max,
cnew    +                                  nchan_y,y_min,y_max,valmax
c
cnew      if(id_seq.gt.0.and.k_loop.lt.20) then
cnew         k_loop=k_loop+1
cnew         read(ltyfil,150,err=30,end=40) title
cnew         read(ltyfil,150,err=30,end=40) indstring
cnew         call hbook1(id_seq,title,nchan_x,x_min,x_max,valmax)
cnew         id_hist(k_loop)=id_seq
cnew         write(*,*) id_seq,nchan_x,x_min,x_max
cnew     *,                           nchan_y,y_min,y_max,valmax
cnew         write(*,*) title
cnew         write(*,*) indstring
cnew         goto 10
cnew      endif
c
      histo_count = k_loop
      k_loop = 0
c
cnew   20 read(ltyfil,110,err=30,end=40) id_seq,nchan_x,x_min,x_max,
cnew     +                                 nchan_y,y_min,y_max,valmax
c
cnew      if(id_seq.gt.0.and.k_loop.lt.20) then
c
cnew         k_loop=k_loop+1
cnew         read(ltyfil,150,err=30,end=40) title
cnew         read(ltyfil,150,err=30,end=40) indstring
cnew         call hbook2(id_seq,title,nchan_x,x_min,x_max
cnew    a,                             nchan_y,y_min,y_max,valmax)
cnew         write(*,*) id_seq,nchan_x,x_min,x_max
cnew     a,                     nchan_y,y_min,y_max,valmax
cnew         write(*,*) title
cnew         write(*,*) indstring
cnew         bd_hist(k_loop)=id_seq
cnew         goto 20
cnew      endif
      plot_count = k_loop
c
c---------
c
      write(*,130) nt_hist,size_of_ntup,num_of_ntup, (kt,
     +   nt_tags (kt),kt=1,size_of_ntup)
c
cnew      call hbookn(nt_hist,tuple_title,size_of_ntup
cnew     a,  xray_memdir,num_of_ntup,nt_tags )
c
c---------------------------------------------------c
 
c
      write(*,60)
c
cnew      close(ltyfil)
c
c-------------------------------------------------------c
c
      return
c
c-----  error section  ---------------------------------c
c
   30 write(*,70)
cnew      close(ltyfil)
      return
c
   40 write(*,80)
cnew      close(ltyfil)
      return
c
c------------------------------------------------------------------c
c 
   50 FORMAT(1X,'   ENTERING HISTIN  ')
   60 FORMAT(1X,'   END OF HISTIN  ')
   70 FORMAT(1H ,' ERROR IN READING FILE LTYFIL ',//)
   80 FORMAT(1H ,' EOF IN READING FILE LTYFIL ',// )
   90 FORMAT(1X,'STATUS',I10,2X,'X RAY DIRECTORY ' , A64)
  100 FORMAT(I5,I5,2F10.0,10X,20X,F10.0)
  110 FORMAT(I10,I10,2F10.0,I10,2F10.0,F10.0)
  130 FORMAT(1X , ' NTUPLE ID ',I8,' SIZE OF NTUP ' ,I8, ' NUM OF NTUP '
     +, I8 , /,' TUPLE TAG ' , (1H ,I4,2X,A10) )
  150 FORMAT(A80)
c
c
  180 FORMAT(A80)
  120 FORMAT(3I10)
  140 FORMAT(80A1)
  160 FORMAT(25I2)
  170 FORMAT( 1H , ' IAUSFL( ' , I3 , ' ) ' , 2X,I3)
c
      END
c
c------------------------------------------------------------------c
c
      subroutine histout
c
      implicit none
      include 'egs4comm.for'
      integer k_loop
c
      write(*,*) ' entering histout '
cnew      call histdo
c
      do 10 k_loop = 1, histo_count
cnew         call hrout(id_hist(k_loop),id_cycle(k_loop), ' ')
c         write(*,*)' mono',id_hist(k_loop)
   10 continue
c
      do 20 k_loop=1,plot_count
cnew         call hrout(bd_hist(k_loop),bd_cycle(k_loop), ' ')
c         write(*,*)' bidi',bd_hist(k_loop)
   20 continue
c
cnew      call hcdir (xray_memdir,'r')
      write ( * , 30) istat,xray_memdir
c
cnew      call hrout ( 0,nt_cycle,'T')
      write( * ,*)' TUPLE ',nt_hist,nt_ident,nt_cycle
c
cnew      call hldir(xray_memdir,'t')
cnew      call hrend(xray_memdir)
c
      close( hislun )
      write(*,*) ' HISTO FILE CLOSED '
cc      close (outtxt)
      return
c
   30 FORMAT(1X,'STATUS',I10,2X,'X RAY DIRECTORY ' , A64)
      end
c
