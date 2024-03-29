# 패키지 설치
if (!require(dplyr))     install.packages("dplyr")
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(stringr))   install.packages("stringr")
if (!require(memoise))   install.packages("memoise")
if (!require(KoNLP))     install.packages("KoNLP")
if (!require(wordcloud)) install.packages("wordcloud")
if (!require(extrafont)) install.packages("extrafont")

# 패키지 로드
library(dplyr)
library(readr)        # 파일 읽기 기능 제공 (tidyverse패키지에 포함됨)
library(stringr)      # 문자열 관련 기능 제공 패키지
library(rJava)        # KoNLP가 의존함 (Java기능 호출 패키지)
library(memoise)      # KoNLP가 의존함
library(KoNLP)        # 한글데이터 형태소 분석 패키지 (이름 대소문자 주의)
library(wordcloud)    # 워드클라우드 생성 패키지
library(RColorBrewer) # 색상 제어 패키지
library(extrafont)    # 폰트관리 패키지

# 폰트 스캔
font_import(pattern="NanumGothic.ttf")
loadfonts(device="win")       # Windows
fonts <- fonttable()
unique(fonts$FamilyName)

# 데이터 로드
news_train <- read_csv("C:/Users/user/Desktop/open/news_train.csv")
str(news_train)

# 뉴스 개수
df_uniq <- unique(news_train$n_id)
length(df_uniq)

# 결측치 확인
sum(is.na(news_train))

# 중복된 content 제거
news_train_2 = news_train[-which(duplicated(news_train$content)),]

# info(label) 비율 확인
table(news_train_2$info)

text = news_train_2$content

# 사전 사용
useNIADic()

# \\W은 특수문자를 의미하는 정규식
text <- str_replace_all(text,"\\W"," ")
head(text)

# 명사 추출 연습
nouns <- extractNoun(text)
head(nouns)

# 결과가 list로 추출되는데 이를 vector형태로 변환
words <- unlist(nouns)
head(words)

# 2글자 이상 문자만 필터
filtered <- Filter(function(x) {nchar(x) >= 2}, words)
head(filtered)

# 특수기호, 영어, 숫자 제거
filtered <- str_replace_all(filtered,"[^[:alpha:]]","")
filtered <- str_replace_all(filtered,"[A-Za-z0-9]","")
head(filtered)

# 빈도를 조사해보자
wordcount <- table(filtered)
head(wordcount)

# 빈도를 가지고 있는 데이터를 data frame으로 변환
df <- as.data.frame(wordcount, stringsAsFactors = F)
head(df)

# 두 글자 이상 단어 추출
result_df <- filter(df, nchar(filtered) >= 2)
head(result_df)

# 워드 클라우드 만들기
pal <- brewer.pal(8,"Dark2")
# 랜덤값 고정 -> 실행시마다 동일한 모양으로 생성되도록 함
set.seed(1234)

# 워드클라우드 생성
wordcloud(words = result_df$filtered,    # 단어
          freq = result_df$Freq,     # 빈도
          min.freq = 3,             # 최소 단어 빈도
          max.words = 100,          # 표현 단어 수
          random.order = FALSE,     # 고빈도 단어 중앙 배치
          random.color = FALSE,     # 색상으로 빈도 표현 여부
          colors = pal,             # 색깔 목록
          family="NanumGothic")     # 사용할 폰트
