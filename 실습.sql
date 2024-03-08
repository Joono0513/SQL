-- Active: 1709599448951@@127.0.0.1@1521@orcl@SYSTEM
-- 1. system 계정에 접속하는 SQL
conn system/1234

-- 2. HR 계정이 있는지 확인하는 SQL
SELECT *
FROM all_users
WHERE username = 'HR'
;

-- HR이 있을 때, 계정 잠금 해제
ALTER USER HR ACCOUNT UNLOCK;

-- HR이 없을 때, 계정 생성
-- c## 없이 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USER HR IDENTIFIED BY 123456;
-- 테이블 스페이스 변경
ALTER USER HR DEFAULT TABLESPACE users;
-- 계정이 사용할 수 있는 용량 설정 (무한대)
ALTER USER HR QUOTA UNLIMITED ON users;
-- 계정에 권한 부여 
GRANT connect, resource TO HR;

-- 계정 삭제
DROP USER HR CASCADE;

-- 3. employees 테이블의 구조 조회하는 명령
DESC employees;

SELECT employee_id, first_name
FROM employees;

-- 4. 
-- AS (Alias) : 출력되는 컬럼명에 별명을 짓는 명렁어
-- * 생략 가능
-- AS 사원번호      : 별칭 그대로
-- AS "사원 번호"   : 띄어쓰기가 있으면 ""로 감싸서 작성
-- AS '사원 번호'   : (에러)
SELECT employee_id AS "사원 번호"
    , first_name AS 이름
    , last_name AS 성
    , email AS 이메일
    , phone_number AS "전화 번호"
    , hire_date AS "입사 일자"
    , salary AS 급여
FROM employees;

-- 모든 컬럼 조회 : (*) [에스터리크]
SELECT *
FROM employees;

SELECT job_id
FROM employees;

-- 5.
-- 테이블 employees의 job_id를 중복된 데이터로 제거하고
-- 조회하는 SQL 문을 작성하시오
SELECT DISTINCT job_id
FROM employees;

-- 6.
-- 테이블 employees의 salary(급여)가 6000을 초과하는 사원의 
-- 모든 컬럼을 조회하는 SQL문을 작성하시오
SELECT *
FROM employees
WHERE salary > 6000;

-- 7.
-- 테이블 employees의 salary가 10000인 사원의 모든 컬럼을
-- 조회하는 SQL문을 작성하시오.
SELECT *
FROM employees
WHERE salary = 10000;

-- 8.
-- 테이블 employees의 모든 속성들을 salary를 기준으로 내림차순 정렬하고
-- first_name을 기준으로 오름차순 정렬하여 조회하는 SQL문을 작성하시오

-- 정렬
-- ORDER BY 컬럼명 [ASC/DESC];
-- * ASC    : 오름차순
-- * DESC   : 내림차순
-- * (생략)  : 오름차순이 기본값

SELECT *
FROM employees
ORDER BY salary DESC,
first_name ASC;

-- 9.
-- 테이블 employees의 job_id가 'FI_ACCOUNT' 이거나
-- 'IT_PROG'인 사원의 모든 칼럼을 조회하는 SQL문을 작성하시오
-- 조건연산
-- OR 연산 : ~또는, ~이거나
-- WHERE A OR B;
SELECT * 
FROM employees
WHERE job_id = 'FI_ACCOUNT' 
OR job_id = 'IT_PROG';

-- 10.
-- 테이블 employees의 job_id가 'FI_ACCOUNT' 이거나
-- 'IT_PROG'인 사원의 모든 칼럼을 조회하는 SQL문을 작성하시오
-- 조건
-- IN 키워드 사용
SELECT *
FROM employees
WHERE job_id
IN ('FI_ACCOUNT', 'IT_PROG');

-- 11.
-- 테이블 employees의 job_id가 'FI_ACCOUNT' 이거나
-- 'IT_PROG'이 아닌 사원의 모든 칼럼을 조회하는 SQL문을 작성하시오
-- 조건
-- IN 키워드 사용
SELECT *
FROM employees
WHERE job_id
NOT IN ('FI_ACCOUNT', 'IT_PROG');

-- 12.
-- 테이블 EMPLOYEES 의 JOB_ID가 ‘IT_PROG’ 이면서 
-- SALARY 가 6000 이상인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT *
FROM employees
WHERE job_id = 'IT_PROG'
AND salary >= 6000;

-- 13.
-- 테이블 EMPLOYEES 의 FIRST_NAME 이 ‘S’로 시작하는 
-- 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
-- LIKE
-- '_' : 한 글자 대체
-- '%' : 여러 글자 대체
SELECT *
FROM employees
WHERE first_name
LIKE 'S%';

-- 14.
-- 테이블 EMPLOYEES 의 FIRST_NAME 이 
-- ‘s’로 끝나는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT *
FROM employees
WHERE first_name
LIKE '%s';

-- 15.
-- 테이블 EMPLOYEES 의 FIRST_NAME 에 
-- ‘s’가 포함되는 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT *
FROM employees
WHERE first_name
LIKE '%s%';

-- 16.
-- 테이블 EMPLOYEES 의 FIRST_NAME 이 5글자인 사원의 
-- 모든 컬럼을 조회하는 SQL 문을 작성하시오.
-- first_name LIKE '_____';
-- LENGTH(first_name) = 5;
SELECT *
FROM employees
WHERE first_name
LIKE '_____';

SELECT *
FROM employees
WHERE LENGTH(first_name) = 5;

-- 17.
-- 테이블 EMPLOYEES 의 COMMISSION_PCT가 
-- NULL 인 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT *
FROM employees
WHERE commission_pct
IS NULL;

-- 18.
-- 테이블 EMPLOYEES 의 COMMISSION_PCT가 
-- NULL이 아닌 사원의 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT *
FROM employees
WHERE commission_pct
IS NOT NULL;

-- 19.
-- 테이블 EMPLOYEES 의 사원의 HIRE_DATE가
-- 04년 이상인 모든 컬럼을 조회하는 SQL 문을 작성하시오.
-- DATE >= 문자열 >> To_DATE() 날짜형 데이터로 암시적 형변환
-- 1) 문자열 --> 암시적 형변환 하여 조회
SELECT *
FROM employees
WHERE hire_date >= '01/JAN/04'; 
-- * 데이터의 월 값이 숫자면 --> '01/01/04'
-- * 데이터의 월 값이 문자면 --> '01/JAN/04'

-- 2) TO_DATE 함수로 변환하여 조회
SELECT *
FROM employees
WHERE hire_date >= TO_DATE('04/01/01', 'YY/MM/DD')
ORDER BY hire_date ASC;

-- 20.
-- 테이블 EMPLOYEES 의 사원의 HIRE_DATE가 
-- 04년도부터 05년도인 모든 컬럼을 조회하는 SQL 문을 작성하시오.
SELECT *
FROM employees
WHERE hire_date >= '01/JAN/04'
AND hire_date <= '31/DEC/05';

SELECT *
FROM employees
WHERE hire_date >= TO_DATE('04/01/01', 'YY/MM/DD')
AND hire_date <= TO_DATE('05/12/31', 'YY/MM/DD');

-- 21.
-- 12.45, -12.45 보다 크거나 같은 정수 중
-- 제일 작은 수를 계산하는 SQL 문을 각각 작성하시오.
-- * dual?
-- : 산술 연산, 함수 결과 등을 확인해볼 수 있는 임시 테이블
SELECT CEIL(12.45), CEIL(-12.45)
FROM dual;

-- 22.
-- 12.55와 -12.55 보다 작거나 같은 정수 중
-- 가장 큰 수를 계산하는 SQL 문을 각각 작성하시오.
SELECT FLOOR(12.55), FLOOR(-12.55)
FROM dual;

-- 23.
-- 각 소문제에 제시된 수와 자리 수를 이용하여
-- 반올림하는 SQL문을 작성하시오.
-- 0.54 를 소수점 아래 첫째 자리에서 반올림하시오. → 결과 : 1
SELECT ROUND(0.54, 0)
FROM dual;
-- 0.54 를 소수점 아래 둘째 자리에서 반올림하시오. → 결과 : 0.5
SELECT ROUND(0.54, 1)
FROM dual;
-- 125.67 을 일의 자리에서 반올림하시오. → 결과 : 130
SELECT ROUND(125.67, -1)
FROM dual;
-- 125.67 을 십의 자리에서 반올림하시오. → 결과 : 100
SELECT ROUND(125.67, -2)
FROM dual;

-- 24.
-- 각 소문제에 제시된 두 수를 이용하여
-- 나머지를 구하는 SQL문을 작성하시오.
-- 3을 8로 나눈 나머지를 구하시오. → 결과 : 3
 SELECT MOD(3, 8)
 FROM dual;
-- 30을 4로 나눈 나머지를 구하시오. → 결과 : 2
SELECT MOD(30, 4)
FROM dual;

-- 25.
-- 각 소문제에 제시된 두 수를 이용하여
-- 제곱수를 구하는 SQL문을 작성하시오.
-- 2의 10제곱을 구하시오. → 결과 : 1024
SELECT POWER(2, 10)
FROM dual;
-- 2의 31제곱을 구하시오. → 결과 : 2147483648
SELECT POWER(2, 31)
FROM dual;

-- 26.
-- 각 소문제에 제시된 수를 이용하여
-- 제곱근을 구하는 SQL문을 작성하시오.
-- 2의 제곱근을 구하시오. → 결과 : 1.41421...
SELECT SQRT(2)
FROM dual;
-- 100의 제곱근을 구하시오. → 결과 : 10
SELECT SQRT(100)
FROM dual;

-- 27.
-- 각 소문제에 제시된 수와 자리 수를 이용하여
-- 해당 수를 절삭하는 SQL문을 작성하시오.
-- TRUNC(실수, 자리수)
-- : 해당 수를 절삭하는 함수
-- 527425.1234 을 소수점 아래 첫째 자리에서 절삭하시오.
SELECT TRUNC(527425.1234, 0)
FROM dual;
-- 527425.1234 을 소수점 아래 둘째 자리에서 절삭하시오.
SELECT TRUNC(527425.1234, 1)
FROM dual;
-- 527425.1234 을 일의 자리에서 절삭하시오.
SELECT TRUNC(527425.1234, -1)
FROM dual;
-- 527425.1234 을 십의 자리에서 절삭하시오.
SELECT TRUNC(527425.1234, -2)
FROM dual;

-- 28.
-- 각 소문제에 제시된 수를 이용하여
-- 절댓값을 구하는 SQL문을 작성하시오.
-- ABS(A)
-- : 값 A의 절댓값을 구하여 변환하는 함수
-- -20의 절댓값 구하기
SELECT ABS(-20)
FROM dual;
-- -12.456의 절댓값 구하기
SELECT ABS(-12.456)
FROM dual;

-- 29.
-- <예시>와 같이 문자열을 대문자, 소문자, 첫글자만 
-- 대문자로 변환하는 SQL문을 작성하시오.
-- _________________________________________________________________
-- |      원문     |     대문자     |     소문자    | 첫글자만 대문자 |
-- | AlOhA WoRlD~! | ALOHA WORLD~! | aloha world~! | Aloha World~! |
-- _________________________________________________________________
SELECT 'AlOhA WoRlD~!' AS 원문
        , UPPER('AlOhA WoRlD~!') AS 대문자
        , LOWER('AlOhA WoRlD~!') AS 소문자
        , INITCAP('AlOhA WoRlD~!') AS "첫 글자만 대문자"
FROM dual;

-- 30.
-- <예시>와 같이 문자열의 글자 수와 
-- 바이트 수를 출력하는 SQL문을 작성하시오.
-- <예시1>
-- 문자열 : 'ALOHA WORLD'
-- ________________________________
-- |    글자 수    |    바이트 수   |
-- |      11      |       11       |
-- _________________________________
SELECT LENGTH('ALOHA WORLD') AS "글자 수"
    , LENGTHB('ALOHA WORLD') AS "바이트 수"
FROM dual;

SELECT LENGTH('알로하 월드') AS "글자 수"
    , LENGTHB('알로하 월드') AS "바이트 수"
FROM dual;

-- 31.
-- 두 문자열 연결하기
-- <예시>와 같이 각각 함수와 기호를 이용하여 
-- 두 문자열을 병합하여 출력하는 SQL문을 작성하시오.
-- 문자열1 : ‘ALOHA’
-- 문자열2 : ‘WORLD’
SELECT CONCAT('ALOHA', 'CLASS') AS "함수"
    , 'ALOHA' || 'CLASS' AS "기호"
FROM dual;

-- 32. <예시>와 같이 주어진 문자열의 
-- 일부만 출력하는 SQL문을 작성하시오.
-- 문자열 부분 출력하기
-- SUBSTR(문자열, 시작 번호, 글자 수)
-- 'www.alohaclass.kr'
SELECT SUBSTR('www.alohaclass.kr', 1, 3) AS "1"
    , SUBSTR('www.alohaclass.kr', 5, 10) AS "2"
    , SUBSTR('www.alohaclass.kr', -2, 2) AS "3"
FROM dual;

SELECT SUBSTRB('www.alohaclass.kr', 1, 3) AS "1"
    , SUBSTRB('www.alohaclass.kr', 5, 10) AS "2"
    , SUBSTRB('www.alohaclass.kr', -2, 2) AS "3"
FROM dual;

SELECT SUBSTR('www.알로하클래스.com', 1, 3) AS "1"
    , SUBSTR('www.알로하클래스.com', 5, 6) AS "2"
    , SUBSTR('www.알로하클래스.com', -3, 3) AS "3"
FROM dual;

SELECT SUBSTRB('www.알로하클래스.com', 1, 3) AS "1"
    , SUBSTRB('www.알로하클래스.com', 5, 18) AS "2"
    , SUBSTRB('www.알로하클래스.com', -3, 3) AS "3"
FROM dual;

-- 33.
-- <예시>와 같이 문자열에서 
-- 특정 문자의 위치를 구하는 SQL문을 작성하시오.
-- INSTR(문자열, 찾을 문자, 시작 번호, 순서)
-- ex) 문자열 : ‘ALOHACLASS’
SELECT INSTR('ALOHACLASS', 'A', 1, 1) AS "1번째 A"
    , INSTR('ALOHACLASS', 'A', 1, 2) AS "2번째 A"
    , INSTR('ALOHACLASS', 'A', 1, 3) AS "3번째 A"
    , INSTR('ALOHACLASS', 'A', 1, 4) AS "4번째 A"
FROM dual;

-- 34.
-- <예시>와 같이 대상 문자열을 왼쪽/오른쪽에 출력하고 
-- 빈공간을 특정 문자로 채우는 SQL문을 작성하시오.
-- LPAD(문자열, 칸의 수, 채울 문자)
-- RPAD
-- 'ALOHACLASS'
SELECT LPAD('ALOHACLASS', 20, '#') AS "왼쪽"
    , RPAD('ALOHACLASS', 20, '#') AS "오른쪽"
FROM dual;

SELECT RPAD(SUBSTR('020415-3123456', 1, 8), 14, '#') 주민번호
FROM dual;

-- 35.
-- 테이블 EMPLOYEES 의 FIRST_NAME과 HIRE_DATE 를 검색하되 
-- <예시>와 같이 날짜 형식을 지정하는 SQL 문을 작성하시오.
-- 형식 : 2024-03-04 (월) 12:34:56
-- TO_CHAR(데이터, '날짜/숫자 형식')
-- : 특정 데이터를 문자열 형식으로 변환하는 함수
SELECT FIRST_NAME AS 이름
    , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD (DY) HH:MI:SS') AS 입사일자
FROM EMPLOYEES;

-- 36.
-- 테이블 EMPLOYEES 의 FIRST_NAME과 SALARY 를 검색하되 
-- <예시>와 같이 날짜 형식을 지정하는 SQL 문을 작성하시오.
SELECT FIRST_NAME AS 이름
    , TO_CHAR(SALARY, '$999,999,999') AS 급여
FROM EMPLOYEES;

-- 37.
-- TO_DATE(데이터)
-- : 문자형 데이터를 날짜형 데이터로 변환하는 함수
SELECT '20240304' 문자
    , TO_DATE ('20240304', 'YYYYMMDD') AS 날짜1
    , TO_DATE ('2024/03/04', 'YYYY/MM/DD') AS 날짜2
    , TO_DATE ('2024-03-04', 'YYYY-MM-DD') AS 날짜3
    , TO_DATE ('2024.03.04', 'YYYY.MM.DD') AS 날짜4
FROM DUAL;

-- 38.
-- TO_NUMBER(데이터)
-- : 문자형 데이터를 숫자형 데이터로 변환하는 함수
SELECT '1,200,000' 문자
    , TO_NUMBER('1,200,000', '999,999,999') AS 숫자
FROM DUAL;

-- 39.
-- 어제, 오늘, 내일 날짜를 출력하시오.
-- sysdate : 현재 날짜/시간 정보를 가지고 있는 키워드
-- 2023/05/22 - YYYY/MM/DD 형식으로 출력
-- 날짜 데이터 --> 문자 데이터 변환
SELECT SYSDATE FROM DUAL;

SELECT SYSDATE - 1 AS 어제
    , SYSDATE AS 오늘
    , SYSDATE + 1 AS 내일
FROM DUAL;

-- 40.
-- 사원의 근무 달수와 근속 연수를 구하시오.
-- MONTHS BETWEEN (A, B)
-- : 날짜 A부터 B까지 개월 수 차이를 반환하는 함수
-- (단, A > B, 즉 A가 더 최근 날짜로 지정해야 양수로 반환)
SELECT FIRST_NAME 이름
    , TO_CHAR(HIRE_DATE, 'YYYY.MM.DD') 입사일자
    , TO_CHAR(SYSDATE, 'YYYY.MM.DD') 오늘
    , TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월' 근무달수
    , TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) || '년' 근속연수
FROM EMPLOYEES;

-- 41.
-- 오늘로부터 6개월 후의 날짜를 구하시오.
-- ADD_MONTHS(날짜, 개월 수)
-- : 지정한 날짜로부터 해당 개월 수를 후의 날짜로 반환하는 함수
SELECT SYSDATE 오늘
    , ADD_MONTHS(SYSDATE, 6) "6개월 후"
FROM DUAL;

SELECT '2024/01/31' 개강
    , ADD_MONTHS('2024/01/31', 6) + 1 종강
FROM DUAL;

-- 42.
-- 오늘 이후 돌아오는 토요일을 구하시오.
-- NEXT_DAY(날짜, 요일)

SELECT SYSDATE 오늘
    , NEXT_DAY(SYSDATE, 7) "다음 토요일"
FROM DUAL;

SELECT SYSDATE 오늘
    , NEXT_DAY(SYSDATE, 1) "다음 일요일"
    , NEXT_DAY(SYSDATE, 2) "다음 월요일"
    , NEXT_DAY(SYSDATE, 3) "다음 화요일"
    , NEXT_DAY(SYSDATE, 4) "다음 수요일"
    , NEXT_DAY(SYSDATE, 5) "다음 목요일"
    , NEXT_DAY(SYSDATE, 6) "다음 금요일"
    , NEXT_DAY(SYSDATE, 7) "다음 토요일"
FROM DUAL;

-- 43.
-- 오늘 날짜와 해당 월의 월초, 월말 일자를 구하시오.
-- 월초 : TRUNC(날짜, 'MM')
-- 월말 : LASTDAY(날짜)

SELECT TRUNC(SYSDATE, 'MM') 월초
    , SYSDATE 오늘
    , LAST_DAY(SYSDATE) 월말
FROM DUAL;

-- 44.
-- 테이블 EMPLOYEES의 COMMISSION_PCT를 중복없이 검색하되,
-- NULL이면 0으로 조회하고 내림차순으로 정렬하는 SQL문을 작성하시오
/*
    * 실행 순서
    - FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
    1. 테이블을 선택한다
    2. 조건에 맞는 데이터를 선택한다
    3. 그룹 기준을 지정 한다
    4. 그룹 별로 그룹 조건에 맞는 데이터를 선택한다
    5. 조회할 컬럼을 선택한다
    6. 조회된 결과를 정렬기준에 따라 정렬한다.
*/
-- NVL (값, 대체할 값) : 해당 값이 NULL이면 지정된 값으로 변환하는 함수
-- DISTINCT : 중복 없이 조회

-- ORDER BY의 정렬 기준 컬럼은, SELECT에서 선택한 컬럼만 사용 가능하다.
SELECT DISTINCT NVL(COMMISSION_PCT, 0) "커미션(%)"
FROM EMPLOYEES
ORDER BY NVL(COMMISSION_PCT, 0) DESC;

-- 조회한 컬럼의 별칭으로 ORDER BY절에서 사용할 수 있다.
SELECT DISTINCT NVL(COMMISSION_PCT, 0) "커미션(%)"
FROM EMPLOYEES
ORDER BY "커미션(%)" DESC;

-- 45.
-- * 최종 급여 = 급여 + (급여 * 커미션)
-- NVL2 (값, NULL아닐 때 값, NULL일 때 값)

SELECT FIRST_NAME 이름
    , SALARY 급여
    , COMMISSION_PCT
    , NVL(COMMISSION_PCT, 0) 커미션
    , NVL2(COMMISSION_PCT, SALARY + (SALARY * COMMISSION_PCT), SALARY) 최종급여
FROM EMPLOYEES
ORDER BY 최종급여 DESC;

-- 46.
-- DECODE(컬럼명, 조건값1, 반환값1, 조건값2, 반환값2, ...)
-- : 지정한 컬럼의 값이 조건값에 일치하면 바로 뒤의 반환값을 출력하는 함수

-- 사원 테이블 : employees
SELECT FIRST_NAME 이름
    , DECODE( department_id, 10, 'Administration',
                              20, 'Marketing',
                              30, 'Purchasing',
                              40, 'Human Resources',
                              50, 'Shipping',
                              60, 'IT',
                              70, 'Public Relations',
                              80, 'Sales',
                              90, 'Executive',
                              100, 'Finance'
     ) 부서
FROM EMPLOYEES;

-- 부서 테이블 : department_id (부서 번호)
SELECT *
FROM DEPARTMENTS;

-- 47.
-- CASE문
-- : 조건식을 만족할 때, 출력할 값을 지정하는 구문
SELECT first_name 이름
      ,CASE WHEN department_id = 10 THEN 'Administration'
            WHEN department_id = 20 THEN 'Marketing'                 
            WHEN department_id = 30 THEN 'Purchasing'                 
            WHEN department_id = 40 THEN 'Human Resources'                 
            WHEN department_id = 50 THEN 'Shipping'                 
            WHEN department_id = 60 THEN 'IT'                 
            WHEN department_id = 70 THEN 'Public Relations'                 
            WHEN department_id = 80 THEN 'Sales'                 
            WHEN department_id = 90 THEN 'Executive'                 
            WHEN department_id = 100 THEN 'Finance'     
            ELSE '부서 없음'
      END 부서
FROM employees;

-- 그룹함수
-- 48.
-- EMPLOYEES 테이블로 부터 전체 사원 수를 구하시오.
-- COUNT( 컬럼명 )
-- : 컬럼을 지정하여 NULL 을 제외한 데이터 개수를 반환하는 함수
-- * NULL 이 없는 데이터라면 어떤 컬럼을 지정하더라도 개수가 같으므로,
--   일반적으로 COUNT(*) 로 개수를 구한다.

-- COUNT(*) : NULL 도 포함하여 개수를 구함.
SELECT COUNT(*) 사원수
FROM EMPLOYEES;

-- COUNT(컬럼) : NULL 은 제외하고 개수를 구함.
SELECT COUNT(COMMISSION_PCT) "성과급이있는 사원수"
FROM EMPLOYEES;

-- 49.
-- 사원들의 최고급여와 최저급여를 구하시오.
SELECT MAX(SALARY) 최고급여
    , MIN(SALARY) 최저급여
FROM EMPLOYEES;

-- 50.
-- 사원들의 급여 합계와 평균을 구하시오
SELECT SUM(SALARY) 급여합계
    , ROUND(AVG(SALARY), 2) 급여평균
FROM EMPLOYEES;

-- 51.
-- 사원들의 급여 표준편차와 분산을 구하시오
SELECT ROUND(STDDEV(SALARY), 2) 급여표준편차
    , ROUND(VARIANCE(SALARY) ,2) 급여분산
FROM EMPLOYEES;

-- 52.
-- MS_STUDENT 테이블을 생성하시오.
-- * 테이블 생성
/*
    CREATE TABLE 테이블명 (
        컬럼명1 타입    [DEFAULT 기본값] [NOT NULL/NULL] [제약조건],
        컬럼명2 타입    [DEFAULT 기본값] [NOT NULL/NULL] [제약조건],
        컬럼명3 타입    [DEFAULT 기본값] [NOT NULL/NULL] [제약조건],
        ...
    );
*/
CREATE TABLE MS_STUDENT 
(
  ST_NO      NUMBER          NOT NULL
    ,NAME       VARCHAR2(20)    NOT NULL
    ,CTZ_NO     CHAR(14)        NOT NULL
    ,EMAIL      VARCHAR2(100)   NOT NULL
    ,ADDRESS    VARCHAR2(1000)  NULL
    ,DEPT_NO    NUMBER          NOT NULL
    ,MJ_NO      NUMBER          NOT NULL
    ,REG_DATE   DATE    DEFAULT sysdate NOT NULL
    ,UPD_DATE   DATE    DEFAULT sysdate NOT NULL
    ,ETC        VARCHAR2(1000)  DEFAULT '없음' NULL
    ,
    CONSTRAINT MS_STUDENT_PK PRIMARY KEY(ST_NO) ENABLE
);
-- UQ (고유키) 추가
ALTER TABLE MS_STUDENT ADD CONSTRAINT MS_STUDENT_UK1 UNIQUE ( EMAIL ) ENABLE;

COMMENT ON TABLE MS_STUDENT IS '학생들의 정보를 관리한다.';
COMMENT ON COLUMN MS_STUDENT.ST_NO IS '학생 번호';
COMMENT ON COLUMN MS_STUDENT.NAME IS '이름';
COMMENT ON COLUMN MS_STUDENT.CTZ_NO IS '주민번호';
COMMENT ON COLUMN MS_STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN MS_STUDENT.ADDRESS IS '주소';
COMMENT ON COLUMN MS_STUDENT.DEPT_NO IS '부서번호';
COMMENT ON COLUMN MS_STUDENT.MJ_NO IS '전공번호';
COMMENT ON COLUMN MS_STUDENT.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_STUDENT.UPD_DATE IS '수정일자';
COMMENT ON COLUMN MS_STUDENT.ETC IS '특이사항';

/*
    테이블 삭제
    DROP TABLE 테이블명;
*/
DROP TABLE MS_STUDENT;

-- 53.
-- MS_STUDENT 테이블에 성별, 재적, 입학일자, 졸업일자 속성을 추가하시오.

-- 테이블에 속성 추가
-- ALTER TABLE 테이블명 ADD 컬럼명 타입 DEFAULT 기본값 [NOT NULL];

-- 성별 속성 추가
ALTER TABLE MS_STUDENT ADD GENDER CHAR(6) DEFAULT '기타' NOT NULL;
COMMENT ON COLUMN MS_STUDENT.GENDER IS '성별';

-- 재적 속성 추가
ALTER TABLE MS_STUDENT ADD STATUS VARCHAR2(10) DEFAULT '대기' NOT NULL;
COMMENT ON COLUMN MS_STUDENT.STATUS IS '재적';

-- 입학 일자 속성 추가
ALTER TABLE MS_STUDENT ADD ADM_DATE DATE NULL;
COMMENT ON COLUMN MS_STUDENT.ADM_DATE IS '입학 일자';

-- 졸업 일자 속성 추가
ALTER TABLE MS_STUDENT ADD GRD_DATE DATE NULL;
COMMENT ON COLUMN MS_STUDENT.GRD_DATE IS '졸업 일자';

-- 54.
-- MS_STUDENT 테이블의 CTZ_NO 속성을 BIRTH 로 이름을 변경하고
-- 데이터 타입을 DATE 로 수정하시오.
-- 그리고, 설명도 '생년월일'로 변경하시오.

-- CTZ_NO -> BIRTH 이름 변경
ALTER TABLE MS_STUDENT RENAME COLUMN CTZ_NO TO BIRTH;
-- DATE 타입으로 변경
ALTER TABLE MS_STUDENT MODIFY BIRTH DATE;
-- 설명을 '생년월일'으로 변경
COMMENT ON COLUMN MS_STUDENT.BIRTH IS '생년월일';

-- 55.
-- MS_STUDENT 테이블의 학부 번호(DEPT_NO) 속성을 삭제하시오.

ALTER TABLE MS_STUDENT DROP COLUMN DEPT_NO;

-- 56.
-- MS_STUDENT 테이블을 삭제하는 SQL문을 작성하시오.
DROP TABLE MS_STUDENT;

-- 57.
-- 테이블 정의서 대로 학생테이블(MS_STUDENT) 를 생성하시오.
CREATE TABLE MS_STUDENT (
     ST_NO      NUMBER          NOT NULL 
    ,NAME       VARCHAR2(20)    NOT NULL
    ,BIRTH      DATE            NOT NULL
    ,EMAIL      VARCHAR2(100)   NOT NULL
    ,ADDRESS    VARCHAR2(1000)  NULL
    ,MJ_NO      NUMBER          NOT NULL
    ,GENDER     CHAR(6)         DEFAULT '기타'    NOT NULL
    ,STATUS     VARCHAR2(10)    DEFAULT '대기'    NOT NULL
    ,ADM_DATE   DATE    NULL
    ,GRD_DATE   DATE    NULL
    ,REG_DATE   DATE    DEFAULT sysdate NOT NULL
    ,UPD_DATE   DATE    DEFAULT sysdate NOT NULL
    ,ETC        VARCHAR2(1000)  DEFAULT '없음' NULL
    ,
    CONSTRAINT MS_STUDENT_PK PRIMARY KEY(ST_NO) ENABLE
);

-- UQ (고유키) 추가
ALTER TABLE MS_STUDENT ADD CONSTRAINT MS_STUDENT_UK1 UNIQUE ( EMAIL ) ENABLE;

COMMENT ON TABLE MS_STUDENT IS '학생들의 정보를 관리한다.';
COMMENT ON COLUMN MS_STUDENT.ST_NO IS '학생 번호';
COMMENT ON COLUMN MS_STUDENT.NAME IS '이름';
COMMENT ON COLUMN MS_STUDENT.BIRTH IS '생년월일';
COMMENT ON COLUMN MS_STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN MS_STUDENT.ADDRESS IS '주소';
COMMENT ON COLUMN MS_STUDENT.MJ_NO IS '전공번호';

COMMENT ON COLUMN MS_STUDENT.GENDER IS '성별';
COMMENT ON COLUMN MS_STUDENT.STATUS IS '재적';
COMMENT ON COLUMN MS_STUDENT.ADM_DATE IS '입학일자';
COMMENT ON COLUMN MS_STUDENT.GRD_DATE IS '졸업일자';

COMMENT ON COLUMN MS_STUDENT.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_STUDENT.UPD_DATE IS '수정일자';
COMMENT ON COLUMN MS_STUDENT.ETC IS '특이사항';

-- 58.
-- 데이터 삽입 (INSERT)

ALTER TABLE MS_STUDENT MODIFY MJ_NO CHAR(4);

INSERT INTO MS_STUDENT (
                            ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, GENDER,
                            STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC
                        )
VALUES ( '20180001', '최서아', '1999/10/05', 'csa@univ.ac.kr', '서울', 'I01', '여', 
        '재학', '2018/03/01', NULL, sysdate, sysdate, NULL );

-- '1999/10/05' -> TO_DATE('1999/10/05', 'YYYY/MM/DD') 도 가능
-- SQL Developer 에서 INSERT 한다면, COMMIT 을 실행해줘야 LOCK 걸리지 않고 적용됨.
DELETE FROM MS_STUDENT WHERE st_no = '20180001';

SELECT * FROM MS_STUDENT;

-- MS_STUDENT 데이터 추가
INSERT INTO ms_student ( 
                              ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, GENDER,
                              STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC
                        )
VALUES ( '20180001', '최서아', '1999/10/05', 'csa@univ.ac.kr', '서울', 'I01', '여', 
        '재학', '2018/03/01', NULL, sysdate, sysdate, NULL );

-- '1999/10/05' -> TO_DATE('1999/10/05', 'YYYY/MM/DD') 도 가능
-- SQL Developer 에서 INSERT 한다면, COMMIT 을 실행해줘야 LOCK 걸리지 않고 적용됨.


INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20210001', '박서준', TO_DATE('2002/05/04', 'YYYY/MM/DD'), 'psj@univ.ac.kr', '서울', 'B02',
         '남', '재학', TO_DATE('2021/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );


INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20210002', '김아윤', TO_DATE('2002/05/04', 'YYYY/MM/DD'), 'kay@univ.ac.kr', '인천', 'S01',
         '여', '재학', TO_DATE('2021/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20160001', '정수안', TO_DATE('1997/02/10', 'YYYY/MM/DD'), 'jsa@univ.ac.kr', '경남', 'J01',
         '여', '재학', TO_DATE('2016/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20150010', '윤도현', TO_DATE('1996/03/11', 'YYYY/MM/DD'), 'ydh@univ.ac.kr', '제주', 'K01',
         '남', '재학', TO_DATE('2016/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );


INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20130007', '안아람', TO_DATE('1994/11/24', 'YYYY/MM/DD'), 'aar@univ.ac.kr', '경기', 'Y01',
         '여', '재학', TO_DATE('2013/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, '영상예술 특기자' );


INSERT INTO MS_STUDENT ( ST_NO, NAME, BIRTH, EMAIL, ADDRESS, MJ_NO, 
                        GENDER, STATUS, ADM_DATE, GRD_DATE, REG_DATE, UPD_DATE, ETC )
VALUES ( '20110002', '한성호', TO_DATE('1992/10/07', 'YYYY/MM/DD'), 'hsh@univ.ac.kr', '서울', 'E03',
         '남', '재학', TO_DATE('2015/03/01', 'YYYY/MM/DD'), NULL, sysdate, sysdate, NULL );

SELECT * FROM MS_STUDENT;

-- 59.
-- MS_STUDENT 테이블의 데이터를 수정
-- UPDATE
/*
    UPDATE 테이블명
       SET 컬럼1 = 변경할 값,
           컬럼2 = 변경할 값,
           ...
   [WHERE] 조건;
*/
-- 1) 학생번호가 20160001 인 학생의 주소를 '서울'로,
--    재적상태를 '휴학'으로 수정하시오.
UPDATE MS_STUDENT
SET ADDRESS = '서울',
     STATUS = '휴학'
WHERE ST_NO = '20160001';

-- 2) 학생번호가 20150010 인 학생의 주소를 '서울'로,
--    재적 상태를 '졸업', 졸업일자를 '20200220', 수정일자 현재날짜로 
--    그리고 특이사항을 '수석'으로 수정하시오.
UPDATE MS_STUDENT
SET ADDRESS = '서울',
     STATUS = '졸업',
     GRD_DATE = '20200220',
     UPD_DATE = SYSDATE,
     ETC = '수석'
WHERE ST_NO = '20150010';
-- 3) 학생번호가 20130007 인 학생의 재적 상태를 '졸업', 졸업일자를 '20200220', 
--    수정일자 현재날짜로 수정하시오.
UPDATE MS_STUDENT
SET STATUS = '졸업',
    GRD_DATE = '20200220',
    UPD_DATE = SYSDATE
WHERE ST_NO = '20130007';

-- 4) 학생번호가 20110002 인 학생의 재적 상태를 '퇴학', 
--    수정일자를 현재날짜, 특이사항 '자진 퇴학' 으로 수정하시오.
UPDATE MS_STUDENT
SET STATUS = '퇴학',
    UPD_DATE = SYSDATE,
    ETC = '자진 퇴학'
WHERE ST_NO = '20110002';

SELECT * FROM MS_STUDENT;

-- 60.
-- MS_STUDENT 테이블에서 학번이 20110002 인 학생을 삭제하시오.

DELETE FROM MS_STUDENT
WHERE ST_NO = '20110002';

SELECT * FROM MS_STUDENT;

-- 61.
-- MS_STUDENT 테이블의 모든 속성을 조회하시오.
SELECT *
FROM MS_STUDENT;

-- 62.
-- MS_STUDENT 테이블을 조회하여 MS_STUDENT_BACK 테이블 생성하시오.
-- 백업 테이블 만들기
CREATE TABLE MS_STUDENT_BACK
AS SELECT * FROM MS_STUDENT;

SELECT * FROM MS_STUDENT_BACK;

-- 63.
-- MS_STUDENT 테이블의 튜플을 삭제하시오.
-- 데이터 삭제
DELETE FROM MS_STUDENT;

-- 데이터 및 내부 구조 삭제
TRUNCATE TABLE MS_STUDENT;

-- 구조 삭제
DROP TABLE MS_STUDENT;

SELECT * FROM MS_STUDENT;

-- 64.
-- MS_STUDENT_BACK 테이블의 모든 속성을 조회하여
-- MS_STUDENT 테이블에 삽입하시오.
INSERT INTO MS_STUDENT
SELECT * FROM MS_STUDENT_BACK;

-- 65.
-- MS_STUDENT 테이블의 성별(gender) 속성에 대하여,
-- ('여', '남', '기타') 값만 입력가능하도록 제약조건을 추가하시오.
ALTER TABLE MS_STUDENT
ADD CONSTRAINT MS_STUDENT_GENDER_CHECK
CHECK(GENDER IN ('여', '남', '기타'));

UPDATE MS_STUDENT
SET GENDER = '???';

-- * 조건으로 지정한 값이 아닌 다른 값을 입력/수정 하는 경우
-- ORA-02290: 체크 제약조건(HR.MS_STUDENT_GENDER_CHECK)이 위배되었습니다 -> 도메인 무결성 보장

-- 66 ~ 69. 과제 - 테이블 생성
-- 66.
-- 테이블 기술서를 참고하여 MS_USER 테이블을 생성하시오.
CREATE TABLE MS_USER (
    USER_NO     NUMBER            NOT NULL    PRIMARY KEY ,
    USER_ID     VARCHAR2(100)     NOT NULL    UNIQUE ,
    USER_PW     VARCHAR2(200)     NOT NULL ,
    USER_NAME   VARCHAR2(50)      NOT NULL ,
    BIRTH       DATE              NOT NULL ,
    TEL         VARCHAR2(20)      NOT NULL    UNIQUE ,
    ADDRESS     VARCHAR2(200)     NULL ,
    REG_DATE    DATE              DEFAULT sysdate NOT NULL,
    UPD_DATE    DATE              DEFAULT sysdate NOT NULL
);

COMMENT ON TABLE MS_USER IS '회원';
COMMENT ON COLUMN MS_USER.USER_NO IS '회원번호';
COMMENT ON COLUMN MS_USER.USER_ID IS '아이디';
COMMENT ON COLUMN MS_USER.USER_PW IS '비밀번호';
COMMENT ON COLUMN MS_USER.USER_NAME IS '이름';
COMMENT ON COLUMN MS_USER.BIRTH IS '생년월일';
COMMENT ON COLUMN MS_USER.TEL IS '전화번호';
COMMENT ON COLUMN MS_USER.ADDRESS IS '주소';
COMMENT ON COLUMN MS_USER.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_USER.UPD_DATE IS '수정일자';

-- 67.
-- MS_BOARD 테이블을 생성하시오.
CREATE TABLE MS_BOARD (
    BOARD_NO    NUMBER            NOT NULL PRIMARY KEY ,
    TITLE       VARCHAR2(200)     NOT NULL ,
    CONTENT     CLOB              NOT NULL ,
    WRITER      VARCHAR2(100)     NOT NULL ,
    HIT         NUMBER            NOT NULL ,
    LIKE_CNT    NUMBER            NOT NULL ,
    DEL_YN      CHAR(2)           NULL ,
    DEL_DATE    DATE              NULL ,
    REG_DATE    DATE              DEFAULT sysdate NOT NULL ,
    UPD_DATE    DATE              DEFAULT sysdate NOT NULL 
);

COMMENT ON TABLE MS_BOARD IS '게시판';
COMMENT ON COLUMN MS_BOARD.BOARD_NO IS '게시글 번호';
COMMENT ON COLUMN MS_BOARD.TITLE IS '제목';
COMMENT ON COLUMN MS_BOARD.CONTENT IS '내용';
COMMENT ON COLUMN MS_BOARD.WRITER IS '작성자';
COMMENT ON COLUMN MS_BOARD.HIT IS '조회수';
COMMENT ON COLUMN MS_BOARD.LIKE_CNT IS '좋아요 수';
COMMENT ON COLUMN MS_BOARD.DEL_YN IS '삭제여부';
COMMENT ON COLUMN MS_BOARD.DEL_DATE IS '삭제일자';
COMMENT ON COLUMN MS_BOARD.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_BOARD.UPD_DATE IS '수정일자';

-- 68.
-- MS_FILE 테이블을 생성하시오.
CREATE TABLE MS_FILE (
      FILE_NO     NUMBER NOT NULL PRIMARY KEY ,
      BOARD_NO    NUMBER NOT NULL ,
      FILE_NAME   VARCHAR2(2000) NOT NULL ,
      FILE_DATA   BLOB  NOT NULL ,
      REG_DATE    DATE  DEFAULT sysdate NOT NULL ,
      UPD_DATE    DATE  DEFAULT sysdate NOT NULL 
);

COMMENT ON TABLE MS_FILE IS '첨부파일';
COMMENT ON COLUMN MS_FILE.FILE_NO IS '파일번호';
COMMENT ON COLUMN MS_FILE.BOARD_NO IS '글번호';
COMMENT ON COLUMN MS_FILE.FILE_NAME IS '파일명';
COMMENT ON COLUMN MS_FILE.FILE_DATA IS '파일';
COMMENT ON COLUMN MS_FILE.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_FILE.UPD_DATE IS '수정일자';

-- 69.
-- MS_REPLY 테이블을 생성하시오.
CREATE TABLE MS_REPLY (
    REPLY_NO    NUMBER      NOT NULL PRIMARY KEY ,
    BOARD_NO    NUMBER      NOT NULL ,
    CONTENT     VARCHAR2(2000)    NOT NULL ,
    WRITER      VARCHAR2(100)    NOT NULL ,
    DEL_YN      CHAR(2)     DEFAULT 'N' NULL ,
    DEL_DATE    DATE        NULL ,
    REG_DATE    DATE        DEFAULT sysdate NOT NULL ,
    UPD_DATE    DATE        DEFAULT sysdate NOT NULL 
);

COMMENT ON TABLE MS_REPLY IS '댓글';
COMMENT ON COLUMN MS_REPLY.REPLY_NO IS '댓글번호';
COMMENT ON COLUMN MS_REPLY.BOARD_NO IS '글번호';
COMMENT ON COLUMN MS_REPLY.CONTENT IS '내용';
COMMENT ON COLUMN MS_REPLY.WRITER IS '작성자';
COMMENT ON COLUMN MS_REPLY.DEL_YN IS '삭제여부';
COMMENT ON COLUMN MS_REPLY.DEL_DATE IS '삭제일자';
COMMENT ON COLUMN MS_REPLY.REG_DATE IS '등록일자';
COMMENT ON COLUMN MS_REPLY.UPD_DATE IS '수정일자';

-- 70.
-- 1. joeun, joeun2 계정 생성
-- 2. community.dmp 파일 import

-- joeun
-- HR 계정 생성
-- C## 접두사 없이도 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- 계정 생성
CREATE USER joeun IDENTIFIED BY 123456;
-- 테이블 스테이스 지정
ALTER USER joeun DEFAULT TABLESPACE users;
-- 용량 설정
ALTER USER joeun QUOTA UNLIMITED ON users;
-- 권한 부여
GRANT DBA TO joeun;

-- 계정 삭제
DROP USER joeun CASCADE;

-- 덤프 파일 import 하기
-- imp userid = 관리자계정/비밀번호 file = 덤프파일경로 fromuser = 덤프소유계정 touser = 임포트할계정
imp userid = system/1234 file = C:\YJH\Oracle\joeun.dmp fromuser = joeun touser = joeun

-- 71.
-- joeun 계정의 데이터를 덤프파일로 export 하기
exp userid = joeun/123456 file = C:\YJH\Oracle\community.dmp log = C:\YJH\Oracle\community.log

