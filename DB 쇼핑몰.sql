-- 쇼핑몰 DB 연습문제
-- 사용자 계정 새로 생성해서 풀것 (계정명 : kh_shop)
-- 컬럼 별칭 작성할 것.
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE USER kh_shop IDENTIFIED BY kh_shop;
-- 계정에 CONNECT 권한 부여 (로그인 권한)
GRANT RESOURCE, CONNECT TO kh_shop;
ALTER USER kh_shop DEFULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM; 

-- 계정에 RESOURCE 권한 부여 (테이블 생성, 수정 등의 권한)

-- 1. 카테고리 테이블 (CATEGORIES)
-- 카테고리 ID (CATEGORY_ID) - NUMBER [PK]
-- 카테고리 이름 (CATEGORY_NAME) - VARCHAR2(100) [UNIQUE]
-- 1). (계정명 : kh_shop)
CREATE TABLE CATEGORIES (
CATEGORIES_ID NUMBER PRIMARY KEY,
CATEGORIES_NAME VARCHAR2(100) UNIQUE
);


-- 2. 상품 정보 테이블 (PRODUCTS)
-- 상품 코드 (PRODUCT_ID) - NUMBER [PK]
-- 상품 이름 (PRODUCT_NAME) - VARCHAR2(100) [NOT NULL]
-- 카테고리 (CATEGORY) - NUMBER [FK - CATEGORIES(CATEGORY_ID)]
-- 가격 (PRICE) - NUMBER [DEFAULT 0]
-- 재고량 (STOCK_QUANTITY) NUMBER [DEFAULT 0]
CREATE TABLE PRODUCTS(
PRODUCTS_ID NUMBER PRIMARY KEY,
PRODUCTS_NAME VARCHAR2(100) NOT NULL,
PRODUCTS_CATEGORY NUMBER REFERENCES CATEGRORIES,-- [FK_CATEGORIES(CATEGORY_ID)],
PRODUCTS_PRICE NUMBER DEFAULT 0,
PRODUCTS_STOCK_QUANTITY NUMBER DEFAULT 0
);
SELECT * FROM PRODUCTS;


INSERT INTO "PRODUCTS" VALUES(101, 'AppleiPhone', 1, 1500000, 30);
INSERT INTO "PRODUCTS" VALUES(102, 'SamsungGalaxyS24', 1, 1800000, 50);
INSERT INTO "PRODUCTS" VALUES(201, 'LGOLEDTV', 2, 3600000, 10);
INSERT INTO "PRODUCTS" VALUES(301, 'SonyPlayStation5', 3, 700000, 15);

SELECT * FROM PRODUCTS;

COMMIT;

-- 3. 고객 정보 테이블 (CUSTOMERS)
-- 고객 ID (CUSTOMER_ID) - NUMBER [PK]
-- 이름 (NAME) - VARCHAR2(20) [NOT NULL]
-- 성별 (GENDER) - CHAR(3) [CHECK 남, 여]
-- 주소 (ADDRESS) - VARCHAR2(100)
-- 전화번호 (PHONE) - VARCHAR2(30)
-- CUSTOMERS 테이블 생성
CREATE TABLE CUSTOMERS (
CUSTMER_ID NUMBER PRIMARY KEY,
NAME VARCHAR2(20) NOT NULL,
GENDER CHAR(3) CHECK (MEMBER_GENDER IN ('남', '여')),
ADDRESS VARCHAR2(100),
PHONE VARCHAR2(30)
);
-- 만든 테이블 확인
SELECT * FROM "MEMBER";

COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_GENDER IS '회원 성별';
COMMENT ON COLUMN MEMBER.MEMBER_ADDRESS IS '회원 주소';
COMMENT ON COLUMN MEMBER.MEMBER_PHONE IS '회원 전화번호';

INSERT INTO "MEMBER" VALUES ('MEM01', '123ABC', '홍길동', 
'남', '서울시 성동구 왕십리', '010-1111-2222');

INSERT INTO "MEMBER" VALUES ('MEM02', '345DEF', '유관순', 
'여', '서울시 종로구 안국동', '010-3333-1111');

SELECT * FROM MEMBER;

-- 데이터 삽입 확인
SELECT * FROM MEMBER;

COMMIT;

-- 4. 주문 정보 테이블 (ORDERS)
-- 주문 번호 (ORDER_ID) - NUMBER [PK]
-- 주문일 (ORDER_DATE) - DATE [DEFAULT SYSDATE]
-- 처리상태 (STATUS) - CHAR(1) [CHECK ('Y', 'N') DEFAULT 'N']
-- 고객 ID (CUSTOMER_ID) - NUMBER [FK - CUSTOMERS(CUSTOMER_ID) ON DELETE CASCADE]

CREATE TABLE ORDERS (
ORDER_ID NUMBER PRIMARY KEY,
ORDER_DATE DATE DEFAULT SYSDATE,
ORDER_STATUS CHAR(1) CHECK (ORDER_STATUS IN('Y', 'N')) DEFAULT 'N',
ORDER_CUSTOMER_ID NUMBER FOREIGN KEY (ORDER_CUSTOMER_ID) ON DELETE CASCADE
);



-- 5. 주문 상세 정보 테이블 (ORDER_DETAILS)
-- 주문 상세 ID (ORDER_DETAIL_ID) - NUMBER [PK]
-- 주문 번호 (ORDER_ID) NUMBER - [FK - ORDERS(ORDER_ID) ON DELETE CASCADE]
-- 상품 코드 (PRODUCT_ID) NUMBER - [FK - PRODUCTS(PRODUCT_ID) ON DELETE SET NULL]
-- 수량 (QUANTITY) NUMBER
-- 가격 (PRICE_PER_UNIT) NUMBER
CREATE TABLE ORDER_DETAILS( 
ORDER_DETAIL_ID VARCHAR2(20),
ORDER_ID VARCHAR2(20),
ORDER 


