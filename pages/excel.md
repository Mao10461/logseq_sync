---
title: excel
---

- excel 自動向下填滿
	 - 1. 選取資料範圍，例如：儲存格A2:B22。

	 - 2. 按一下 Ctrl+G 鍵，開啟[到]對話框。

	 - 3. 按一下[特殊]按鈕，開啟[特殊目標]對話框。

	 - 4. 選取「空格」，按一下［確定］按鈕。

	 - 5. 在公式列中輸入「=A2」，按一下 Ctrl+Enter 鍵。

- xlookup函數語法
	 - ==**XLOOKUP**== ==**(**== ==**lookup_value,**== ==**lookup_array,**== ==**return_array,**== ==**[if_not_found],**== ==**[match_mode],**== ==**[search_mode]**== ==**)**==
==**lookup_value** : 要被比對的欄位，也就是要拿來當關聯的資料欄位==
==**lookup_array** : 要跟lookup_value做比對的欄位範圍==
==**return_array** : 要回傳的資料(可以是很多欄位)==
==**[if_not_found]** : 選填項。如果比對不到符合資料時，會回傳的值==
==**[match_mode]** : 選填項。判斷相符的模式，預設為完全相符。==
==**[search_mode]** : 選填項。指定要使用的搜尋模式。==

- xlookup函數範例
	 - ==**=XLOOKUP( B2 , $I$2:$I$23 , $H$2:$L$23 , "無法比對" )**==
		 - ![excel-xlookup-函數範例說明-回傳多筆](https://www.togetherhoo.com/wp-content/uploads/2021/01/excel-xlookup-%E5%87%BD%E6%95%B8%E7%AF%84%E4%BE%8B%E8%AA%AA%E6%98%8E-%E5%9B%9E%E5%82%B3%E5%A4%9A%E7%AD%86-1024x570.png){:height 408, :width 718}

	 - ==**=XLOOKUP( B2 , $I$2:$I$23 , $H$2:$H$23 , "無法比對")**==
		 - ![excel-xlookup-函數範例-if_not_found](https://www.togetherhoo.com/wp-content/uploads/2021/01/excel-xlookup-%E5%87%BD%E6%95%B8%E7%AF%84%E4%BE%8B-if_not_found-1024x749.png)

- 

- 

- 

- 

- 

- 
