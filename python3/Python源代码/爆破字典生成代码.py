import itertools as its

# 这里可以加入字母和其他字符
words = '0123456789'  # 要生成的密码成分，如果想生成有字母的密码可以自己随便加
r = its.product(words, repeat=8)  # 8即生成8位密码，正常热点密码位数为8

# 目标存储路径文件，密码本名称可以随便更改，个人建议先建好对应的文本
with open("password2.0.txt", 'a') as password_file:
    for i in r:
        password_file.write(''.join(i) + '\n')
        print(i)

print('密码本生成好了')