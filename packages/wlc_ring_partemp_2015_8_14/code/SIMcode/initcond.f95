!! ---------------------------------------------------------------*
      
!     
!     This subroutine sets the initial condition for a chain within
!     the capsid
!     
!     Andrew Spakowitz
!     Written 4-16-04
      
      SUBROUTINE initcond(R,U,NT,N,NP,IDUM,FRMFILE,PARA,RING)

      use mt19937, only : grnd, init_genrand, rnorm, mt, mti
      
      PARAMETER (PI=3.141593)
      
      DOUBLE PRECISION R(NT,3)  ! Bead positions
      DOUBLE PRECISION U(NT,3)  ! Tangent vectors
      INTEGER N,NP,NT           ! Number of beads
      DOUBLE PRECISION GAM       ! Equil bead separation
      DOUBLE PRECISION LBOX     ! Box edge length
      INTEGER I,J,IB            ! Index Holders
      REAL ran1                 ! Random number generator
      INTEGER FRMFILE           ! Is conformation in file?
      INTEGER INPUT             ! Is input file set?
      INTEGER RING              ! Is polymer a ring?
      DOUBLE PRECISION RMIN
      DOUBLE PRECISION R0(3)
      DOUBLE PRECISION PARA(10)
      
!     Variables in the simulation
      
      DOUBLE PRECISION KAP,EPS  ! Elastic properties
      DOUBLE PRECISION XI       ! Drag coefficients

!     Random number generator initiation

      integer IDUM
      character*8 datedum
	  character*10 timedum
	  character*5 zonedum
	  integer seedvalues(8)
      
!     Setup the choice parameters
      
      INPUT=1

!     Seed the random number generator off the computer clock

	  call date_and_time(datedum,timedum,zonedum,seedvalues)
	
! concatenate filename, time within mins, secs, millisecs to seed random number generator	

      IDUM=-seedvalues(5)*1E7-seedvalues(6)*1E5-seedvalues(7)*1E3-seedvalues(8)
	  call init_genrand(IDUM)   
      
!     Input the conformation if FRMFILE=1
      
      if(FRMFILE.EQ.1)then
         OPEN (UNIT = 5, FILE = 'initial/snap', STATUS = 'OLD')
         DO 10 I=1,N
            READ(5,*) R(I,1),R(I,2),R(I,3)
 10      CONTINUE 
         CLOSE(5)
         
      endif
      
!     Set the initial conformation to a straight chain if CHOICE=1 and RING=0
!     Set initial conformation to a circle if RING=1
      
      if(FRMFILE.EQ.0)then
         
!     Fix the initial condition
         
         if (INPUT.EQ.0) then
            LBOX=10.
			GAM=1.
         else
            GAM=PARA(4)
            LBOX=PARA(8)
         endif
         
         IB=1
         DO 20 I=1,NP
            R0(1)=grnd()*LBOX
            R0(2)=grnd()*LBOX
            R0(3)=grnd()*LBOX
            DO 30 J=1,N
		IF (RING.EQ.0) THEN
                           R(IB,1)=R0(1)
			   R(IB,2)=R0(2)+GAM*(J-N/2.-0.5)
			   R(IB,3)=R0(3)
			   U(IB,1)=0.
			   U(IB,2)=1.
			   U(IB,3)=0.			   
                ELSE
                   R(IB,1)=R0(1)+((GAM*N)/(2*PI))*Cos(J*2*PI/N)
                   R(IB,2)=R0(2)+((GAM*N)/(2*PI))*Sin(J*2*PI/N)
                   R(IB,3)=0
                   U(IB,1)=-Sin(J*2*PI/N)
                   U(IB,2)=Cos(J*2*PI/N)
                   U(IB,3)=0;
                ENDIF
              IB=IB+1
 30         CONTINUE
 20      CONTINUE
         
      endif
      
!     Create an input file if non-existent
      
!      if (INPUT.EQ.0) then
!         KAP=200.
!         EPS=50.
!         XI=1.
!         open (unit=5, file='input/input', status='new')
         
!         write(5,*) '! -----------------------------------------'
!         write(5,*) '!Input file for polymer simulation package'
!         write(5,*) 
!         write(5,*) '!-Record 1'
!         write(5,*) '! 	KAP		Compression modulus'
!         write(5,*) KAP
!         write(5,*) 
!         write(5,*) '!-Record 2'
!         write(5,*) '!	EPS		Bending modulus	'
!         write(5,*) EPS
!         write(5,*) 
!         write(5,*) '!-Record 3'
!         write(5,*) '!	XI		Drag coefficient'
!         write(5,*) XI
!         write(5,*) 
!         write(5,*) '! ----------------------------------------'         
!         close(5)
!      endif
      
      RETURN     
      END
      
!---------------------------------------------------------------*
