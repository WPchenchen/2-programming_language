<%@ Language="VBScript" %>
<%
' ==== 定义一些数据 (模拟数据库) ====
Dim customers(2,2)
customers(0,0) = "C001"
customers(0,1) = "张三"
customers(0,2) = "zhangsan@example.com"

customers(1,0) = "C002"
customers(1,1) = "李四"
customers(1,2) = "lisi@example.com"

customers(2,0) = "C003"
customers(2,1) = "王五"
customers(2,2) = "wangwu@example.com"

' ==== 读取查询参数 ====
Dim keyword
keyword = Request.QueryString("q")
%>

<html>
<head>
<title>客户列表 (ASP 示例)</title>
<style>
    body { font-family: Arial; margin: 20px; }
    table { border-collapse: collapse; width: 70%; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background: #eee; }
</style>
</head>
<body>
<h2>客户信息</h2>

<!-- 搜索表单 -->
<form method="get" action="example.asp">
    搜索姓名: <input type="text" name="q" value="<%=keyword%>">
    <input type="submit" value="搜索">
</form>
<br>

<table>
<tr><th>ID</th><th>姓名</th><th>Email</th></tr>
<%
' ==== 遍历数组，按条件输出 ====
Dim i
For i = 0 To UBound(customers,1)
    If keyword = "" Or InStr(customers(i,1), keyword) > 0 Then
        Response.Write("<tr>")
        Response.Write("<td>" & customers(i,0) & "</td>")
        Response.Write("<td>" & customers(i,1) & "</td>")
        Response.Write("<td>" & customers(i,2) & "</td>")
        Response.Write("</tr>")
    End If
Next
%>
</table>

</body>
</html>
