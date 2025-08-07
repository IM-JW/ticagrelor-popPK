setwd("C:/Users/clinpharm/Desktop/NM/01 simul_20~100")

# Load the scenario data
ticagrelor_scenario <- read.csv("tica_scenario.csv")
ticagrelor_scenario

# Define the control template
control_template <- "
$PROBLEM TICAGRELOR MBMA
;; 1. Based on: 3122
;; 2. Description: amt=%s, MN=%s, sex=%s, smok=%s, age=%s
;; x1. Author: clinpharm_HE

$INPUT ID TIME AMT DV MDV CMT MN SEX SMOK AGE 
$DATA sim%s.csv IGNORE=@
$SUBROUTINES ADVAN9 TOL=4

$MODEL
COMP= 1   ;(DEPOT)            
COMP= 2   ;(CENTRAL)          
COMP= 3   ;(CENTRALMB)       


$PK
  TVKA=THETA(1)
  TVCL=THETA(2) * THETA(11)**SMOK * ((AGE/67)**THETA(12))
  TVV=THETA(3)
  TVCLM= THETA(4) * EXP(THETA(14)*SMOK) + THETA(13)*SEX 
  TVVM = THETA(5)
  TVFM = THETA(6)

  KA = TVKA ; Absorption rate constant
  CL=TVCL * EXP(ETA(1)) ; Total Clearance
  V=TVV * EXP(ETA(2)) ; Central volume of Parent
  CLM = TVCLM * EXP(ETA(3)) ; CL of metabolite
  VM = TVVM  ; Central volume of Metabolite
  FM = TVFM  ; Fraction metabolized

  K20 = CL*(1-FM)/V ; CL*FM=CL of metabolite formation (CLFM)
  K23 = CL*FM/V ; CL*(1-FM)=CL of other route (CLO)
  K30 = CLM/VM

  S2=V ; AMT (mg) DV(scaling nM to mg/L)
  S3=VM ; AMT (mg) DV(scaling nM to mg/L)



$DES
DADT(1) = -KA*A(1)
DADT(2) = KA*A(1) - K20*A(2) - K23*A(2) 
DADT(3) = K23*A(2) - K30*A(3)


$ERROR
IPRED = F
IF (MN.EQ.1) THEN
W = SQRT(THETA(7)**2 + THETA(8)**2 * IPRED**2)
ELSE 
W = SQRT(THETA(9)**2 + THETA(10)**2 * IPRED**2)
ENDIF
IRES = DV - IPRED
IWRES = IRES / W
Y = F + W * EPS(1)
CWRES = IRES / SQRT(IPRED**2)


$THETA
(0, 0.613) FIX ;1.KA
(0, 13.3) FIX ;2.CL
(0, 228) FIX ;3.V
(0, 9.75) FIX ;4.CLM
(3, 4.59) FIX ;5.VM
(0.226) FIX ;6.FMET
(1E-09) FIX ;7. ADD 2016
(0.105) FIX ;8. PRO 2016
(1E-09) FIX ;9, ADD 2017
(0.0862) FIX ;10. PRO 2017
(0, 0.894) FIX ;11. SMOK on CL
(-0.212) FIX ;12. AGE on CL
(0.886) FIX ;13. SEX on CLM
(0.0589) FIX ;14. SMOK on CLM

$OMEGA 
 0.0954 FIX  ; IIV-CL
 0.211 FIX  ; IIV-V
 0.0872 FIX  ; IIV-CLM

$SIGMA
 1 FIX 

$SIM (12345) (54321) ONLYSIM
$TABLE ID TIME AMT DV MDV CMT MN SEX SMOK AGE ONEHEADER NOPRINT FILE =sim%s.tab
$TABLE ID TIME AMT DV MDV CMT MN SEX SMOK AGE ONEHEADER NOPRINT FILE =simtab%s.csv
"

# Loop through each scenario
for (i in 1:nrow(ticagrelor_scenario)) {
  # Get scenario data
  scenario_data <- ticagrelor_scenario[i, ]
  scenario_data
  # Generating the numbers used 파일명과 파일 내용에서 사용할 번호 생성
  sim_number <- sprintf("%d", i)
  sim_number
  
  # Replace the values in the control_template
  
  control_template_modified <- sprintf(control_template, scenario_data$AMT, scenario_data$MN, scenario_data$SEX, scenario_data$SMOK, scenario_data$AGE, sim_number, sim_number, sim_number)
  
  # 파일 경로 및 이름 설정 (.ctl 확장자 사용)
  file_name <- sprintf("C:/Users/clinpharm/Desktop/NM/01 simul_20~100/sim%s.ctl", sim_number)
  
  # 파일 쓰기
  writeLines(control_template_modified, file_name)
}

