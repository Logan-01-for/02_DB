--사례1. 사용자 계정을 만들기 위해 일반 사용자 계정인 TEST계정으로 접속하여 계정이 SAMPLE 비밀번호가 1234인
--계정을 생성하기 위해 CREATE USER SAMPLE; 를 실행하니 정상적으로 실행이 되지 않았다.
--또한 계정을 생성(CREATE명령만 실행 함)을 하여서 접속하려는 데 접속이 되지 않고 테이블도 생성되지 않았다.
--위 문제의 원인과 ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;문제를 해결하기 위한 조치내용을 기술하시오. (50점)
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
--구버전 오라클로 유저 만드는 구문
CREATE USER SAMPLE IDENTIFIED BY 1234;
-- 계정에 CONNECT 권한 부여 (로그인 권한)
GRANT CREATE SESSION TO SAMPLE; -- 유저 만드는 권한
ALTER USER SAMPLE DEFULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;
-- 계정에 RESOURCE 권한 부여 (테이블 생성, 수정 등의 권한)
ALTER USER SAMPLE DEFAULT TABLESPACE
SYSTEM QUOTA UNLIMITED ON SYSTEM; --테이블 공간 할당 권한


--사례2. 아래 테이블이 있다는 가정하에 다음 조건에 맞는 사원을 조회하려고 SQL구문을 작성했는데 제대로된 결과가
--출력되지 않았다. SQL구문을 보고 문제를 찾고 원인에 작성하고 제대로된 SQL문을 조치사항에 작성하시오. (50점)

--<검색조건>
--DEPT_CODE가 D9이거나 D6이고 SALARY이 300만원 이상이고 BONUS가 있고
--남자이고 이메일주소가 _ 앞에 3글자 있는
--사원의 EMP_NAME, EMP_NO, DEPT_CODE, SALARY를 조회

--<작성된 쿼리구문>
SELECT EMP_NAME, EMP_NO, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE='D9' OR DEPT_CODE='D6' AND SALARY > 3000000
AND SUBSTR(EMP_NO, 8, 1) = '1' AND EMAIL LIKE '____%' AND BONUS IS NOT NULL;
-- 보너스가 있고 구문으로 변경하였습니다
-- 남자를 정의하는 구문을 추가 하였습니다

