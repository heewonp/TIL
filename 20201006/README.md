# 2020.10.06 배운내용

## 1. sqllite

> 파이썬에서는 기본적으로 SQLITE3가 제공이 된다.

### 2. 사용 방법

```python
import sqlite3

conn = sqlite3.connect('test.db')

conn.excute('create table test_db(id intger, name text)')
```

1. 라이브러리를 불러와준다

2. 기존에 test.db 파일(데이터 베이스)이 없다면 새롭게 생성하고 연결, 있다면 연결을 해준다.

3. 테이블을 새로 만들어 준다.

   > 테이블 형식 : create table `테이블명`(컬럼1, 타입, 컬럼2 ,타입,... 컬럼n,타입)

### 3.  커서와 데이터 추가

```python
curr = conn.cursor()

cur.execute("insert into test_db values ('a',100)")

data = [('a',100), ('b',200)]
cur excutemany('insert into test_db values(?,?),data')

cur.executemany(
'insert into test_db values (?, ?, ?, ?, ?)',
    [(1, 'gildong', 'gd', 'marketing', '2020-10-06 10:36:00.000'),
     (2, 'sunshin', 'ss', 'marketing', '2019-10-06 10:36:00.000'),
     (3, 'yusin', 'ys', 'development', '2020-01-06 10:36:00.000')
    ]
)
```



1. 커서를 가져와야 파일을 읽고 쓸 수 있다.
2. 데이터 한건을 넣으려면 cur.**excute** ~~ 하여 직접 데이터를 넣으면 된다.
3. 튜플이나 리스트 형태의 데이터들을 한 번에 넣으려면 cur.**executemany** ~~ 사용하여 데이터를 넣으면 된다.



### 4. 데이터 가져오기

```python
cur.execute('select * from test_db') 

for row in cur:
    print(row)
    
cur.execute('select * from test_db') 
rows=cur.fetchall()
```

1. `test_db` 테이블로 부터 모든 데이터를 가져오라는 뜻이다.
2. 커서가 가리키고 있는 위치로부터 데이터를 하나씩 읽어 내려가면서 row에 저장
3. 전체를 가져와서 출력 해주는 것이다.

### 5. 데이터 수정

```python
cur.execute("update test_db set id=00 where name='sunshin'")
```

1. update `테이블명` set 컬럼 = 변경값 where 조건식

> 테이블로부터 조건식에 해당되는 데이터의 컬럽 값을 변경값으로 바꾸어 준다.

### 6. 데이터 삭제

```python
conn.execute('drop table emp_data')
```

1. drop table `테이블명`

### 7. DB 연결 해제

```python
conn.commit()
conn.close()
```

1. 데이터 베이스 저장
2. 데이터베이스 연결 종료

### 8. pandas 와 sqlite3

> 앞에서 불러온 table들의 데이터를 가지고 데이터 프레임을 만들 수 있다. (자세한 것은 주피터 노트북 참고)

```python
pd.DataFrame.from_records(data=rows, columns=cols)
```

1. **DataFrame.from_records** 를 이용해 튜플의 리스트 형태로 가져온 테이블 데이터를 읽어 데이터 프레임으로 만들어 준다. 

#### 8-1 pandas 데이터 프레임을 sqlite 테이블로 저장 하기

```python
data={'c1':[1,2,3],
     'c2':[11,21,31],
     'c3':[12,22,32]}

df=pd.DataFrame(data)

conn=sqlite3.connect('cvTable.db')

df.to_sql('mytable', conn)

cur.execute("select c1,c2 from mytable")

cur.fetchall()
```

1. 데이터 프레임을 만들어준다.
2. 만든 데이터 프레임을 cvTable데이터 베이스의 mytable 테이블로 저장 해준다.



## 2. R

> cran.r-project.org <br>
> https://rstudio.com/ <br>
>
> 에서 각각 r과 r을 사용할 수 있는 툴을 설치해 준다.

### 1. package 설치

```R
install.packages("readxl")
library(readxl)
```

- library(readxl)를 해주어야 라이브러리 적용이 된다.
  - python에서는 pip install ~~, import aaa as a 이것과 같다

#### 만약 packge 설치시에 경로에 ?? 가뜨면서 안될경우

1.  `.libPaths()` 를 입력해 현재 저장되는 위치를 확인
2. R이 설치된 경로 / ect 폴더에 Rprofile.site를 열어준다.
3. 맨 마지막 줄에  **.libPath("라이브러리 저장하고 싶은 경로")** 를 추가해준다.
4.  파일을 저장하고 R 스튜디오를 재시작 해준다.
   - 참고한 블로그 : https://m.blog.naver.com/rickman2/221449799786

### 2. 기본 문법

1. 데이터 프레임 $ 컬럼명

```R
mean(df $ eng)
```

2.  file 읽기

```R
read_excel("Data/excel_exam.xlsx")
```

3.  csv 파일 포멧으로 저장

``` R
write.csv(data, file="savefile.csv")
```

4.  구조 확인 `str`

``` R
str(data) 
```

5. filtering

``` R
md+shift+m (%>% pipeline)
```

6. ifelse를 중첩시켜서 조건문을 완성

``` R
reexam$hakjum<-ifelse(reexam$math<=50, "C",
   				ifelse(reexam$math<=80, "B", "A"))
```

7. 정렬

```R
exam %>%
     arrange(math) #sort: default ascending
```

8. 새로운 컬럼 추가(mutate)

``` R
exam %>% 
     mutate(total=math+english+science,
            mean=total/3) %>% 
     head
```

9. 집계(summarise)

``` R
exam %>% 
     group_by(class) %>% 
     summarise(mean_math=mean(math),
               sum_math=sum(math),
               median_math=median(math),
               n=n())
```

   * n =n python의 value_counts() 와 비슷 그룹으로 묶인것의 개수를 구해줌..



#### 자세한 내용은 주피터 노트북과 R 파일을 참고!