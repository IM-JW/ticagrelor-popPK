[PARAM] @annotated 
TVCL : 14.0 : Typical value of clreance
TVV : 221.0 : Typical central volume of distribution
TVKA : 0.676 : Absorption rate constant
TVCLM : 9.06 : metabolite clreance
TVVM : 13.1 : Typical metabolite volume of distribution

TVFM : 0.22 : Typical fraction of drug converted to metabolite
TVF1 : 1.0 : Typical relative bioavailability of ticagrelor

[PARAM] @covariate @annotated  
TVSMKH : 0.199 : Habitual smoker
TVMINH: -0.439 : moderate CYP3A inhibitor
TVMIND: 0.742 :moderate CYP3A inducer

TVSEXM : -0.374 : metabolite sex
TVSMKHM : 0.244 : metabolite Habitual smoker 
TVMINDM : 0.688 : metabilite CYP3A inducer
TVVISIT1M : -0.200 : first visit

TVVISIT1 : -0.200 : first visit
TVRACEA : 0.330 : Race Asian
TVRACEB : -0.195 : Race Black


SMKH : 1 : 1yes 0no
MINH : 0 : 1yes 0no
MIND : 0 : 1yes 0no
VISIT1 : 1 : 1yes 0no
SEX : 0 : 0male 1female
RACEA : 0 : 1yes 0no
RACEB : 0 : 1yes 0no


[MAIN]
double CL = TVCL*(1+TVSMKH*SMKH)*(1+TVMINH*MINH)*(1+TVMIND*MIND)*exp(ECL);
double V = TVV*exp(EV);
double KA = TVKA*exp(EKA);

double CLM = TVCLM*(1+TVSEXM*SEX)*(1+TVSMKHM*SMKH)*(1+TVMINDM*MIND)*(1+TVVISIT1M*VISIT1)*exp(ECLM);
double VM = TVVM*exp(EV);
double FM = TVFM;
double F1 = TVF1*(1+TVVISIT1*VISIT1)*(1+TVRACEA*RACEA)*(1+TVRACEB*RACEB)*exp(EF1);


[CMT] @annotated
GUT : Dosing compartment (mg)
CENT : Central compartment of parent drug (mg)
CENTM : Central compartment of metabolite (mg) 
  
  
[ODE]
dxdt_GUT = -KA*GUT;
dxdt_CENT = KA*GUT - (CL*(1-FM))/V*CENT - (CL*FM)/V*CENT ;
dxdt_CENTM = (CL*FM)/V*CENT - CLM/VM*CENTM;


[OMEGA] @annotated @block
ECL: 0.144 : ETA on clearance
EV: 0.089 0.244 : ETA on volume
EKA: 0 0 1.97 : ETA on absorption rate constant
ECLM: 0 0 0 0.0567 : ETA on clearance to metabolite

[OMEGA] @annotated 
EF1: 0.150 : ETA on relative bioavailability

[SIGMA]
0 0 0 0

[TABLE]
double CP = (CENT/V)*(1+EPS(1))+EPS(2);
double CM = (CENTM/VM)*(1+EPS(3))+EPS(4);

[CAPTURE] @annotated
CP : Plasma concentration of parent drug
CM : Plasma concentration of metabolite