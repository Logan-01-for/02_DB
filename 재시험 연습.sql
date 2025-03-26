--[요구사항]
--관리자 계정으로 접속 후
--계정명 : sample02., 비밀번호 : 1234 로 사용자 계정 생성
CREATE USER sample02 IDENTIFIED BY 1234;
--sample02 계정에 DB 접속 및 객체 생성 권한 부여
GRANT CONNECT, RESOURCE TO sample02;
--생성한 사용자 계정으로 접속 후 TBLUSER, TB_BOARD 테이블 생성 TB_USER 테이블
--1) USER ID 걸림에 PRIMARY KEY 제약조건 설정
--2) USER_PWD 컬럼에 NOT NULL 제약조건 설정.
--3) USER_EMAIL 컬럼에 USER_EMAIL_UNQ 제약조건명을 가진 UNIQUE 제약조건 설정
CREATE TABLE TB_USER(
	USER_ID VARCHAR2(20) PRIMARY KEY,
	USER_PW VARCHAR2(20) NOT NULL,
	USER_NAME VARCHAR2(30),
	USER_AGE NUMBER,
	USER_EMAIL VARCHAR2(50),
	CONSTAINT USER_EMAIL_UNQ UNIQUE(USER_EMAIL)
);
-- - TB BOARD 테이블
--1) BOARD NO 컬럼에 PRIMARY KEY 제약조건 설정
--2) BOARD_WRITER 컬럼에 TB_USER 테이블의 MEMBER_ID들 참조하는 
--FOREIGN KEY 제약조건을 설정하되 부모 테이블 데이터 삭제 시 참조하고 있는 
--자식 테이블의 데이터도 삭제하는 옵션 추가.
--3) BOARD_REGDATE(작성일) 컬럼에 기본값 SYSDATE 설정

CREATE TABLE TB_BOARD(
	BOAD_NO NUMBER PRIMARY KEY
	BOAD_TITLE VARCHAR2(100),
	BOAD_CONTENT VARCHAR2(4000),
	BOAD_WRITER VARCHAR2(20) REFERENCES TB_USER(USER_ID) ON DELETE CASCADE,
	BOARD_REG_DATE DATE DEFAULT SYSDATE
	);