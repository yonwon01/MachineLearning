########################################################################
#### 군집분석용 카드사용고객 raw 데이터 준비 ==> 계층적 군집분석으로 실시

# usage(월평균 카드사용횟수, 회)
# amount(1회평균 카드사용금액, 만원)
# period(쇼핑몰 사이트 이용시간, 분)
# variety(상품구매 다양성)

raw <- read.csv("mycard.csv", header=T, sep=",",
                stringsAsFactors = F, # 팩터화 없이 일반적 로딩 
                strip.white = T, # 데이터 요소별 좌우 공백 제거 
                na.strings = "") # 데이터 중 ""표시부분 NA로 인식

#######################################################################
## 데이터셋 간략 스캐닝
head(raw)
tail(raw)

install.packages("psych")
library(psych)
headTail(raw)
raw

## 내부구조 파악
str(raw)

## 요약기술통계 확인
summary(raw)

## 군집분석용 투입변수에 대한 기술통계분석 
psych::describe(raw)

## 변수컬럼별 박스플롯 그래프
boxplot(raw) 
# 데이터 규모/범위/단위가 달라 표준화 작업이 필요해 보임
# 또한 일부 이상치가 존재하지만 실제 관찰치이므로 그대로 사용

## 박스플롯에서 이상치 확인방법
x <- boxplot(raw$variety)
str(x)
x$out

#######################################################################
#### 각 관찰치간 거리구하기

## 소수점 출력자리수 설정
options(digits=3)

## 유클리드 거리(Euclidean distance): 공간에서 두 점 사이 거리계산방법
# 거리값이 작을수록 유사성 큼 == 비유사성 작음
# 거리값이 클수록 유사성 작음 == 비유사성 큼

dist(raw) # 관찰치간 거리계산
d <- dist(raw)
as.matrix(d)[1:2, 1:2] # 2개 관찰치간 거리계산 값을 조회
as.matrix(d)[1:4, 1:4] # 4개 관찰치간 거리계산 값을 조회

## 군집분석 전에 각 변수컬럼의 상대적인 규모/범위를 고려해 표준화실시
raw.scaled <- scale(raw)                                  
head(raw.scaled)

## 표준화된 데이터를 이용해 각 관찰치간 거리계산
d <- dist(raw.scaled)
as.matrix(d)[1:2, 1:2] # 2개 관찰치간 거리계산 값을 조회
as.matrix(d)[1:4, 1:4] # 4개 관찰치간 거리계산 값을 조회

#######################################################################
## 스크리(scree) 그래프방식의 군집갯수 산정용 사용자정의함수 
#패키지로 함수가 만들어져있지 않을때는 함수를 직접 만들어서 보통 Wssplot에 저장 한다.
wssplot <- function(data, nc=15, seed=1234) {  #cn=15 군집을 15개까지 분할한다는 뜻
  wss <- (nrow(data)-1) * sum(apply(data, 2, var))
  for (i in 2:nc) {
    set.seed(seed)
    wss[i] <- sum(kmeans(data, centers=i)$withinss)}
  plot(1:nc, wss, type="b", xlab="군집갯수",
       ylab="집단내 자승합", 
       main="스크리 그래프를 활용한 군집갯수 산정")}

## 스크리 그래프 방식의 잠재적 가능 군집갯수 파악
wssplot(raw)      
# 자승합: 각 사례별 데이터변화량과 편차를 제곱한 값들의 총합
# 군집을 3개로 할때까지는 이 수치가 급격하게 변화되고 있어
# 뚜렷한 군집갯수로서의 가치가 있는 것으로 판단됨
# 3개에서 4개로 넘어갈 때 이 수치가 완만해지는데, 
# 각 군집간 자승합 크기의 변화가 없다는 의미로
# 3개를 4개로 늘려도 그 군집으로서의 구분이 불명확하므로
# 3개 정도가 적당하다는 의미임

#######################################################################
## NbClust 패키지를 이용한 잠재적 가능 군집갯수 파악
install.packages("NbClust")
library(NbClust)

# raw데이터 무작위추출을 재생하기 위한 기본설정 
set.seed(1234) 

# k-평균방식을 적용했을 때의 가능 군집갯수 산정
nc <- NbClust(raw, min.nc=2, max.nc=15, method="kmeans")
nc # 26개 군집갯수 선정기준의 계산결과
par(mfrow=c(1, 1)) # 플로팅창 원래대로 리셋

nc$Best.nc # 26개 기준별 추천 군집정보 
nc$Best.nc[1, ] # 26개 기준별 추천 군집갯수
table(nc$Best.nc[1, ]) # 추천군집갯수별 빈도수 계산

## 추천군집갯수 그래프로 비교
barplot(table(nc$Best.nc[1, ]), 
        xlab="추천된 군집갯수", ylab="군집산정 기준 갯수",
        main="26개 군집갯수 산정기준을 통한 추천군집갯수")

install.packages("factoextra") # 패키지를 이용한 군집갯수 산정
library("factoextra")

fviz_nbclust(raw, kmeans, method = "wss")
fviz_nbclust(raw, kmeans, method = "silhouette")

#######################################################################
#### 3개 군집이 적정하다고 가정하고 k-평균 군집실시

## 동일한 무작위 샘플링이 재생되도록 발생시킴
set.seed(1234)

## 군집분석 전에 각 변수컬럼의 상대적인 규모/범위를 고려해 표준화실시
raw.scaled <- scale(raw)                                 

head(raw)
head(raw.scaled)

## stats::kmeans() 함수이용 -- 내장패키지에 이미 들어 있음 
fit.raw <- kmeans(raw, 3, nstart=25) # 스케일링 하지 않은 데이터 입력
fit.raw  # total_SS =  86.9 %  데이터의 소실이 조금 잇다는것  
fit.km <- kmeans(raw.scaled, 3, nstart=25) # 스케일링 한 데이터 입력
fit.km # k-평균군집화 결과확인

str(fit.km) # k-평균군집화 결과 내부구조 확인

fit.km$size # 3개로 군집화된 그룹의 요소갯수 파악
fit.km$cluster # 각 요소별로 어떤 군집에 속하는지 확인

## 관련 그래프로 확인
fviz_cluster(fit.raw, raw) # 스케일링 실시전 데이터로는 뚜렷한 군집불명확함
fviz_cluster(fit.km, raw) # 스케일링한 데이터에서는 뚜렷한 군집보임

## 기존 데이터셋에 그룹표시 변수컬럼 추가
raw2 <- data.frame(raw, group=fit.km$cluster)
psych::headTail(raw2)

#######################################################################
#### 각 군집별 특성파악(프로파일링)
# 프로파일링: 각 군집의 평균적인 특징을 별도로 파악하는 것
# 프로파일링방법: 군집분석에 사용한 변수컬럼들의 평균값을 구해보면 됨
# 프로파일링의 최종적으로 각 군집에 적정한 그룹명칭을 부여해 주면 좋음

## 프로파일링: 표준화된 데이터 활용 
fit.km$centers

## 프로파일링: 원래데이터 활용 
aggregate(raw2, by=list(raw2$group), mean)
aggregate(raw, by=list(cluster=fit.km$cluster), mean)

## 그룹명칭 부여
raw2$group.f <- factor(raw2$group, ordered = TRUE, 
                       levels = c(3, 1, 2),
                       labels = c("1:Gold", "2:Star", "3:Tree"))

psych::headTail(raw2)

tb <- table(raw2$group.f)
tb
addmargins(tb)
as.data.frame(addmargins(tb))

tb.pro <- prop.table(tb)
tb.pro
addmargins(tb.pro)
as.data.frame(addmargins(tb.pro))

#######################################################################
## caret패키지의 시각화 기능이용 그래프 그리기
# install.packages("caret", dependencies = TRUE)
# caret이 추천하는 다양한 패키지를 함께 설치하기 위해서
# dependencies = TRUE 옵션을 사용함

library(caret)

featurePlot(x = raw2[ , c(1:4)], y = raw2$group.f, 
            plot = "pairs", 
            auto.key = list(columns = 3)) # 상단에 한줄당 범례표시갯수 

featurePlot(x = raw2[ , c(1:4)], y = raw2$group.f, 
            plot = "density",
            scales = list(x = list(relation="free"),
                          y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(4, 1),
            auto.key = list(columns = 3)) # 상단에 한줄당 범례표시갯수

featurePlot(x = raw2[ , c(1:4)], y = raw2$group.f, 
            plot = "box",
            scales = list(y = list(relation="free"),
                          x = list(rot = 90)),
            layout = c(4, 1))

install.packages("ellipse")
library(ellipse)
featurePlot(x = raw2[ , c(1:5)], y = raw2$group.f, 
            plot = "ellipse") 

pairs(~ usage + amount + variety + period, data=raw2, 
      pch=c(1, 2, 3)[raw2$group.f], 
      col=c(1, 2, 3)[raw2$group.f])

#######################################################################
#######################################################################
#### k-medoids 방식을 이용한 군집분석
# 보통의 계층형/분할형 군집분석은 연속형/정량적 데이터를 사용해야함
# 이로인해 이상치에 민감하게 반응하는 결과가 나올 수 있음
# k-modoids 방법은 연속형/정량적 데이터 이외에 다른 척도 사용가능
# medoids라고 부르는 임의의 관측치를 무작위로 선정한다음 
# 다른 관측치들과의 거리/비유사성을 계산해 가까운 medoides에 배정함

## 동일한 무작위 샘플링이 재생되도록 발생시킴
set.seed(1234)

## cluster 패키지의 pam() 함수이용
library(cluster) 
# cluster패키지는 recommend 패키지로서
# R콘솔 설치시 기본적으로 같이 설치되는 패키지임
# 그러나 사용하려면 library()를 이용해 메모리로 로딩해야함

## pam() 함수 실행 
fit.pam <- pam(raw, k=3, stand=TRUE)
# 이전 kmeans분석 초반에 3개 군집이 적정하다는 결과활용
# 변수컬럼들의 규모/범위/단위들이 상이하므로
# 표준화(stand옵션사용) 방식의 데이터 변환을 통해 군집분석실시

fit.pam # k-medoids 군집화 결과확인
# $Medoids 부분을 보면 42, 267, 202가 
# 각 군집을 대표하는 Medoids로 선정됨을 알 수 있음

str(fit.pam) # k-medoids 군집화 결과 내부구조 확인

fit.pam$clustering # 각 요소별로 어떤 군집에 속하는지 확인
fit.pam$medoids

# 관련 그래프로 확인
fviz_cluster(fit.pam)

## 기존 데이터셋에 그룹표시 변수컬럼 추가
raw3 <- data.frame(raw, group=fit.pam$clustering)
headTail(raw3)

#######################################################################
#### 각 군집별 특성파악(프로파일링)
# 프로파일링: 각 군집의 평균적인 특징을 별도로 파악하는 것
# 프로파일링방법: 군집분석에 사용한 변수컬럼들의 평균값을 구해보면 됨
# 프로파일링의 최종적으로 각 군집에 적정한 그룹명칭을 부여해 주면 좋음

## 프로파일링: 표준화된 데이터 활용 
fit.pam$medoids

## 프로파일링: 원래데이터 활용 
aggregate(raw3, by=list(raw3$group), mean)
aggregate(raw, by=list(cluster=fit.pam$clustering), mean)


## 3개로 군집화된 그룹별 그래프 비교
clusplot(fit.pam, main="Bivariate Cluster Plot")
# k-medoids 군집분석에 사용한 13개 화학성분 변수컬럼을
# 크게 2개의 성분차원으로 만들었을 때 각 관찰치들의
# 상대적인 특성/위치의 비교

## 그룹명칭 부여
raw3$group.f <- factor(raw2$group, ordered = TRUE, 
                       levels = c(3, 2, 1),
                       labels = c("1:Gold", "2:Star", "3:Tree"))

tb <- table(raw3$group.f)
tb
as.data.frame(tb)
addmargins(tb)
as.data.frame(addmargins(tb))

tb.pro <- prop.table(tb)
tb.pro
addmargins(tb.pro)
as.data.frame(addmargins(tb.pro))

### End of Source #####################################################
