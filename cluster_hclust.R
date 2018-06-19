######## 데이터 축소화 분석(data reduction):
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
# - 요인분석(Factor Analysis)

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

#######################################################################
## 기여패키지를 활용한 예제 데이터 준비

install.packages("flexclust") # 기여패키지 인스톨
library(flexclust) # 기여패키지 로딩

library(help=flexclust) # 패키지 간략 도움말 확인
help(package=flexclust) # 패키지 도움말 파일 확인


#R에들어있는 데이터 목록 확인하고 쓰는것 
data(package="flexclust") # 패키지내 데이터셋 목록 확인
data(nutrient, package="flexclust") # 패키지내 특정 데이터셋 한개 로딩
# 특히 여러 기여패키지에 nutrient라는 데이터셋이 존재할 수 있으므로
# 이를 flexclust라는 패키지에서 가져온다는 것을 명시적으로 표시한 것임

#######################################################################
#### nutrient 데이터셋 
# 27종의 생선(fish), 가금류(fowl), 육류(meat)에 대한
# 영양소(nutrient) 데이터셋
# energy(열량), protein(단백질), fat(지방), 
# calcium(칼슘), iron(철분) 등의 데이터 포함

## 데이터셋 간략 스캐닝
head(nutrient)
install.packages("psych")
library(psych)
headTail(nutrient)
nutrient

## 내부구조 파악
str(nutrient)

## 요약기술통계 확인
summary(nutrient)

## 군집분석용 투입변수에 대한 기술통계분석 
psych::describe(nutrient)

## 5개 영양소 변수컬럼별 박스플롯 그래프
boxplot(nutrient) 
# 데이터 규모/범위/단위가 달라 표준화 작업이 필요해 보임
# 또한 일부 이상치가 존재하지만 실제 관찰치이므로 그대로 사용

#######################################################################
#### 각 관찰치간 거리구하기

## 소수점 출력자리수 설정
options(digits=3)

## 유클리드 거리(Euclidean distance): 공간에서 두 점 사이 거리계산방법
# 거리값이 작을수록 유사성 큼 == 비유사성 작음
# 거리값이 클수록 유사성 작음 == 비유사성 큼

dist(nutrient) # 27종의 관찰치간 거리계산
d <- dist(nutrient)
as.matrix(d)[1:2, 1:2] # 2개 관찰치간 거리계산 값을 조회
as.matrix(d)[1:4, 1:4] # 4개 관찰치간 거리계산 값을 조회

## 행이름 소문자로(단순변환)
row.names(nutrient) <- tolower(row.names(nutrient))

## 군집분석 전에 각 변수컬럼의 상대적인 규모/범위를 고려해 표준화실시
nutrient.scaled <- scale(nutrient)                                  
head(nutrient.scaled)

## 표준화된 영양소 데이터를 이용해 각 관찰치간 거리계산
d <- dist(nutrient.scaled)
as.matrix(d)[1:2, 1:2] # 2개 관찰치간 거리계산 값을 조회
as.matrix(d)[1:4, 1:4] # 4개 관찰치간 거리계산 값을 조회

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


#### 계층적 군집분석 방법간 비교
# - 연결방법에 따라 다르게 군집화가 실시되며
#   보다 군집의 유형이 뚜렷한 형태를 찾음

fit.average <- hclust(d, method="average")
fit.single <- hclust(d, method="single")
fit.complete <- hclust(d, method="complete")
fit.ward.D <- hclust(d, method="ward.D")
fit.ward.D2 <- hclust(d, method="ward.D2")

par(mfrow = c(2, 3))

plot(fit.average, hang=-1, cex=.8, 
     main="평균연결법을 활용한 계층적 군집분석")
plot(fit.single, hang=-1, cex=.8, 
     main="최단연결법법을 활용한 계층적 군집분석")
plot(fit.complete, hang=-1, cex=.8, 
     main="최장연결법을 활용한 계층적 군집분석")
plot(fit.ward.D, hang=-1, cex=.8, 
     main="Ward.D방법을 활용한 계층적 군집분석")
plot(fit.ward.D2, hang=-1, cex=.8, 
     main="Ward.D2방법을 활용한 계층적 군집분석")

par(mfrow = c(1, 1))

#######################################################################
#### 계층적 군집분석의 적정 군집갯수 선정

install.packages("NbClust") # 패지키 이용
library(NbClust)
nc <- NbClust(nutrient.scaled, distance="euclidean", 
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
rect.hclust(fit.average, k=5)

## 5개로 군집분할
clusters <- cutree(fit.average, k=5)
clusters # 27종의 관찰치별로 어떤 군집에 속하는지 확인
table(clusters) # 5개 군집별로 속해 있는 관찰치 갯수 확인

## 기존 데이터셋에 그룹표시 변수컬럼 추가
nutrient2 <- data.frame(nutrient, group=clusters)
head(nutrient2)

## 군집그룹별 소팅
nutrient2[order(nutrient2$group), ]

#######################################################################
#### 각 군집별 특성파악(프로파일링)
# 프로파일링: 각 군집의 평균적인 특징을 별도로 파악하는 것
# 프로파일링방법: 군집분석에 사용한 변수컬럼들의 평균값을 구해보면 됨
# 프로파일링의 최종적으로 각 군집에 적정한 그룹명칭을 부여해 주면 좋음

## 프로파일링: 표준화된 데이터 활용 
aggregate(as.data.frame(nutrient.scaled), 
          by=list(cluster=clusters), median) 

## 프로파일링: 원래 데이터 활용
aggregate(nutrient, by=list(cluster=clusters), median) 

## 그룹명칭 부여
nutrient2$group.f <- factor(nutrient2$group, levels = c(1, 2, 3, 4, 5),
                          labels = c("1: fat-energy",
                                     "2: protein",
                                     "3: iron-protein",
                                     "4: iron-calcium",
                                     "5: calcium-protein"))
tb <- table(nutrient2$group.f)
tb
as.data.frame(tb)

#######################################################################
## caret패키지의 시각화 기능이용 그래프 그리기
install.packages("caret", dependencies = TRUE)
# caret이 추천하는 다양한 패키지를 함께 설치하기 위해서
# dependencies = TRUE 옵션을 사용함

library(caret)

featurePlot(x = nutrient2[ , c(1:5)], y = nutrient2$group.f, 
            plot = "pairs", 
            auto.key = list(columns = 3)) # 상단에 한줄당 범례표시갯수 

featurePlot(x = nutrient2[ , c(1:5)], y = nutrient2$group.f, 
            plot = "density",
            scales = list(x = list(relation="free"),
                          y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(5, 1),
            auto.key = list(columns = 3)) # 상단에 한줄당 범례표시갯수

featurePlot(x = nutrient2[ , c(1:5)], y = nutrient2$group.f, 
            plot = "box",
            scales = list(y = list(relation="free"),
                          x = list(rot = 90)),
            layout = c(5, 1))

pairs(~ energy + protein + fat + calcium + iron, data=nutrient2, 
      pch=c(1, 2, 3, 4, 5)[nutrient2$group.f], 
      col=c(1, 2, 3, 4, 5)[nutrient2$group.f])

### End of Source #####################################################