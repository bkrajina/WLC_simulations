from numpy import *

file='ex.equildistrib.out'
L=3.0
data=loadtxt(file)
R2s=[]
DRs=[]
for i in range(len(data[:,0])):
    dr=data[i,0:3]
    R2=sum(dr**2.)
    R2s.append(R2)
    DRs.append(linalg.norm(dr))
R2_avg=[average(R2s)]
DR_avg=[average(DRs)]

print R2_avg
print DR_avg
print DR_avg[0]/L
savetxt('R2_avg'+'_L_' + str(L),R2_avg)
savetxt('DR_avg'+'_L_'+str(L),DR_avg)
