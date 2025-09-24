```
echo "# 2-programming_language" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M Master
git remote add origin https://github.com/WPchenchen/2-programming_language.git
git push -u origin Master
#本地和云端相同的分支Master，强行上传
git push --force origin main


#拉去远程分支到新的分支
	git checkout -b Master250829 origin/Master

#本地分支存在，同步远程分支
	# 切换到本地分支
	git checkout Master250829
	# 拉取远程更新并合并
	git pull origin Master250829
#删除分支
git branch -d branch_name
git push origin --delete branch_name
#合并分支
git merge Master250829 --allow-unrelated-histories
```



### deeplearn是回顾复习使用

本目录内容旨在分享cv算法工程师经常需要使用到的 `c/c++`、`python` 和 `shell` 编程语言的知识总结和学习笔记。

## cpp

* [c++基础-资源管理:堆栈与RAII](cpp/c++基础-资源管理:堆栈与RAII.md)
* [c++日期和时间编程总结](cpp/c++日期和时间编程总结.md)

## python

* [python3 编程面试题](python3/python3编程面试题.md)
* [numpy基础-堆叠数组函数总结](python3/numpy基础-堆叠数组函数总结.md)
* [python数据分析-pandas库入门](python3/python数据分析-pandas库入门.md)
* [python图像处理-读取图像方式总结](python3/python图像处理-读取图像方式总结.md)

=======
## cpp

## python

>>>>>>> Master250829
## shell

* [shell 语法基础](shell/shell语法基础.md)

<<<<<<< HEAD
## 参考资料

- 《C++ Primer 第五版》
- https://zh.cppreference.com/w/%E9%A6%96%E9%A1%B5
- 《Python3 教程-廖雪峰》
- 《菜鸟教程-shell》

=======
### AJAX
>>>>>>> Master250829
