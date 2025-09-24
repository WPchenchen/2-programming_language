https://blog.csdn.net/m0_46563938/article/details/109075124

##  一、基础 SQL 语法示例

### 1. 数据库和表操作

```
sql复制编辑-- 创建数据库
CREATE DATABASE company;

-- 使用数据库
USE company;

-- 创建表
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);
```

### 2. 数据操作（DML）

```
-- 插入数据
INSERT INTO employees (id, name, position, salary, hire_date)
VALUES (1, 'Alice', 'Manager', 8000.00, '2020-01-01');

"""INSERT INTO cam_info_t (cam_id, area_id, cam_lng, cam_lat, cam_status, cam_name, organization_id) VALUES (%s,%s,%s,%s,%s,%s,%s);"""

-- 查询数据
SELECT * FROM employees;

 cam_name_dup_sql = """SELECT COUNT(*) FROM cam_info_t WHERE cam_name = '{}'""".format(cam_name)

-- 更新数据
UPDATE employees
SET salary = 8500.00
WHERE name = 'Alice';

-- 删除数据
DELETE FROM employees
WHERE id = 1;
```

### 3. 条件、排序、分页

```
sql复制编辑SELECT * FROM employees
WHERE salary > 5000
ORDER BY hire_date DESC
LIMIT 10 OFFSET 0;
```

------

## 🟡 二、中级 SQL 语法示例

### 1. 聚合函数与分组

```
sql复制编辑SELECT position, COUNT(*) AS count, AVG(salary) AS avg_salary
FROM employees
GROUP BY position
HAVING AVG(salary) > 5000;
```

### 2. 联合与连接

```
sql复制编辑-- UNION 合并结果集
SELECT name FROM employees
UNION
SELECT client_name FROM clients;

-- INNER JOIN
SELECT e.name, d.name AS department
FROM employees e
INNER JOIN departments d ON e.dept_id = d.id;

-- LEFT JOIN
SELECT e.name, d.name AS department
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.id;
```

### 3. 子查询

```
sql复制编辑-- 在WHERE中使用子查询
SELECT name
FROM employees
WHERE salary > (
    SELECT AVG(salary) FROM employees
);

-- 在FROM中使用子查询（内联视图）
SELECT dept_avg.*
FROM (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
) AS dept_avg;
```

------

## 🔴 三、高级（进阶）SQL 语法示例

### 1. 窗口函数（Window Functions）

```
sql复制编辑SELECT name, salary,
       RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
FROM employees;
```

### 2. 公共表表达式（CTE）

```
sql复制编辑WITH TopEarners AS (
    SELECT name, salary
    FROM employees
    WHERE salary > 7000
)
SELECT * FROM TopEarners;
```

### 3. 递归 CTE（树形结构查询）

```
sql复制编辑WITH RECURSIVE OrgChart AS (
    SELECT id, name, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.id, e.name, e.manager_id
    FROM employees e
    JOIN OrgChart o ON e.manager_id = o.id
)
SELECT * FROM OrgChart;
```

### 4. 事务处理（事务控制语句）

```
sql复制编辑BEGIN;

UPDATE accounts SET balance = balance - 1000 WHERE id = 1;
UPDATE accounts SET balance = balance + 1000 WHERE id = 2;

COMMIT; -- 或 ROLLBACK;
```

### 5. 存储过程 & 函数（以MySQL为例）

```
sql复制编辑-- 存储过程
DELIMITER //
CREATE PROCEDURE GiveRaise(IN emp_id INT, IN raise DECIMAL(10, 2))
BEGIN
    UPDATE employees
    SET salary = salary + raise
    WHERE id = emp_id;
END;
//
DELIMITER ;

-- 调用
CALL GiveRaise(1, 500.00);
```

### 6. 触发器（Trigger）

```
sql复制编辑CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SET NEW.salary = 0;
    END IF;
END;
```

------

## 🔶 四、其他进阶技巧

### 1. JSON 操作（以 PostgreSQL 为例）

```
sql复制编辑-- 查询JSON字段
SELECT data->>'name' AS name
FROM employees_json
WHERE data->>'position' = 'Manager';
```

### 2. 动态SQL（以 PostgreSQL 为例）

```
sql复制编辑DO $$
BEGIN
    EXECUTE 'UPDATE employees SET salary = salary * 1.10 WHERE dept_id = 3';
END $$;
```