library(dplyr)
library(readxl)
install.packages("foreign", dep=T)
library(foreign)
library(ggplot2)
raw_welfare<-read.spss(file="Data/Koweps_hpc10_2015_beta1.sav", to.data.frame = T)
welfare<-raw_welfare
welfare<-rename(welfare, 
                sex=h10_g3,
                birth=h10_g4,
                marriage=h10_g10,
                religion=h10_g11,
                income=p1002_8aq1,
                code_job=h10_eco9,
                code_region=h10_reg7
)
# 1. 지역별 연령(대) 비율을 조사 및 시각화 분석
welfare$age<-2015-welfare$birth+1

welfare <- welfare %>%
  mutate(age_group = ifelse(age < 30, "young",
                       ifelse(age <= 59, "middle", "old")))
table(welfare$age_group)

regions = data.frame(
  code_region = c(1:7),
  region = c("서울",'수도권/인천/경기','부산/경남/울산',
             '대구/경북','대전/충남','강원/충북','광주/전남/전북/제주'))

welfare <- left_join(welfare, regions, id = "code_region")

welfare %>%
  head


age_region <- welfare %>% 
  group_by(region,age_group) %>% 
  summarise(cnt=n()) %>% 
  mutate(tot_group=sum(cnt)) %>% 
  mutate(pct=round(cnt/tot_group*100,1))

# 그래프
ggplot(data =age_region, aes(x=region, y=pct))+geom_col()



# 2. mpg 데이터를 이용해서 분석 문제를 해결해 보세요.  mpg 데이터 원본에는 결측치가 없습니다. 
# 우선 mpg 데이터를 불러와 몇 개의 값을 결측치로 만들겠습니다.  아래 코드를 실행하면 다섯 행의 hwy 변수에 NA가 할당됩니다.
mpg <- as.data.frame(ggplot2::mpg) # mpg 데이터 불러오기 
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA # NA 할당하기


# Q1. drv(구동방식)별로 hwy(고속도로 연비) 평균이 어떻게 다른지 알아보려고 합니다. 
#분석을 하기 전에 우선 두 변수에 결측치가 있는지 확인해야 합니다. 
#drv 변수와 hwy 변수에 결측치가 몇 개 있는지 알아보세요.

sum(is.na(mpg$drv)) # 0
sum(is.na(mpg$hwy)) # 5

# Q2. filter()를 이용해 hwy 변수의 결측치를 제외하고, 어떤 구동방식의 hwy 평균이 높은지 알아보세요. 
# 하나의 dplyr 구문으로 만들어야 합니다.


mpg %>% 
  filter(!is.na(hwy)) %>% 
  group_by(drv) %>% 
  summarise(means = mean(hwy)) %>% 
  arrange(desc(means))


# mpg 데이터를 불러와서 일부러 이상치를 만들겠습니다. 
# drv(구동방식) 변수의 값은 4(사륜구동), f(전륜구동), r(후륜구동) 세 종류로 되어있습니다. 
# 몇 개의 행에 존재할 수 없는 값 k를 할당하겠습니다. 
# cty(도시 연비) 변수도 몇 개의 행에 극단적으로 크거나 작은 값을 할당하겠습니다.
mpg <- as.data.frame(ggplot2::mpg) # mpg 데이터 불러오기 
mpg[c(10, 14, 58, 93), "drv"] <- "k" # drv 이상치 할당 
mpg[c(29, 43, 129, 203), "cty"] <- c(3, 4, 39, 42) # cty 이상치 할당


#  • Q1. drv에 이상치가 있는지 확인하세요. 이상치를 결측 처리한 다음 이상치가 사라졌는지 확인하세요. 
# 결측 처리 할 때는 %in% 기호를 활용하세요. 

mpg$drv<-ifelse(mpg$drv %in% c(10, 14, 58, 93), NA,mpg$drv)

# • Q2. 상자 그림을 이용해서 cty에 이상치가 있는지 확인하세요. 

boxplot(mpg$cty)


#상자 그림의 통계치를 이용해 정상 범위를 벗어난 값을 결측 처리한 후 다시 상자 그림을 만들어 이상치가 사라졌는지 확인하세요.
#• Q3. 두 변수의 이상치를 결측처리 했으니 이제 분석할 차례입니다. 

mpg$cty<-ifelse(mpg$cty %in% c(29, 43, 129, 203), NA,mpg$cty)
boxplot(mpg$cty)

#이상치를 제외한 다음 drv별로 cty 평균이 어떻게 다른지 알아보세요. 하나의 dplyr 구문으로 만들어야 합니다.
mpg %>% 
  filter(!is.na(drv) & !is.na(cty)) %>% 
  group_by(drv) %>% 
  summarise(cty_mean = mean(cty))


