-- TCL (Transaction Control Language) : 트랜잭션 제어 언어
-- COMMIT, ROLLBACK, SAVEPOINT

-- DML : 데이터 조작언어로 데이터의 삽입/삭제/수정
--> 트랜잭션은 DML과 관련되어 있음..

/* TRANSACTION 이란?
 * - 데이터베이스의 논리적 연산 단위
 * - 데이터 변경 사항을 묶어서 하나의 트랜잭션에 담아 처리함.
 * - 트랜잭션의 대상이 되는 데이터 변경 사항 : INSERT, UPDATE, DELETE, MERGE
 *
 * INSERT 수행 ------------------------------------------------> DB 반영 (X)
 *
 * INSERT 수행 -----> 트랜잭션에 추가 ---> COMMIT -------------> DB 반영 (O)
 *
 * INSERT 10번 수행 --> 1개 트랜잭션에 10개 추가 --> ROLLBACK --> DB 반영 (X)
 *
 *
 * 1 ) COMMIT : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 DB에 반영
 *
 * 2 ) ROLLBACK : 메모리 버퍼(트랜잭션)에 임시 저장된 데이터 변경 사항을 삭제하고
 *                마지막 COMMIT 상태로 돌아감 (DB에 변경 내용 반영 X)
 *
 *
 * 3 ) SAVEPOINT : 메모리 버퍼(트랜잭션)에 저장 지점을 정의하여
 *                ROLLBACK 수행 시 전체 작업을 삭제하는 것이 아닌
 *                저장 지점까지만 일부 ROLLBACK
 *
 *
 * [SAVEPOINT 사용법]
 *
 * ...
 * SAVEPOINT "포인트명1";
 *
 * ...
 * SAVEPOINT "포인트명2";
 *
 * ...
 * ROLLBACK TO "포인트명1"; -- 포인트1 지점까지 데이터 변경사항 삭제
 *
 *
 * ** SAVEPOINT 지정 및 호출 시 이름에 ""(쌍따옴표) 붙여야함 !!! ***
 *
 * */

-- 새로운 데이터 DEPARTMENT2에 INSERT 

SELECT * FROM DEPARTMENT2;

INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

-- INSERT 확인
SELECT * FROM DEPARTMENT2;

--> DB에 반영된 것 처럼 보이지만
-- 실제로 아직 DB에 영구 반영 된 것 아님
-- 트렌잭션에 INSERT 3개 있음

-- ROLLBACK 후 확인
ROLLBACK; -- 마지막 커밋 시점까지 되돌아감.

SELECT * FROM DEPARTMENT2;
-- 개발1, 개발2, 개발3 팀 롤백됨

-- COMMIT 후 ROLLBACK이 되는지 확인
INSERT INTO DEPARTMENT2 VALUES('T1', '개발1팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T2', '개발2팀', 'L2');
INSERT INTO DEPARTMENT2 VALUES('T3', '개발3팀', 'L2');

-- INSERT 확인
SELECT * FROM DEPARTMENT2;

COMMIT; -- DB에 반영

ROLLBACK;

-- COMMIT 후 ROLLBACK 안된다. DB에 이미 반영됨
SELECT * FROM DEPARTMENT2;


------------------------------------------------------

-- SAVEPOINT 확인

INSERT INTO DEPARTMENT2 VALUES('T4', '개발4팀', 'L2');
SAVEPOINT "SP1"; -- SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2"; -- SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT "SP3"; -- SAVEPOINT 지정

SELECT * FROM DEPARTMENT2;

ROLLBACK TO "SP1";


SELECT * FROM DEPARTMENT2; -- 개발 4팀 남음

-- ROLLBACK "SP1" 구문 수행 시 이후에 설정된 SP2, SP3도 삭제됨
-- ROLLBACK TO "SP2";
-- SQL Error [1086] [72000]: ORA-01086: 'SP2' 저장점이 이 세션에 설정되지 않았거나 부적합합니다.
-- = 없다

INSERT INTO DEPARTMENT2 VALUES('T5', '개발5팀', 'L2');
SAVEPOINT "SP2"; -- SAVEPOINT 지정

INSERT INTO DEPARTMENT2 VALUES('T6', '개발6팀', 'L2');
SAVEPOINT "SP3"; -- SAVEPOINT 지정

SELECT * FROM DEPARTMENT2;

-- 개발팀 전체 삭제해보기

DELETE FROM DEPARTMENT2
WHERE DEPT_ID LIKE 'T%';

-- SP2 지점까지 롤백

ROLLBACK TO "SP2";

SELECT * FROM DEPARTMENT2;
-- 개발 6팀만 없음(SP2 지점 SAVEPOINT 전 개발 5팀, 개발 4팀 있었으므로)

ROLLBACK TO "SP1";
SELECT * FROM DEPARTMENT2;

-- ROLLBACK 수행
ROLLBACK; -- 마지막 커밋 시점 기준
SELECT * FROM DEPARTMENT2;
-- 개발 1,2,3 팀 남음

----------------------------------------------------------------------
-- 연습문제
SELECT * FROM EMPLOYEE;

-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오 (단, 전지연은 제외)
-- 사번, 사원명, 전화번호, 고용일, 부서명
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연'; -- 'D1'

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

SELECT DEPT_CODE, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
									FROM EMPLOYEE
									WHERE EMP_NAME = '전지연')
AND EMP_NAME != '전지연';

-- 2. 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원의
-- 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오.
SELECT EMP_ID, EMP_NAME, PHONE, SALARY, JOB_NAME
FROM EMPLOYEE
WHERE(SALARY) = (SELECT MAX(SALARY)
FROM EMPLOYEE 
WHERE EXTRACT(YEAR FROM HIRE_DATE)> 2000
AND HIRE_DATE IS NOT NULL)
AND EXTRACT(YEAR FROM HIRE_DATE) > 2000;



-- 3. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명
SELECT DEPT_CODE, EMP_NAME, DEPT_CODE, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE (DEPT_CODE, JOB_CODE) =  (SELECT DEPT_CODE, JOB_CODE
				FROM EMPLOYEE
				WHERE EMP_NAME = '노옹철')
AND EMP_NAME != '노옹철';

-- 4. 2000년도에 입사한 사원과 부서와 직급이 같은 사원을 조회하시오
-- 사번, 이름, 부서코드, 직급코드, 고용일
SELECT DEPT_CODE, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
--WHERE EXTRACT (YEAR FROM HIRE_DATE) = 2000;-- 유재식
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE(DEPT_CODE, JOB_CODE) =(SELECT DEPT_CODE, JOB_CODE
														FROM EMPLOYEE
														WHERE EMP_NAME = '유재식');


-- 5. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일
SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) IN (SELECT DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE EMP_NO LIKE '77%'
AND SUBSTR(EMP_NO, 8, 1)= '2');

-- 6. 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하시오
-- 단, 퇴사한 직원은 제외하고 조회..
SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
-- WHERE ENT_YN = 'N'
WHERE HIRE_DATE = (SELECT MIN(HIRE_DATE)
									FROM EMPLOYEE SUB
									WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE
									AND ENT_YN = 'N' 
									OR (SUB.DEPT_CODE IS NULL AND MAIN.DEPT_CODE IS NULL))
WHERE ENT_YN = 'N'
ORDER BY HIRE_DATE;



-- 7. 직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
-- 단 연봉은 \124,800,000 으로 출력되게 하세요. (\ : 원 단위 기호)








