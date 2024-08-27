---
title: R
---

- 出現lib版本太舊的情況
	 - 
```bash
/usr/lib/rstudio-server/bin/rsession: /lib64/libstdc++.so.6: version "'CXXABI_1.3.8' not found'"

```

	 - 查看lib中包含的package版本
		 - 
```bash
strings /lib64/libstdc++.so.6 | grep CXXABI
strings /home/poliang/.conda/envs/seurat4/lib/R/lib/../../libstdc++.so.6.0.28 | grep CXXABI

```

	 - 找系統中新版本的lib
		 - 
```bash
find / -name "libstdc++.so.*"

```

	 - 更新lib 連結
		 - 
```bash
cd /lib64/
rsync -avP /home/anaconda2/lib/libstdc++.so.6.0.28 ./
ln -s libstdc++.so.6.0.28 libstdc++.so.6

```

- 

- 指定Rstudio使用conda中的R及library #seurat
	 - 
```bash
conda activate seurat4
/usr/lib/rstudio-server/bin/rserver \
   --server-daemonize=0 \
   --www-port 8989 \
   --rsession-which-r=$(which R) \
   --rsession-ld-library-path=~/.conda/envs/seurat4/lib/R/library

```

	 - 
```bash
conda activate Singlecell
/usr/lib/rstudio-server/bin/rserver \
   --server-daemonize=0 \
   --www-port 8989 \
   --rsession-which-r=$(which R) \
   --rsession-ld-library-path=/home/miniconda3/envs/singlecell/lib/R/library

```

	 - 
```bash
conda activate seurat
sudo /usr/lib/rstudio-server/bin/rserver \
   --server-daemonize=0 \
   --www-port 8987 \
   --rsession-which-r=$(which R) \
   --rsession-ld-library-path=/home/miniconda3/envs/seurat/lib/R/library

```

	 - 
```bash
.libPaths('/home/miniconda3/envs/seurat/lib/R/library')
myPaths <- .libPaths()
myPaths <- c(myPaths, '/usr/lib/R/library')
.libPaths(myPaths)

```

	 - 
```bash
sudo rstudio-server restart

```

- 

- 在Rstudio中修改預設library
	 - 
```r
.libPaths('/usr/lib/R/library')

myPaths <- .libPaths()
myPaths <- c(myPaths, '/usr/lib/R/library')
.libPaths(myPaths)

```

- 

- Centos 8 install R and rstudio-server
	 - 
```bash
dnf install epel-release
dnf install 'dnf-command(config-manager)'
dnf config-manager --set-enabled PowerTools
dnf install R

```

- install Rstudio-server
	 - 
```bash
wget https://download2.rstudio.org/server/centos8/x86_64/rstudio-server-rhel-1.3.1056-x86_64.rpm
sudo yum install rstudio-server-rhel-1.3.1056-x86_64.rpm

sudo systemctl status rstudio-server.service
sudo systemctl enable rstudio-server.service

sudo firewall-cmd --permanent --zone=public --add-port=8787/tcp
sudo firewall-cmd --reload

sudo yum groupinstall "Development Tools" -y
sudo -i R

```

	 - 
```R
install.packages('txtplot')
q()

```

- 
