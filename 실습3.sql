-- Active: 1709601469588@@127.0.0.1@1521@orcl@JOEUN
-- 98.
-- employee, department 테이블을 조인하여,
-- 사원번호, 직원명, 부서번호, 부서명, 이메일, 전화번호
-- 주민번호, 입사일자, 급여, 연봉을 조회하시오.
-- CREATE OR REPLACE 객체
-- - 없으면, 새로 생성
-- - 있으면, 대체 (기존에 생성 되어 있어도 에러발생X)

-- 뷰 생성
CREATE OR REPLACE VIEW VE_EMP_DEPT AS 
SELECT E.EMP_ID,
       E.EMP_NAME,
       D.DEPT_TITLE,
       E.EMAIL,
       E.PHONE,
       RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') EMP_NO,
       TO_CHAR(HIRE_DATE, 'YYYY.MM.DD') HIRE_DATE,
       E.SALARY,
       TO_CHAR( 
            (SALARY + (SALARY * NVL(BONUS,0))) * 12
            , '999,999,999,999'
        ) YR_SALARY
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D
ON (E.DEPT_CODE = D.DEPT_ID)

SELECT *
FROM VE_EMP_DEPT;

-- 99.
-- 시퀀스를 생성하시오.
-- SEQ_MS_USER
-- SEQ_MS_BOARD
-- SEQ_MS_FILE
-- SEQ_MS_REPLY
-- (시작: 1, 증가값: 1, 최솟값: 1, 최댓값: 1000000)
-- 시퀀스 생성

CREATE SEQUENCE SEQ_MS_USER
INCREMENT BY 1      -- 증가값
START WITH 1        -- 시작값
MINVALUE 1          -- 최솟값
MAXVALUE 10000000;  -- 최댓값

CREATE SEQUENCE SEQ_MS_BOARD
INCREMENT BY 1      -- 증가값
START WITH 1        -- 시작값
MINVALUE 1          -- 최솟값
MAXVALUE 10000000;  -- 최댓값

CREATE SEQUENCE SEQ_MS_FILE
INCREMENT BY 1      -- 증가값
START WITH 1        -- 시작값
MINVALUE 1          -- 최솟값
MAXVALUE 10000000;  -- 최댓값

CREATE SEQUENCE SEQ_MS_REPLY
INCREMENT BY 1      -- 증가값
START WITH 1        -- 시작값
MINVALUE 1          -- 최솟값
MAXVALUE 10000000;  -- 최댓값

-- 100.
-- SEQ_MS_USER의 다음 번호와 현재 번호를 출력하시오

-- 다음 시퀀스 번호
SELECT SEQ_MS_USER.NEXTVAL FROM DUAL;

-- 현재 시퀀스 번호
SELECT SEQ_MS_USER.CURRVAL FROM DUAL;

-- 101.
-- SEQ_MS_USER를 삭제하시오
DROP SEQUENCE SEQ_MS_USER;

-- 102.
INSERT INTO MS_USER (USER_NO, USER_ID, USER_PW, USER_NAME,
                    BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE,
                    CTZ_NO, GENDER
                    )
VALUES (
        SEQ_MS_USER.NEXTVAL, 'ALOHA', '123456', '김조은',
        '2024/03/06', '010-1234-1234', '인천 부평구', SYSDATE, SYSDATE,
        '020101-4123123', '여'
);

SELECT * FROM MS_USER;

INSERT INTO MS_USER (USER_NO, USER_ID, USER_PW, USER_NAME,
                    BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE,
                    CTZ_NO, GENDER
                    )
VALUES (
        SEQ_MS_USER.NEXTVAL, 'JOEUN', '123456', '박조은',
        '2024/03/06', '010-1234-1234', '서울 구로구', SYSDATE, SYSDATE,
        '971212-4123123', '여'
);

-- 103.
-- 시퀀스 SEQ_MS_USER의 최댓값을 100,000,000으로 수정하시오
ALTER SEQUENCE SEQ_MS_USER MAXVALUE 100000000;

-- 104.
-- USER_IND_COLUMNS 테이블을 조회하시오.
-- * 사용자가 정의한 인덱스 정보가 들어있다.
-- SYSTEM으로 접속 후 실행
SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS;

-- 105.
-- MS_USER 테이블의 USER_NAME 에 대한
-- 인덱스 IDX_MS_USER_NAME 을 생성하시오.

-- 인덱스 생성
CREATE INDEX IDX_MS_USER_NAME ON MS_USER(user_name);

-- 인덱스 삭제
DROP INDEX IDX_MS_USER_NAME;

-- 그룹 관련 함수

-- ROLLUP
SELECT DEPT_CODE, JOB_CODE,
       COUNT(*), MAX(SALARY), SUM(SALARY), TRUNC(AVG(SALARY), 2)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
AND JOB_CODE IS NOT NULL
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE;

-- CUBE
SELECT DEPT_CODE, JOB_CODE,
       COUNT(*), MAX(SALARY), SUM(SALARY), TRUNC(AVG(SALARY), 2)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL
AND JOB_CODE IS NOT NULL
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE, JOB_CODE;

-- GROUPING SETS
-- 그룹 기준 별도로 그룹
SELECT dept_code, job_code, COUNT(*)
FROM employee
GROUP BY GROUPING SETS( (dept_code), (job_code) )
ORDER BY dept_code, job_code;

-- 
SELECT dept_code, job_code, COUNT(*)
FROM employee
GROUP BY dept_code, job_code
ORDER BY dept_code, job_code;

-- GROUPING
SELECT dept_code
      , job_code
      , COUNT(*)
      , MAX(salary)
      , SUM(salary)
      , TRUNC( AVG(salary), 2)
      , GROUPING(dept_code) "부서코드 그룹여부"
      , GROUPING(job_code) "직급코드 그룹여부"
      , CASE 
            WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1
            THEN DEPT_CODE || '의 합계'
            WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0
            THEN JOB_CODE || '의 합계'
            WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 1
            THEN '전체 합계'
            
        END
FROM employee
WHERE dept_code IS NOT NULL
  AND job_code IS NOT NULL
GROUP BY CUBE(dept_code, job_code)
ORDER BY dept_code, job_code;


SELECT dept_code 부서코드,
        LISTAGG( emp_name, ', ')
        WITHIN GROUP(ORDER BY emp_name) "부서별 사원이름목록"
FROM employee
GROUP BY dept_code
ORDER BY dept_code;

SELECT *
FROM (
        SELECT dept_code, job_code, salary
        FROM employee
     )
     PIVOT (
        MAX(salary)
        -- 열에 올릴 컬럼들
        FOR dept_code IN ('D1','D2','D3','D4','D5','D6','D7','D8','D9')
     )
ORDER BY job_code;

SELECT *
FROM (
        SELECT dept_code
              ,MAX( DECODE(job_code, 'J1', salary ) ) J1 
              ,MAX( DECODE(job_code, 'J2', salary ) ) J2 
              ,MAX( DECODE(job_code, 'J3', salary ) ) J3 
              ,MAX( DECODE(job_code, 'J4', salary ) ) J4 
              ,MAX( DECODE(job_code, 'J5', salary ) ) J5 
              ,MAX( DECODE(job_code, 'J6', salary ) ) J6 
              ,MAX( DECODE(job_code, 'J7', salary ) ) J7 
        FROM employee
        GROUP BY dept_code
        ORDER BY dept_code
     )
     UNPIVOT (
        salary
        FOR job_code IN (J1, J2, J3, J4, J5, J6, J7)
     );

-- RANK
SELECT employee_id, salary,
        RANK() 
	    OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- DENSE_RANK
SELECT employee_id,
        salary,
        DENSE_RANK()
        OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM employees;

-- ROW_NUMBER
SELECT employee_id,
        salary,
        ROW_NUMBER() 
		OVER (ORDER BY salary DESC) AS row_num
FROM employees;

-- FIRST_VALUE
SELECT department_id,
        employee_id,
        salary,
        FIRST_VALUE(salary) 
        OVER (PARTITION BY department_id 
              ORDER BY hire_date
             ) AS first_salary
FROM employees;

-- LAST_VALUE
SELECT department_id,
        employee_id,
        salary,
        LAST_VALUE(salary) 
        OVER (PARTITION BY department_id 
              ORDER BY hire_date
              ROWS BETWEEN UNBOUNDED PRECEDING 
              AND UNBOUNDED FOLLOWING
             ) AS last_salary
FROM employees;

-- LAG
SELECT employee_id, first_name, hire_date,
       LAG(first_name) OVER (ORDER BY hire_date) AS previous_name,
       LAG(hire_date) OVER (ORDER BY hire_date) AS previous_hire_date
FROM employees;

-- LEAD
SELECT employee_id, first_name, hire_date,
       LEAD(first_name) OVER (ORDER BY hire_date) AS next_first_name,
       LEAD(hire_date) OVER (ORDER BY hire_date) AS next_hire_date
FROM employees;

-- CUME_DIST()
SELECT employee_id
    , salary
    , CUME_DIST() 
        OVER (ORDER BY salary DESC) AS cumulative_distribution
FROM employees;

-- PERCENT_RANK
SELECT employee_id
    , salary
    , PERCENT_RANK() 
        OVER (ORDER BY salary DESC) AS percent_rank
FROM employees;

-- NTILE
SELECT employee_id
    , salary
    , NTILE(4) 
        OVER (ORDER BY salary DESC) AS quartile
FROM employees;

-- RATIO_TO_REPORT
SELECT department_id
    , employee_id
    , salary
    , RATIO_TO_REPORT(salary) 
        OVER (PARTITION BY department_id) AS salary_ratio
FROM employees;

SELECT ROWNUM
FROM EMPLOYEE
WHERE ROWNUM < 10;