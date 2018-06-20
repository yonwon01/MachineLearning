###################################################################
## 비교차이(A/B테스트)와 예측분석(prediction)

## A/B/n Test
# - 비교대상 액션아이템 중에서 목표로하는 성과를 가져다 주는 것이 
#   어떤 아이템인지를 성과차이를 비교해 선택하는 문제유형 
# - 목표로 하는 성과의 달성 여부를 어떤 기준을 가지고 할 것인가?
# - Y/N(이항형), Norminal(다항형), Ordinal(서열형), Average(평균형)의
#   4가지 기준을 통해 액션아이템의 성과를 비교분석함
# - 이 중에서 Y/N(이분형), Norminal(다항형), Ordinal(서열형) 기준으로
#   아이템의 성과를 비교할 때 비율분석/카이자승 분석이 중심
# - 이 중에서 Average(평균형) 기준으로 아이템의 성과를 비교할 때
#   T검정(t.test), 분산분석(anova)이 중심

## Prediction Test
# - 테스트된 아이템을 가지고 실제로 액션을 취했을 때 
#   아이템의 성과가 어떤조건에 따라 달라지는지를 판단하는 문제유형 
# - 테스트된 아이템을 가지고 실제로 액션을 취했을 때 왜 성과차이가 나는가?
# - Y/N(이분형), Norminal(다항형)->이분형을 조금 더 풀어 놓은것(어떤 조건에서 그러한 결과가 낫는지 몇가지 항목을 두는것 ) , Ordinal(서열형)->ex)기계 다운이 되서 복구했을때 시간대를 계산했을때 기계마다 복구시간의 서열, Average(수치형)의
#   4가지 성과를 다르게 발생시키는 조건/요인/속성/변수/기준/피처(feature)와 
# - 이들이 가지는 임계치(성과다 달라지는 경계값)을 도출함
# - 피처 + 임계치 = 규칙

# - 이중에서 Y/N(이분형), Norminal(다항형), Ordinal(서열형) 성과를 
#   발생시키는 규칙을 찾는 문제를 분류예측(classification)이라고 함
# - 그리고 Average(평균형) 성과를 발생시키는 규칙을 찾는 문제를
#   회귀예측(regression)이라고 함

##################################################################################
## 분류분석(classification)
#  - 사전에 정해진 유형으로 고객을 구분하는 규칙을 도출함
#  - 사전에 정해진 유형 중에서 목표로 하는 고객유형도 있으며,
#    그렇지 않은 고객유형도 있음
#  - 이들을 구별할 수 있는 기준/규칙/피처(feature)/속성/변수, 
#    즉 속성변수와 그 임계치를 알아 낼 수 있다면, 
#    목표고객을 대상으로 마이크로 타겟팅이 가능해짐

#  - (cf) 군집분석은 사전에 정해진 유형없이 고객을 그룹핑하는데
#    관련될 것으로 판단되는 속성변수들을 군집분석 알고리즘에 투입해
#    이들 변수의 변화량 특성을 고려해 군집을 나누는 것임
#    ==> 비지도학습, 자율학습: Unsupervised Learning(투입/독립변수만 있음)
#    ==> 패턴, 구조 발견(pattern discovery, feature extraction )
#    ==> 기존의 유형화에 속한 연관(association)분석, 
#        주성분(principal component)/요인(factor)분석 등도 비지도학습에 속함

#  - 반면에 분류분석에서는 비즈니스 측면에서 중요한 고객의 유형이
#    사전에 정해져 있어야 하며, 고객 속성변수의 변화에 따라 고객 유형별
#    분류데이터가 미리 준비되어 있어야 함
#    ==> 지도학습: Supervised Learing(투입/독립변수와 결과/종속변수 변화파악)
#    ==> 예측분석(prediction)

#  - (cf) 강화학습(Reinforcement Learning)은 분석가가 모델링을 통해 
#    선정된 변수들만을 투입해 규칙/피처(feature)를 찾는 것이 아니라 
#    알고리즘이 탐색을 통해서 피처를 선정 찾아내 투입/반복하면서, 점점더 강한 예측력을 가진 
#    알고리즘으로 업그레이드됨

####################################################################
## A/B테스트와 분류분석을 통한 동일한 문제에 대한 차별적 접근

# A/B 테스트를 통해 선정한 아이템을 가지고 
# 고객 100명에게 액션을 취했을 때 반응이 10명정도 나왔다. 
# 이 성과를 20%로 높일 수 있는 방법은?

# (1) <A/B테스트 방식> 또다른 대안 C, D 등를 만들어 
# A/B 테스트를 진행해 목표로하는 20% 성과가 나오는 아이템을 선정함

# (2) <분류분석 방식> 액션대상인 고객 중에서 반응을 보일 것으로 예상되는 
# 50명한테만 액션을 취해서 10명 정도의 반응을 이끌어 내면 20%가 달성됨

####################################################################
## 비즈니스 시나리오
# - 카드사 이용고객 중 쿠폰이벤트를 진행했을 때 반응을 보이는 고객과
#   그렇지 않은 고객으로 나뉘고 있음
# - 어떤 특성을 가진 고객이 쿠폰이벤트에 반응을 보이는지?
# - 어떤 특성을 가진 고객이 쿠폰이벤트에 반응을 보이지 않는지?
# - 반응 유무를 결정하는 조건/요인/속성/변수/기준/피처(feature)와 
#   이들이 가지는 임계치와 상대적인 중요도는?

## 분석 모델링 및 조작적 정의
# usage(월평균 카드사용횟수) --> 수치데이터(횟수)
# amount(1회평균 카드사용금액) --> 수치데이터(만원)
# period(1회평균 온라인쇼핑몰 접속시간) --> 수치데이터(분)
# variety(상품구매다양성) --> 수치데이터(부문)
# response(쿠폰반응유형) --> 0:nr(반응안함, no-response)
#                        --> 1:low(단순/저가구매)
#                        --> 2:high(복합/고가구매)

###################################################################
## raw 데이터 준비

raw <- read.csv("myclass.csv", header=T, sep=",",
                stringsAsFactors = F, # 팩터화 없이 일반적 로딩 
                strip.white = T, # 데이터 요소별 좌우 공백 제거 
                na.strings = "") # 데이터 중 ""표시부분 NA로 인식

###################################################################
## 데이터 정보조회
head(raw) 

## 간단조회
str(raw) 
summary(raw)

## 기존 쿠폰반응 데이터인 response변수를 요인변수로 만들고, 
## 별도 레이블 반영

raw$response <- factor(raw$response, 
                       levels=c(2, 1, 0), 
                       labels=c("high", "low", "nr")) 

#######################################################################
## 사전 분류규칙 존재가능성 탐색
boxplot(raw[1:4], 
        main="고객구매이력 변수간 데이터분포 비교")

# 2개 변수간 관련성 분석
plot(raw$amount, raw$usage, 
     pch=as.numeric(raw$response), col=as.numeric(raw$response))
# plot에서는 150명 관찰치별로 일일히 플로팅캐릭터와 색상을 지정해주어야 함
# 그래서 as.numeric으로 150개 관찰치 별로 수치화를 한 것임
legend("topleft", legend=levels(raw$response), 
       pch=unique(raw$response), col=unique(raw$response))
# 레전드에서는 150개가 아니라 이들을 대표하는 3개 클래스에 대한
# 데이터만 있으면 되므로 unique()로 값을 구한 것임

# 투입변수간 관련성 분석
pairs(~ usage + amount + variety + period, data=raw, 
      pch=c(1, 2, 3, 4, 5)[raw$response], 
      col=c(1, 2, 3, 4, 5)[raw$response])

## -----------------------------
## caret패키지의 featurePlot() 기능이용
install.packages("caret")
library(caret)

install.packages("ellipse")
library(ellipse) 
# 보통 패키지 설치시 종속된 패키지가 같이 설치되는데,
# caret의 경우 이 패키지가 없어서 작동에 에러가 나는 경우가 있음
# 그래서 caret 설치/로딩시 ellipse나 e1071과 같은 패키지도
# 같이 설치/로등하는 것이 필요함
# ellipse: caret의 featurePlot()에서 plot = "ellipse"에 필요한 패키지
# e1071: caret의 train()에서 피처 선택할 때 필요한 패키지

featurePlot(x = raw[ , c(1:4)], y = raw$response, 
            plot = "pairs", 
            auto.key = list(columns = 3)) # 상단범례표시 

featurePlot(x = raw[ , c(1:4)], y = raw$response, 
            plot = "density",
            scales = list(x = list(relation="free"),
                          y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(4, 1),
            auto.key = list(columns = 3)) # 상단범례표시

featurePlot(x = raw[ , c(1:4)], y = raw$response, 
            plot = "box",
            scales = list(y = list(relation="free"),
                          x = list(rot = 90)),
            layout = c(4, 1))

featurePlot(x = raw[ , c(1:4)], y = raw$response, 
            plot = "ellipse",
            auto.key = list(columns = 3)) # 상단범례표시

# 아래 패키지를 사용하면 플로팅되는 점들의 투명도가 변경됨
install.packages("AppliedPredictiveModeling")
library(AppliedPredictiveModeling)
transparentTheme(trans = .4)
# - 바로 위 featurePlot()들을 다시실행

## -----------------------------
## car 패키지의 scatterplotMatrix() 기능 이용
install.packages("car")
library(car)

# 분류모델에 사용한 4개 투입변수와 1개 결과변수간 산점도 그림
scatterplotMatrix(raw)

# 결과변수인 response변수에 따른 4개변수에 대한 변화 비교 그래프
scatterplotMatrix(~ usage + amount + period + variety | response, data=raw)

# 두개 변수간 관계 중심데이터 표시, 타원을 벗어나는게 이상치로 보면됨
scatterplotMatrix(~ usage + amount + period + variety | response, data=raw,
                  ellipse=TRUE)

# 원래 추세선이 response와 상관없이 전체적으로 보여주었으나
# 이 옵션을 통해 직업유형별 별도 추세선을 보여 줌
scatterplotMatrix(~ usage + amount + period + variety | response, data=raw,
                  by.group=TRUE)

# 4개 변수의 분포모양(+)이 왜도가 오른쪽 꼬리분포임
# 그래서 이를 정규분포형태로 변환해서 노이즈를 제거해 산점도를 그림
scatterplotMatrix(~ usage + amount + period + variety | response, data=raw,
                  transform=TRUE)

###################################################################
## 분류규칙에 가장 영향을 많이 미치는 변수는 무엇인지를 탐색분석
install.packages("FSelector")
library(FSelector)

chi.squared(response ~ usage + amount + period + variety, data=raw)
chi.squared(response ~ ., data = raw) # formula 축약버전

x <- chi.squared(response ~ usage + amount + period + variety, data=raw)
cutoff.k(x, 1)
cutoff.k(x, 2)
cutoff.k(x, 3)
cutoff.k(x, 4)

###################################################################
#### 분류분석용 데이터 추출

## 랜덤넘버 생성
set.seed(1234)

## 학습(트레이닝) & 검증(테스트) 데이터 추출
index <- sample(1:NROW(raw), nrow(raw)*0.7, replace=F)
index

## 학습 & 검증 데이터 정보조회
trainD <- raw[index, ]
testD <- raw[-index, ]

head(trainD)
head(testD)
nrow(trainD); nrow(testD)
table(trainD$response)
table(testD$response)

###################################################################
#### 분류분석 실시

## 분류분석 패키지 설치 및 로딩
install.packages("party")
library(party)

## 분류분석 모델 관계식 정의
f <- response ~ usage + amount + period + variety

## 학습데이터를 이용한 분류규칙 생성
rule <- ctree(f, data=trainD)
rule

## 분류규칙 그래프 그리기
plot(rule)
plot(rule, type="simple")

## --------------------------------------------
## 분류규칙을 이용한 학습(train)데이터 분류분석
train.out <- predict(rule)
train.out # 학습데이터 개별 관찰치를 분류규칙을 통해 분류해 봄

## 학습데이터 response 패턴과 분류규칙 분류패턴간 교차분석
train.result <- table(trainD$response, train.out, 
                dnn=c("Actual", "Training"))
train.result
addmargins(train.result) 
# 원래 학습(tainD)데이터 존재하는 실제 response 패턴과
# 학습데이터에서 도출한 분류규칙을 이용해 학습데이터를 분류해보고 
# 이들간의 교차분석을 통해 분류규칙의 적용가능성을 파악

## 학습(train)데이터 분류결과 정확성(Accuracy) 평가
sum(train.result) 
diag(train.result) 
sum(diag(train.result))/sum(train.result) 

###################################################################
## 검증(test)데이터에 대한 분류분석
test.out <- predict(rule, newdata=testD)
test.out # 학습데이터 개별 관찰치를 분류규칙을 통해 분류해봄

## 검증데이터 response 패턴과 분류규칙 분류패턴간 교차분석
test.result <- table(testD$response, test.out)
test.result
addmargins(test.result)
# 원래 검증(testD)데이터 존재하는 실제 response 패턴과
# 학습데이터에서 도출한 분류규칙을 이용해 검증데이터를 분류해보고 
# 이들간의 교차분석을 통해 분류규칙에 대한 재검증(크로스체크)을 실시함

## 검증(test)데이터 분류결과 정확성(Accuracy) 평가
sum(test.result) 
diag(test.result) 
sum(diag(test.result))/sum(test.result) 

###################################################################

# 학습(tain)데이터와 검증(test)데이터 정확성 비교
x <- sum(diag(train.result))/sum(train.result) 
y <- sum(diag(test.result))/sum(test.result) 

compare <- c(x, y)
names(compare)[1] <- "trainAccuracy"
names(compare)[2] <- "testAccuracy"

compare
round(compare*100, 2)


###################################################################
## 도출된 규칙을 활용한 고객추출
rawA <- subset(raw, amount > 1.9 & period > 1.7)
rawA

rawB <- subset(raw, amount > 1.9 & period <= 1.7)
rawB

rawC <- subset(raw, amount <= 1.9)
rawC

library(psych)
psych::describe(rawA)
psych::describe(rawB)
psych::describe(rawC)

###################################################################
## 또 다른 의사결정나무 알고리즘은 rpart 패키지 이용

install.packages("rpart")
library(rpart)

rt1 <- rpart(response ~ usage + amount + period + variety, 
              data = raw, method = "class")
print(rt1, digit = 2)
summary(rt1)

library(psych)
pairs.panels(raw, main = "Pairs Diagram")

plot(rt1, branch=0.6, margin=0.05, 
     main="Classfication Tree plot")

text(rt1, use.n=T, all=T, cex=0.7)

### End of Source #####################################################
