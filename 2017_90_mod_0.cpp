[PROB] 2017_Ticagrelor_90mg

[PARAM] @annotated 
TVKA : 1.44 : Absorption rate constant
TVCL : 15.4 : Typical value of clreance
TVV : 323.0 : Typical central volume of distribution
TVCLM : 9.95 : metabolite clreance
TVVM : 6.98 : Typical metabolite volume of distribution
TVFM : 0.22 : Typical fraction of drug converted to metabolite

[PARAM] @covariate @annotated
TVAGE65 : -0.0818 : 65-75
TVAGE75 : -0.152 : >75
TVJAP : -0.159 : japanese
TVSEX : -0.113 : female
TVSMOK : 0.0806 : smoking
TVWT : 0.220 : median 84(33-172)

TVAGE65M : -0.149 : 65-75
TVAGE75M : -0.264 : >75
TVJAPM : -0.169 : japanese
TVSEXM : -0.286 : female
TVSMOKM : 0.116 : smoking
TVWTM : 0.834 : median 84(33-172)
  
AGE65 : 1 : 1= 65-75, 0=other
AGE75 : 1 : 1= >75, 0=other
JAP : 0 : 1yes 0no
SEX : 0 : 1female 0male
SMOK : 0 : 1yes 0no
WT : 82 : median 82(33-158)


[MAIN]
double CL = TVCL*(1+TVAGE65*AGE65)*(1+TVAGE75*AGE75)*(1+TVJAP*JAP)*(1+TVSEX*SEX)*(1+TVSMOK*SMOK)*pow(WT/82, TVWT)*exp(ECL);
double V = TVV*exp(EV);
double KA = TVKA*exp(EKA);
double CLM = TVCLM*(1+TVAGE65M*AGE65)*(1+TVAGE75M*AGE75)*(1+TVJAPM*JAP)*(1+TVSEXM*SEX)*(1+TVSMOKM*SMOK)*pow(WT/82, TVWTM)*exp(ECLM);
double VM = TVVM;
double FM = TVFM;


[CMT] @annotated
GUT: Dosing compartment
CENT: Central compartment of parent drug
CENTM: Central compartment of metabolite

[ODE]
dxdt_GUT = -KA*GUT;
dxdt_CENT = KA*GUT - (CL*(1-FM))/V*CENT - (CL*FM)/V*CENT ;
dxdt_CENTM = (CL*FM)/V*CENT - CLM/VM*CENTM;


[OMEGA] @annotated @block
EKA  : 0.592 : ETA on absorption rate
ECL  : 0.0 0.198 : ETA on clearance
EV   : 0.0 0.300 0.346 : ETA on volume
ECLM : 0.0 0.0 0.0 0.126 : ETA on clearance to metabolite
@correlation
0.0 0.0 0.0 0.0
0.0 0.0 0.0 0.0
0.0 1.0 0.0 0.0
0.0 0.0 0.0 0.0


[SIGMA]
0 0 0 0


[TABLE]
double CP = (CENT/V)*(1+EPS(1))+EPS(2);
double CM = (CENTM/VM)*(1+EPS(3))+EPS(4);

[CAPTURE] @annotated
CP : Plasma concentration of parent drug
CM : Plasma concentration of metabolite