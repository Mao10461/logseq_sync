---
title: SQL
---

- 安裝Oracle SQL client
	 - (Optional) Get the latest repository info.
		 - 
```bash
cd /etc/yum.repos.d
rm -f public-yum-ol7.repo
wget https://yum.oracle.com/public-yum-ol7.repo

```

	 - Enable the instant client repository
		 - 
```bash
yum install -y yum-utils
yum-config-manager --enable ol7_oracle_instantclient

# (Optional) Check what packages are available.
yum list oracle-instantclient*

```

	 - Install basic and sqlplus
		 - 
```bash
yum install -y oracle-instantclient18.3-basic oracle-instantclient18.3-sqlplus

```

	 - add to bashrc
		 - 
```bash
vim ~/.bashrc
export CLIENT_HOME=/usr/lib/oracle/18.3/client64
export LD_LIBRARY_PATH=$CLIENT_HOME/lib
export PATH=$PATH:$CLIENT_HOME/bin

```
