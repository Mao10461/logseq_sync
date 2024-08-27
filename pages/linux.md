---
title: linux
---

- iscsi mount
	 - 
```bash
sudo apt install open-iscsi
sudo apt install multipath-tools
vim /etc/multipath.conf

```

	 - 
```bash
defaults {
	user_friendly_names no
	max_fds max
	flush_on_last_del yes
	queue_without_daemon no
	dev_loss_tmo infinity
	fast_io_fail_tmo 5
}
# All data in the following section must be specific to your system.
blacklist {
	wwid "SAdaptec*"
	devnode "^hd[a-z]"
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^cciss.*"
}

devices {
	device {
		vendor "NETAPP"
		product "LUN"
		path_grouping_policy group_by_prio
		features "3 queue_if_no_path pg_init_retries 50"
		prio "alua"
		path_checker tur
		failback immediate
		path_selector "round-robin 0"
		hardware_handler "1 alua"
		rr_weight uniform
		rr_min_io 128
	}
}

```

	 - 
```bash
service multipath-tools start
vim /etc/iscsi/initiatorname.iscsi
InitiatorName=<value-from-the-Portal>

```

	 - 
```bash
systemctl restart iscsid.service

```

	 - 針對 iSCSI 陣列執行探索
		 - 
```bash
iscsiadm -m discovery -t sendtargets -p 192.168.0.46
192.168.0.46:3260,1 iqn.2004-04.com.qnap:ts-ec1680u:iscsi.qnas.03bbdc

```

	 - 登入裝置：
		 - 
```bash
iscsiadm –m node --targetname iqn.2004-04.com.qnap:ts-ec1680u:iscsi.qnas.03bbdc --login

```

	 - 登出裝置：
		 - 
```bash
iscsiadm –m node --targetname iqn.2004-04.com.qnap:ts-ec1680u:iscsi.qnas.03bbdc --logout

```

	 - 刪除裝置：
		 - 
```bash
iscsiadm –m node --op delete --targetname iqn.2004-04.com.qnap:ts-ec1680u:iscsi.qnas.03bbdc

```

	 - 配置自動登入
		 - 
```bash
sudo iscsiadm -m node --op=update -n node.conn[0].startup -v automatic
sudo iscsiadm -m node --op=update -n node.startup -v automatic

```

	 - 啟用必要的服務
		 - 
```bash
systemctl enable open-iscsi
systemctl enable iscsid

```

	 - 重新啟動 iscsid 服務
		 - 
```bash
systemctl restart iscsid.service

```

	 - 登入 iSCSI 陣列
		 - 
```bash
iscsiadm -m session -o show

```

	 - 請驗證存在多個路徑
		 - 
```bash
multipath -ll

```

	 - 請檢查 dmesg，確定偵測到新磁碟
		 - 
```bash
dmesg

```

	 - 建立分割區
		 - 
```bash
sudo fdisk /dev/mapper/mpatha

```

	 - 建立檔案系統
		 - 
```bash
sudo mkfs.ext4 /dev/mapper/mpatha-part1

```

	 - 裝載區塊裝置
		 - 
```bash
sudo mount /dev/mapper/mpatha-part1 /iscsi_nas

```

	 - 存取資料以確認新分割區及檔案系統已備妥可供使用。
		 - 
```bash
ls /iscsi_nas

```

	 - 完成後，您可以使用以下指令測試I/O速度
		 - 
```bash
hdparm -tT /dev/sdb1

```

	 - 

- 雙網卡 雙gateway
	 - 
```bash
route -n
sudo route delete default gw 172.22.115.254
sudo route delete default gw 192.168.1.1


sudo route delete default gw 172.22.116.250
sudo route delete default gw 192.168.1.1

sudo route add default gw 172.22.116.250
sudo route add default gw 192.168.1.1

sudo route add -net 172.22.0.0 netmask 255.255.0.0 gw 172.22.116.250
sudo route add -net 172.26.0.0 netmask 255.255.0.0 gw 172.22.116.250

```

- Steps to Create a New Sudo User #sudo
	 - Log in to your server as the root user
		 - 
```bash
ssh root@server_ip_address

```

	 - Use the adduser command to add a new user to your system
		 - 
```bash
adduser username

```

	 - Use the passwd command to update the new user’s password
		 - 
```bash
passwd username

```

	 - Use the usermod command to add the user to the wheel group
		 - usermod -aG wheel username
usermod -aG sudo username
usermod -aG docker username

newgrp docker

	 - 

- 只寫入檔名，不包含路徑
	 - 
```bash
find . -type f -name "*.CEL" | xargs -I {} basename {} > ../20230424_TPM2_cel_files.txt
mv ../cel_files.txt ./

```

- 將檔案完整路徑彙出為文字清單
	 - 
```bash
pwd | xargs -I % find % -type f >> ../cel_files.txt
pwd | xargs -I % find ./*/*.CEL -type f >> ../cel_files.txt

find . -maxdepth 2 -type f -name "*.CEL" -exec realpath {} \; > ../PCa_SNP_cel_files.txt

```

- 計算檔案數量
	 - 
```bash
find . -type d -print0 | while read -d '' -r dir; do
    files=("$dir"/*)
    printf "%5d files in directory %s\n" "${#files[@]}" "$dir"
done

find . -type d -print0 | while read -d '' -r dir; do
    files=("$dir"/*)
    printf "%s:%2d Samples\n" "$dir" "${#files[@]}" 
done

```

- 計算目錄中資料夾大小
	 - 
```bash
du -h -d 1

```

- Ubuntu apt-get update 出現 NO_PUBKEY / GPG error
	 - 當我們更新 Ubuntu/Debian 伺服器套件時，apt-get update 出現底下錯誤訊息
		 - 
```
W: GPG error: http://ppa.launchpad.net maverick Release: 
The following signatures couldn't be verified because the public key is not available: 
NO_PUBKEY 1C1E55A728CBC482

```

	 - [[Debian] Apt-get : NO_PUBKEY / GPG error](http://en.kioskea.net/faq/809-debian-apt-get-no-pubkey-gpg-error)，解決方式非常容易，上面錯誤訊息有告知 public key 是 **1C1E55A728CBC482**，透過底下兩個步驟就可以成功解決，**請注意務必將 public number 換成上面錯誤訊息的號碼**
		 - 
```
gpg --keyserver pgpkeys.mit.edu --recv-key  1C1E55A728CBC482     
gpg -a --export 1C1E55A728CBC482 | sudo apt-key add -

```

- 之後再重新跑 apt-get update 即可。
