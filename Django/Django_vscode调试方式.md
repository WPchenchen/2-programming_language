来源[Django 创建项目与创建应用的详解 | 程序员笔记](https://www.knowledgedict.com/tutorial/django-create-project.html)

```
project_name/                 # 项目主目录
    manage.py                 # Django 管理命令脚本
    project_name/             # 项目设置目录
        __init__.py
        settings.py           # 项目设置文件
        urls.py               # 项目 URL 配置
        asgi.py               # ASGI 服务器配置
        wsgi.py               # WSGI 服务器配置
        templates/            # 项目级别模板目录
            base.html
            index.html
    static/                   # 静态文件目录 (CSS, JavaScript, 图像等)
        css/
        js/
        images/
    app1/                     # 应用目录（可以有多个应用）
        __init__.py
        admin.py              # 管理后台配置
        apps.py               # 应用配置
        migrations/           # 数据库迁移目录
            __init__.py
        models.py             # 数据模型
        tests.py              # 单元测试
        views.py              # 视图
        templates/            # 应用级别模板目录
            app1/
                template1.html
                template2.html
        static/
            app1/
                css/
                js/
                images/
    app2/
        ...
```



```
{
    "version": "0.2.0",
    "configurations": [
        

        {
            "name": "Python: Django",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/manage.py",
            "args": [
                "runserver",
                "7999"
            ],
            "django": true
        }
    ]

}
```

vscode的Django调试方式

[Django4全栈进阶之路3 apps.py 文件 - 侬侬发 - 博客园](https://www.cnblogs.com/beichengshiqiao/p/17346716.html)

应用下的APP配置文件管理