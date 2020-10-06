# mpg 데이터를 이용해 분석 문제를 해결해 보세요.
ggplot2::mpg 
mpg<-as.data.frame(ggplot2::mpg)

install.packages("dplyr")
library("dplyr")


#Q1. 자동차 배기량에 따라 고속도로 연비가 다른지 알아보려고 합니다. 
#displ(배기량)이 4 이하인 자동차와 5 이상인 자동차 중 어떤 자동차의 hwy(고속도로 연비)가 평균적으로 더 높은지 알아보세요.
dis4 <- mpg %>% filter(displ <=4)
dis5 <- mpg %>% filter(displ >=5)
mean(dis4$hwy) #25.96319
mean(dis5$hwy) #18.07895
# 배기량이 낮을수록 연비가 더 높음

#Q2. 자동차 제조 회사에 따라 도시 연비가 다른지 알아보려고 합니다. 
#"audi"와 "toyota" 중 어느 manufacturer(자동차 제조 회사)의 cty(도시 연비)가 평균적으로 더 높은지 알아보세요. 
auid_mpg <- mpg %>% filter(manufacturer =="audi")
toyo_mpg <- mpg %>% filter(manufacturer == "toyota")
mean(auid_mpg$cty) # 17.61111
mean(toyo_mpg$cty) # 18.52941
# toyota 가 더 높음

# Q3."chevrolet", "ford", "honda" 자동차의 고속도로 연비 평균을 알아보려고 합니다. 
#이 회사들의 자동차를 추출한 뒤 hwy 전체 평균을 구해보세요.

car_hwy <- mpg %>% filter(manufacturer %in% c("chevrolet", "ford", "honda") )
mean(car_hwy$hwy) # 22.50943


# Q4. mpg 데이터는 11개 변수로 구성되어 있습니다. 이 중 일부만 추출해서 분석에 활용하려고 합니다. mpg 데이터에서 class(자동차 종류), cty(도시 연비) 변수를 추출해 새로운 데이터를 만드세요. 
#새로 만든 데이터의 일부를 출력해서 두 변수로만 구성되어 있는지 확인하세요.

new_mpg <- mpg %>% select(class,cty)
new_mpg


# Q5. 자동차 종류에 따라 도시 연비가 다른지 알아보려고 합니다. 
#앞에서 추출한 데이터를 이용해서 class(자동차 종류)가 "suv"인 자동차와 "compact"인 자동차 중 어떤 자동차의 cty(도시 연비)가 더 높은지 알아보세요.

sum((new_mpg %>% filter(class == "compact"))$cty) # 946

sum((new_mpg %>% filter(class == "suv"))$cty) # 837

# compact 연비가 더 높음

# Q6. "audi"에서 생산한 자동차 중에 어떤 자동차 모델의 hwy(고속도로 연비)가 높은지 알아보려고 합니다. 
# "audi"에서 생산한 자동차 중 hwy가 1~5위에 해당하는 자동차의 데이터를 출력하세요.
auid_mpg %>%  arrange(desc(hwy)) %>% head(5)


# Q7. mpg 데이터 복사본을 만들고
#mpg <- as.data.frame(ggplot2::mpg)
#mpg_new <- mpg 
#cty와 hwy를 더한 '합산 연비 변수'를 추가하세요.

mpg <- as.data.frame(ggplot2::mpg)
copy_mpg <- mpg
copy_mpg

copy_mpg <-copy_mpg %>% mutate(total=cty + hwy)
head(copy_mpg)

# Q8. 앞에서 만든 '합산 연비 변수'를 2로 나눠 '평균 연비 변수'를 추가세요.
copy_mpg <- copy_mpg %>% mutate(total_div = total/2)
head(copy_mpg)

# Q9. '평균 연비 변수'가 가장 높은 자동차 3종의 데이터를 출력하세요. 
copy_mpg %>%  arrange(desc(total_div)) %>% head(3)


# • Q4. 1~3번 문제를 해결할 수 있는 하나로 연결된 dplyr 구문을 만들어 출력하세요. 데이터는 복사본 대신 mpg 원본을 이용하세요.
mpg %>%  mutate(total = cty + hwy, total_div = total/2) %>% 
  arrange(desc(total_div)) %>% head(3)

# Q10. 회사별로 "suv" 자동차의 도시 및 고속도로 통합 연비 평균을 구해 내림차순으로 정렬하고, 1~5위까지 출력하기
mpg %>% filter(class == "suv")%>% 
  group_by(manufacturer) %>% 
  summarise(means=mean(cty+hwy)) %>% 
  arrange(desc(means)) %>% 
  head(5)

# Q11. mpg 데이터의 class는 "suv", "compact" 등 자동차를 특징에 따라 일곱 종류로 분류한 변수입니다. 
#어떤 차종의 연비가 높은지 비교해보려고 합니다. class별 cty 평균을 구해보세요.
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty))


# Q12. 앞 문제의 출력 결과는 class 값 알파벳 순으로 정렬되어 있습니다. 
#어떤 차종의 도시 연비가 높은지 쉽게 알아볼 수 있도록 cty 평균이 높은 순으로 정렬해 출력하세요. 
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty))

# Q13. 어떤 회사 자동차의 hwy(고속도로 연비)가 가장 높은지 알아보려고 합니다. hwy 평균이 가장 높은 회사 세 곳을 출력하세요. 
mpg %>%
  group_by(manufacturer) %>% 
  summarise(mean_hwy=mean(hwy)) %>% 
  arrange(desc(mean_hwy)) %>% 
  head(3)


# Q14. 어떤 회사에서 "compact"(경차) 차종을 가장 많이 생산하는지 알아보려고 합니다. 
#각 회사별 "compact" 차종 수를 내림차순으로 정렬해 출력하세요.
mpg %>% filter(class == "compact")%>% 
  group_by(manufacturer) %>% 
  summarise(n=n()) %>% 
  arrange(desc(n))



