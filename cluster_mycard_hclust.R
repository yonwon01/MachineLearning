######## 데이터 축소화 분석(data reduction):
# - 계층적 알고
# - raw 데이터의 분포/특징을 가장 잘 나타내는  
# - 대표적인 데이터 유형을 찾아내고 
# - 불필요한 잡음(noise)를 제거해줌 

# 대표적인 데이터 유형에는 관찰치와 변수컬럼을 대상으로 
# 그룹핑/유형화/묶음/축소화 등의 유사작업을 수행함

#### 축소화/유형화 분석의 종류
## (1) 관찰치를 묶어서 데이터를 축소함
# - 군집분석(clustering Analysis)
# - 다차원척도분석(Multidimensional Scaling)
# - 연관분석(Association Analysis; Basket Analysis)

## (2) 변수컬럼을 묶어서 데이터를 축소함
# - 주성분(Principal Componnent Analysis)
# - 요인분석(Factor A고nalysis)

#######################################################################
#### 군집분석(clustering)
## 여러개의 관찰치/관측치/사례/케이스/레코드들을 대상으로
## 특성이 유사한 것끼리 하나의 그룹으로 묶어줌
## 일종의 데이터 축소화(reduction) 분석에 속함

## 크게 2가지 방식의 군집분석 기법이 있음
# (1) 계층적/위계적/응축적(hierarchical)/탐색적(exploratory) 군집분석
# - 데이터변량차이가 가장가까운 2개 관찰리를 하나의 군집으로 응축해 시작해 계속 거리차이가 가까운 군집들과 응축해 나가는 방법
# - 최대한 나눌 수 있을 만큼/ 그룹핑 할 수 있을 만큼 해줌
# 한 번 그룹핑된 관찰치를 다른 그룹에 넣을 수 없음

# - hclust()

# (2) 분할적(partitioning)/확인적(confirmatory) 군집분석
# - 분석가가 군집의 갯수를 알고리즘에 지정/입력한 다음 해당  그룹핑 작업을 시킴
# - 대상 관찰치들을 어느 분할된 그룹에 입력했다가
# 그 그룹의 변량차이에 어울리면 놓고, 아니면 다른 그룹에 
# 이동해서 다시 그 그룹의 변량계산 함

# - kmeans(), cluster::pam()

########################################################################
#### 군집분석용 카드사용고객 raw 데이터 준비 ==> 계층적 군집분석으로 실시

# usage(월평균 카드사용횟수, 회)
# amount(1회평균 카드사용금액, 만원)
# period(쇼핑몰 사이트 이용시간, 분)
# variety(상품구매 다양성)
menus <- read.csv(file.choose(), stringsAsFactors =  FALSE, colClasses = c("factor","Date","numeric")) 
 # menus.csv 선택 
 # menus <- read.csv("Chapter04/menus.csv", stringsAsFactors =  FALSE, colClasses = c("factor","Date","numeric")) 


raw <- read.csv("C:/Users/user/Desktop/part2/mycard.csv", header=T, sep=",", #데이터에 header가 있으니까 T사용 
                stringsAsFactors = F, # 팩터화 없이 일반적 로딩. 범주형 데이터로 인식하고 싶을때
                strip.white = T, # 데이터 요소별 좌우 공백 제거 
                na.strings = "") # 데이터 중 ""표시부분 NA로 인식.   데이터중 ?로 되어있는걸  결측데이터로 바꾸고 싶을때 na.strings = "?"
#usage:신용카드사용횟수
#amount  :결제금액
#variety :물건종류
#period: web사이트 쇼핑 시간 

#만약 데이터가 너무 클때는 data.table 패키지사용  fread() 함수! 
#install(data.table)
#library(data.table)
#fread.csv


#######################################################################
## 데이터셋 간략 스캐닝
head(raw)
tail(raw)

install.packages("psych")
library(psych)
headTail(raw)
raw

options(0)

options(max.print=2000) #print를 2000개까지 찍을 수 있게 세팅하는 거 (ex)raw데이터는 4 * 292개 나옴)

## 내부구조 파악
str(raw)

## 요약기술통계 확인
summary(raw) #보통 min과 max의 차이가 너무 많이나면 결측치가 있을 수 있음, 차이가 많이 날때는 median을 사용. 연속적 데이터 일때는 mean을 많이 사용 

## 군집분석용 투입변수에 대한 기술통계분석 
psych::describe(raw) ## 패키지명::함수  
# trimmed극단적인 수 제외 하는것 
# skew 분포모양 의미하는 것(다른 한쪽으로 치우쳐 있는지 확인하는 것) 
# kurtosis( 분포모양이 뾰족한지 확인하는 것)

search()

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

## 거리간 유사성/비유사성을 시각적으로 파악

install.packages("factoextra")
library(factoextra)

# 관찰치별 거리간 상관성 파악
res.dist <- get_dist(d, stand = TRUE, method = "pearson")
# 관찰치별 거리간 상관성을 시각적으로 표현
fviz_dist(res.dist, 
          gradient = list(low = "#00AFBB", 
                          mid = "white", 
                          high = "#FC4E07"))

#######################################################################
#### 계층적 군집분석 실시

## stats::hclust() 함수이용 -- 내장패키지에 이미 들어 있음 
fit.average <- hclust(d, method="average")

## 계층적 군집분석 그래프화
plot(fit.average, hang=-1, cex=.8, 
     main="평균연결법을 활용한 계층적 군집분석")

str(fit.average) # 군집분석 결과 내부구조확인
fit.average$order 
# 덴드로그램(dengrogram; 계통도) 각 요소별 순서확인

#######################################################################
#### 계층적 군집분석의 적정 군집갯수 선정

install.packages("NbClust") # 패지키 이용
library(NbClust)
nc <- NbClust(raw.scaled, distance="euclidean", 
              min.nc=2, max.nc=15, method="average")
nc # 26개 군집갯수 선정기준의 계산결과
par(mfrow=c(1, 1)) # 플로팅창 원래대로 리셋

nc$Best.nc # 26개 기준별 추천 군집정보 
nc$Best.nc[1, ] # 26개 기준별 추천 군집갯수
table(nc$Best.nc[1,]) # 추천군집갯수별 빈도수 계산

## 추천군집갯수 그래프를 통한 비교
barplot(table(nc$Best.nc[1,]), 
        xlab="추천된 군집갯수", ylab="군집산정 기준 갯수",
        main="26개 군집갯수 산정기준을 통한 추천군집갯수") 

#######################################################################
#### 5개 군집이 적정하다고 가정하고 군집별 특성파악

## 5개 군집분할 영역표시
plot(fit.average, hang=-1, cex=.8,  
     main="평균연결법을 활용한 계층적 군집분석")
rect.hclust(fit.average, k=5) # 박스색상 단순히
rect.hclust(fit.average, k=5, border=2:6) # 박스색상 여러개로

install.packages("factoextra") # 패키지 이용  
library(factoextra)
res <- hcut(raw, k = 5, stand = TRUE)

# 관련 시각화
fviz_dend(res, rect = TRUE, cex = 0.5,
          k_colors = c("#00AFBB","#2E9FDF", "#E7B800", "#FC4E07", "#2F9D27"))


## 관찰치들을 5개로 실제 군집분할 실시
clusters <- cutree(fit.average, k=5)
clusters # 관찰치별로 어떤 군집에 속하는지 확인
table(clusters) # 5개 군집별로 속해 있는 관찰치 갯수 확인

## 기존 데이터셋에 그룹표시 변수컬럼 추가
raw2 <- data.frame(raw, group=clusters)
psych::headTail(raw2)

# 관련 시각화
fviz_cluster(list(data = raw, cluster = clusters))
y <- fviz_cluster(list(data = raw, cluster = clusters))
str(y)
#######################################################################
#### 각 군집별 특성파악(프로파일링)
# 프로파일링: 각 군집의 평균적인 특징을 별도로 파악하는 것
# 프로파일링방법: 군집분석에 사용한 변수컬럼들의 평균값을 구해보면 됨
# 프로파일링의 최종적으로 각 군집에 적정한 그룹명칭을 부여해 주면 좋음

## 프로파일링: 표준화된 데이터 활용 
aggregate(as.data.frame(raw.scaled), 
          by=list(cluster=clusters), median) 

## 프로파일링: 원래 데이터 활용
aggregate(raw2, by=list(raw2$group), median) 
aggregate(raw, by=list(cluster=clusters), median) 

## 그룹명칭 부여 
raw2$group.f <- factor(raw2$group, ordered = TRUE,
                       levels = c(4, 3, 5, 1, 2),
                       labels = c("1:Superplus", "2:Prime",
                                   "3:Platinum", "4:Starclass", 
                                   "5:Vclub"))
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
# caret이 추천하는 다양한 패키지를 함께 설치하기 위해서
# dependencies = TRUE 옵션을 사용함

install.packages("caret", dependencies = TRUE)
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
      pch=c(1, 2, 3, 4, 5)[raw2$group.f], 
      col=c(1, 2, 3, 4, 5)[raw2$group.f])

### End of Source #####################################################
