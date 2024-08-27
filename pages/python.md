---
title: python
---

- 更新 Python 3.8
	 - 
```bash
sudo wget https://www.python.org/ftp/python/3.8.9/Python-3.8.9.tgz
sudo tar -zxvf Python-3.8.9.tgz ; cd Python-3.8.9
./configure --enable-optimizations; sudo make -j$(nproc) altinstall; cd ..
python3.8 -m venv venv
ln -s venv/bin/activate
. ./activate
pip install --upgrade pip

```

- 

- 重新安裝 python 及 yum
	 - 1、删除已有的Python
		 - 
```bash
rpm -qa|grep python|xargs rpm -ev --allmatches --nodeps
whereis python |xargs rm -frv
whereis python

```

	 - 2、删除已有的yum
		 - 
```bash
rpm -qa|grep yum|xargs rpm -ev --allmatches --nodeps
whereis yum |xargs rm -frv

```

	 - 3、 创建目录用于存放Python和yum的rpm包
		 - 
```bash
mkdir /usr/local/src/python

```

	 - 4. 查看centOS的版本并下载相应的rpm包
		 - 
```bash
对应的rpm包下载网址：http://mirrors.163.com/centos/7/os/x86_64/Packages/

```

	 - 5、进入到python目录下
		 - 
```bash
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/lvm2-python-libs-2.02.187-6.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/libxml2-static-2.9.1-6.el7.5.x86_64.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-libs-2.7.5-89.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-ipaddress-1.0.16-2.el7.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-backports-1.0-8.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-2.7.5-89.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-iniparse-0.4-9.el7.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-pycurl-7.19.0-19.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-urlgrabber-3.10-10.el7.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-setuptools-0.9.8-7.el7.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-kitchen-1.1.1-5.el7.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/python-chardet-2.2.1-3.el7.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/rpm-python-4.11.3-45.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-utils-1.1.31-54.el7_8.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-3.4.3-168.el7.centos.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-plugin-aliases-1.1.31-54.el7_8.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-plugin-protectbase-1.1.31-54.el7_8.noarch.rpm
wget http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch.rpm

```

	 - 6、下载完成后执行
		 - 
```bash
rpm -Uvh --replacepkgs lvm2-python-libs*.rpm --nodeps --force
rpm -Uvh --replacepkgs libxml2-*.rpm --nodeps --force
rpm -Uvh --replacepkgs python*.rpm --nodeps --force
rpm -Uvh --replacepkgs rpm-python*.rpm yum*.rpm --nodeps --force

```

- 

- 使用if else 更新dict
	 - 
```python
di = {
    'name': 'xyz',
    'access_grant': 'yes' if age >= 18 else 'no',
 } 

def access_grant(age):
    if age >= 18:
        return 'yes'
    return 'no'

age = 22
di = {
    'name': 'xyz',
    'access_grant': access_grant(age),
}

```

- 更新dict key
	 - Easily done in 2 steps:
		 - id:: 65e7d1ea-b044-492a-95fd-45483c84095f

```python
dictionary[new_key] = dictionary[old_key]
del dictionary[old_key]

```

	 - Or in 1 step:
		 - 
```python
dictionary[new_key] = dictionary.pop(old_key)
which will raise KeyError if dictionary[old_key] is undefined. Note that this will delete dictionary[old_key]

```

	 - 
```python
>>> dictionary = { 1: 'one', 2:'two', 3:'three' }
>>> dictionary['ONE'] = dictionary.pop(1)
>>> dictionary
{2: 'two', 3: 'three', 'ONE': 'one'}
>>> dictionary['ONE'] = dictionary.pop(1)
Traceback (most recent call last):
  File "<input>", line 1, in <module>
KeyError: 1

```

- 開啟Jupyter Lab #jupyter
	 - 
```bash
jupyter lab --ip 0.0.0.0 --no-browser --port=8383 --allow-root

```
