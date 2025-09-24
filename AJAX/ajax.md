[TOC]

AJAX 是开发者的梦想，因为您能够：

- 不刷新页面更新网页
- 在页面加载后从服务器请求数据
- 在页面加载后从服务器接收数据
- 在后台向服务器发送数据

## XMLHttpRequest 对象方法

| 方法                                          | 描述                                                         |
| :-------------------------------------------- | :----------------------------------------------------------- |
| new XMLHttpRequest()                          | 创建新的 XMLHttpRequest 对象。                               |
| abort()                                       | 取消当前请求。                                               |
| getAllResponseHeaders()                       | 返回头部信息。                                               |
| getResponseHeader()                           | 返回特定的头部信息。                                         |
| open(*method*, *url*, *async*, *user*, *psw*) | 规定请求。*method*：请求类型 GET 或 POST*url*：文件位置*async*：true（异步）或 false（同步）*user*：可选的用户名*psw*：可选的密码 |
| send()                                        | 向服务器发送请求，用于 GET 请求。                            |
| send(string)                                  | 向服务器发送请求，用于 POST 请求。                           |
| setRequestHeader()                            | 将标签/值对添加到要发送的标头。                              |

## XMLHttpRequest 对象属性(onload、onreadystatechange)

| 属性               | 描述                                                         |
| :----------------- | :----------------------------------------------------------- |
| onload             | 定义接收到（加载）请求时要调用的函数。                       |
| onreadystatechange | 定义当 readyState 属性发生变化时调用的函数。                 |
| readyState         | 保存 XMLHttpRequest 的状态。0：请求未初始化1：服务器连接已建立2：请求已收到3：正在处理请求4：请求已完成且响应已就绪 |
| responseText       | 以字符串形式返回响应数据。                                   |
| responseXML        | 以 XML 数据返回响应数据。                                    |
| status             | 返回请求的状态号200: "OK"403: "Forbidden"404: "Not Found"如需完整列表请访问 [Http 消息参考手册](https://www.w3school.com.cn/tags/html_ref_httpmessages.asp) |
| statusText         | 返回状态文本（比如 "OK" 或 "Not Found"）                     |

**XMLHttpRequest 对象是 AJAX 的基石。**

1. 创建 XMLHttpRequest 对象

   ```js
   variable = new XMLHttpRequest();
   ```

2. 定义回调函数

   ```js
   xhttp.onload = function() {
     // 当响应准备就绪时要做什么
     document.getElementById("demo").innerHTML = this.responseText;
   
   }
   ```

3. 打开 XMLHttpRequest 对象

4. 向服务器发送请求

   ```js
   xhttp.open("GET", "ajax_info.txt",true);//是否异步
   xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
   xhttp.send();
   ```

## onreadystatechange 属性

`readyState` 属性保存 XMLHttpRequest 的状态。

`onreadystatechange` 属性定义了一个回调函数，当 readyState 改变时执行该函数。

`status` 属性和 `statusText` 属性保存 XMLHttpRequest 对象的状态。

| 属性               | 描述                                                         |
| :----------------- | :----------------------------------------------------------- |
| onreadystatechange | 定义当 readyState 属性改变时调用的函数。                     |
| readyState         | 保存 XMLHttpRequest 的状态。0：请求未初始化1：服务器连接已建立2：请求已收到3：正在处理请求4：请求已完成且响应已就绪 |
| status             | 返回请求的状态号200: "OK"403: "Forbidden"404: "Not Found"如需完整列表请访问 [Http 消息参考手册](https://www.w3school.com.cn/tags/html_ref_httpmessages.asp) |
| statusText         | 返回状态文本（比如 "OK" 或 "Not Found"）。                   |

```js
#每次 readyState 改变时都会调用 onreadystatechange 函数。
#当 readyState 为 4 且 status 为 200 时，响应就绪：
function loadDoc() {
  const xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("demo").innerHTML =
      this.responseText;//xhttp.responseXML
    }
  };
  xhttp.open("GET", "ajax_info.txt");
  xhttp.send();
}
```

## 案例

```
<!DOCTYPE html>
<html>
<body>

<h1>XMLHttpRequest 对象</h1>

<h2>请在下面的输入字段中键入字母 A-Z：</h2>

<p>搜索建议：<span id="txtHint"></span></p> 

<p>姓名：<input type="text" id="txt1" onkeyup="showHint(this.value)"></p>

<script>
function showHint(str) {
  var xhttp;
  if (str.length == 0) { 
    document.getElementById("txtHint").innerHTML = "";
    return;
  }
  xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("txtHint").innerHTML = this.responseText;
    }
  };
  xhttp.open("GET", "/demo/gethint.php?q="+str, true);
  xhttp.send();   
}
</script>

</body>
</html>
```

gethint.php文件：

```
<?php
// 姓名数组
 $a[] = "Ava";
 $a[] = "Brielle";
 $a[] = "Caroline";
 $a[] = "Diana";
 $a[] = "Elise";
 $a[] = "Fiona";
 $a[] = "Grace";
 $a[] = "Hannah";
 $a[] = "Ileana";
 $a[] = "Jane";
 $a[] = "Kathryn";
 $a[] = "Laura";
 $a[] = "Millie";
 $a[] = "Nancy";
 $a[] = "Opal";
 $a[] = "Petty";
 $a[] = "Queenie";
 $a[] = "Rose";
 $a[] = "Shirley";
 $a[] = "Tiffany";
 $a[] = "Ursula";
 $a[] = "Victoria";
 $a[] = "Wendy";
 $a[] = "Xenia";
 $a[] = "Yvette";
 $a[] = "Zoe";
 $a[] = "Angell";
 $a[] = "Adele";
 $a[] = "Beatty";
 $a[] = "Carlton";
 $a[] = "Elisabeth";
 $a[] = "Violet";
// 从 URL 获取 q 参数
$q = $_REQUEST["q"];

$hint = "";

// 查看数组中所有 hint，$q 是否与 "" 相同
if ($q !== "") {
    $q = strtolower($q);
    $len=strlen($q);
    foreach($a as $name) {
        if (stristr($q, substr($name, 0, $len))) {
            if ($hint === "") {
                $hint = $name;
            } else {
                $hint .= ", $name";
            }
         }
    }
}

// 输出 "no suggestion"，如果未找到 hint 或输出正确的值
  echo $hint === "" ? "no suggestion" : $hint;
?>
```

gethint.asp文件替换.php即可

```
<%
 response.expires=-1
 dim a(32)
 '用姓名填充数组
 a(1)="Ava"
 a(2)="Brielle"
 a(3)="Caroline"
 a(4)="Diana"
 a(5)="Elise"
 a(6)="Fiona"
 a(7)="Grace"
 a(8)="Hannah"
 a(9)="Ileana"
 a(10)="Jane"
 a(11)="Kathryn"
 a(12)="Laura"
 a(13)="Millie"
 a(14)="Nancy"
 a(15)="Opal"
 a(16)="Petty"
 a(17)="Queenie"
 a(18)="Rose"
 a(19)="Shirley"
 a(20)="Tiffany"
 a(21)="Ursula"
 a(22)="Victoria"
 a(23)="Wendy"
 a(24)="Xenia"
 a(25)="Yvette"
 a(26)="Zoe"
 a(27)="Angell"
 a(28)="Adele"
 a(29)="Beatty"
 a(30)="Carlton"
 a(31)="Elisabeth"
 a(32)="Violet"

 '从 URL 获取 q 参数
 q=ucase(request.querystring("q"))

 '查看数组中所有 hint，q 的长度是否大于 0
 if len(q)>0 then
   hint=""
   for i=1 to 30
     if q=ucase(mid(a(i),1,len(q))) then
       if hint="" then
         hint=a(i)
       else
         hint=hint & " , " & a(i)
       end if
     end if
   next
 end if

 '如果未找到 hint，输出 "no suggestion"，或输出正确的值
 if hint="" then
   response.write("no suggestion")
 else
   response.write(hint)
 end if
%>
```

## 网页通过 AJAX 从数据库中读取信息

"showCustomer()" 函数。此函数被 `onchange` 事件触发

```js
function showCustomer(str) {
  var xhttp; 
  if (str == "") {
    document.getElementById("txtHint").innerHTML = "";
    return;
  }
  xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState  == 4 && this.status == 200) {
    document.getElementById("txtHint").innerHTML  = this.responseText;
    }
  };
  xhttp.open("GET",  "getcustomer.asp?q=" + str, true);
  xhttp.send();
} 
```

getcustomer.asp文件  (Access 数据库文件mdb文件)

```html
<%
response.expires=-1
sql="SELECT * FROM CUSTOMERS WHERE CUSTOMERID="
sql=sql & "'" & request.querystring("q") & "'"

set conn=Server.CreateObject("ADODB.Connection")
conn.Provider="Microsoft.Jet.OLEDB.4.0"
conn.Open(Server.Mappath("customers.mdb"))
set rs=Server.CreateObject("ADODB.recordset")
rs.Open sql,conn

response.write("<table>")
do until rs.EOF
 for each x in rs.Fields
   response.write("<tr><td><b>" & x.name & "</b></td>")
   response.write("<td>" & x.value & "</td></tr>")
 next
 rs.MoveNext
loop
response.write("</table>")
%>
```

## fetch新的使用方法

```
 function sendValue(id) {
          clickCount++;
          var valueToSend = clickCount % 2; // 确定要发送的值（1 或 0）
          console.log('开始预览')
          // 发送数据到后端路由
          fetch("/CameraDisplay", {
              method: "POST",
              body: JSON.stringify({ value: valueToSend,camid: id}), // 将值包装为 JSON 
              headers: {
                  "Content-Type": "application/json"
              }
          })
          .then(response => {
              if (!response.ok) {
                  throw new Error("网络错误");
              }
              return response.json();
          })
          .then(data => {
              console.log("后端返回的数据:", data);
              // 在这里可以根据后端返回的数据执行其他操作
          })
          .catch(error => {
              console.error("发生错误:", error);
          });
      }
```

