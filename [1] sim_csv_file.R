setwd("C:/Users/clinpharm/Desktop/NM/01 simul_20~100")

####### Reading scenario file
scenario <- read.csv(file="tica_scenario.csv", header=TRUE, sep=",", quote="")
#scenario <- scenario[,-11]
names(scenario)[1] <- "NAME" #첫 행 첫 열 이름을 name으로 변경
head(scenario)

set.seed(123)
PRPR <- c(1:1000)  # 10명의 데이터 생성, 1000명이라면 c(1:1000)
jk <- c(1:64)  # 시나리오 개수

for (j in jk) {
  output1 <- NULL  # 각 시나리오마다 output1 초기화
  LD <- scenario$LD[j]
  AMT <- scenario$AMT[j]
  II <- scenario$II[j]  # 투약 간격
  
  for (i in PRPR) {
    # 모든 시간 포인트를 포함하는 배열 생성
    all_times <- 0:156
    # 투약 시간 계산
    dosing_times <- seq(0, max(all_times), by=II)
    # 투약되지 않은 시간 포인트에 대해 중복 생성
    non_dosing_times <- setdiff(all_times, dosing_times)
    duplicated_non_dosing_times <- rep(all_times, each=2)
    #duplicated_non_dosing_times <- rep(non_dosing_times, each=2)
    # 최종 TIME 배열 생성
    TIME <- sort(c(dosing_times, duplicated_non_dosing_times))
    
    # AMT 설정
    dosing_AMT <- rep(".", length(TIME))
    dosing_indices <- match(dosing_times, TIME) # 실제 TIME 배열에서 투약 시간의 인덱스 찾기
    dosing_AMT[dosing_indices] <- ifelse(dosing_indices == 1, LD, AMT)
    
    # DV, MDV, CMT 설정
    DV <- rep(".", length(TIME))
    MDV <- ifelse(dosing_AMT == ".", 0, 1)
    
    # 수정된 부분
    CMT <- numeric(length(TIME))
    CMT[dosing_indices] <- 1  # CMT 를  1로 지정
    alt_indices <- setdiff(1:length(TIME), dosing_indices) # 약물 투여 안될 때
    #AMT 0 일 때 CMT에 2, 3 반복 지정
    CMT[alt_indices] <- rep(c(2,3), length.out = length(alt_indices))
    
    # 재수정 부분
    # SEX, SMOK, AGE 변수 가져오기
    MN <- scenario$MN[j]
    SEX <- scenario$SEX[j]
    SMOK <- scenario$SMOK[j]
    AGE <- scenario$AGE[j]
    
    # 데이터 프레임 생성
    d1 <- data.frame(ID = rep(i, length(TIME)), TIME, AMT = dosing_AMT, DV, MDV, CMT, MN, SEX, SMOK, AGE)
    
    if (is.null(output1)) {
      output1 <- d1
    } else {
      output1 <- rbind(output1, d1)
    }
  }
  #file_name <- sprintf("sim%03d.csv", j)
  file_name <- paste0("sim", j, ".csv")
  write.csv(output1, file_name, row.names=FALSE, quote=FALSE)
  output1 <- NULL  # 다음 시나리오에 대해 output1 초기화
}

