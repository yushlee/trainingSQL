DROP TABLE TABLE_A;

-- 主鍵可以包含一或多個欄位。當主鍵包含多個欄位時，稱為組合鍵 (Composite Key)
CREATE TABLE TABLE_A
(
  PK_1 NUMERIC(5),
  PK_2 NUMERIC(5),
  CONSTRAINT TABLE_A_PK PRIMARY KEY (PK_1, PK_2)
);
