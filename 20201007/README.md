# 2020.10.07

> R로 `한국복지패널데이터` 분석



## 1. 필요라이브러리 불러오기

```R
library(foreign)
library(readxl)
library(ggplot2)
```

## 2. 데이터 불러오기

```R
raw_welfare<-read.spss(file="Data/Koweps_hpc10_2015_beta1.sav", to.data.frame = T)
#복사본
welfare<-raw_welfare
```

혹시 모르니 **복사본** 을 만드는것이 좋다.

.sav파일은 `foreign`패키지에서 `spss`로 가져온다.

## 3. 컬럼이름 바꿔주기

```R
welfare<-rename(welfare, 
       sex=h10_g3,
       birth=h10_g4,
       marriage=h10_g10,
       religion=h10_g11,
       income=p1002_8aq1,
       code_job=h10_eco9,
       code_region=h10_reg7
       )
```

## 4. 분석하기

### 4.1 성별에 따른 월급 차이



