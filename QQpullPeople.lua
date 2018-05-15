require("TSLib")

QQNumArr = {
	--3339227455--群主号
	2246352541 --数据号
	}

QQNumMap = {
	
	[2246352541] = "kkk123..",
	
}



language = 1 --识别语言选择


time_200= 200
time_600= 600
time_500 = 500
time_1000 = 1000
time_2000 = 2000
time_5000 = 5000
userNameX , userNameY = 250 , 340 --无输入法弹出时账号对话框X,Y坐标 

passwordX , passwordY = userNameX,userNameY--有输入法弹出时密码对话框X,Y坐标

loginButtonX , loginButtonY = 320 , 480 --QQ登录按钮坐标XY

accountManagerX , accountManagerY = 550,200--QQ账号管理按钮坐标XY

blankX , blankY = 50,50 --QQ登录界面空白处XY坐标

setButtonX , setButtonY  = 60 , 1040 --设置按钮的坐标XY

clearX , clearY ,saveClearX = 500 , 250 ,500 --文本框意见删除按钮坐标XY

veryfiCodeLTX , veryfiCodeLTY , veryfiCodeRBX , veryfiCodeRBY = 256 , 64 , 380 , 100 --验证码的左上角坐标XY和右下角坐标XY
 
leftMoveBlockX , leftMoveBlockY , rightMoveBlockX , rightMoveBlockY = 135 , 610 , 480 , 610 --验证码左滑块和右滑块的XY坐标

profilePictureX , profilePictureY = 60 , 80 --自己的头像坐标XY

exitButtonX , exitButtonY , saveExitButtonY= 10,1050,1050--退出账号按钮坐标XY

confirmExitButtX , confirmExitButtY = 450,700 --确定按钮坐标XY（点击退出账号之后的弹窗提示）
 
 
 --[[单击函数，暂缓一段时间]]--
function singleClick(x,y,time)
	tap(x,y)
	mSleep(time)
end

--[[拖动验证码滑块函数]]--
function defMoveTo(x1 , y1  ,x2 , y2)
	moveTo(x1 , y1  ,x2 , y2)
	if(ocrText(veryfiCodeLTX , veryfiCodeLTY, veryfiCodeRBX, veryfiCodeRBY, language) == "验证码") then
		moveTo(x1 , y1  ,x2 + 30 , y2)
	end
end

--[[登录函数]]--
function login(userName , password) 
	singleClick(blankX,blankY,time_500) --点击空白位置
	
	singleClick(userNameX , userNameY , time_500) --单击QQ号文本框
	
	if (isColor( 558,  260, 0xd6d7db, 100)) then--由于有历史账号和没有历史账号，清空文本框按钮位置也不同
		clearX = 570
	else
		clearX = saveClearX
	end
	--dialog(clearX..","..clearY)
	
	singleClick(clearX , clearY , time_500)  --清空文本框中的QQ号
	
	inputText(userName) --输入QQ号
	mSleep(time_1000)
	
	singleClick(passwordX , passwordY , time_500)
	inputText(password) --输入密码
	mSleep(time_1000)
	
	singleClick(loginButtonX , loginButtonY , time_500) --点击登录
end
	
	--[[退出当前QQ账号]]--
	function exit()
		local x ,y = 20,130
		singleClick(profilePictureX , profilePictureY , time_500)  --点击头像
		
		singleClick(setButtonX,setButtonY,time_500) --点击设置
		--找出账号管理所在位置--
		while (true) do 
			if (isColor(  x,  y, 0xffffff, 100)) then
				singleClick(x , y ,time_1000) --点击账号管理
				break
			end
			y = y + 50
		end
		
		
		
		moveTo(200,1000,200,800)  --手指向上滑动屏幕
		
		mSleep(time_1000)
		
		while (true) do
			if (isColor(  exitButtonX,  exitButtonY, 0xffffff, 100)) then --判断退出当前账号按钮所处位置
				singleClick(exitButtonX , exitButtonY , time_1000) --点击退出账号
		
				singleClick(confirmExitButtX , confirmExitButtY ,time_500) --点击确定退出
				
				exitButtonY = saveExitButtonY
				break
			end
			exitButtonY = exitButtonY - 50
		end
		
	end

	
--[[删除登录保存的QQ号，避免预存数量上限提示]]--
function delAccount()
	
	if (isColor( 561,  340, 0xcfd3d8, 95) and isColor( 576,  340, 0xcfd3d8, 95)) then
			singleClick(570,340,time_500) --点击下拉显示历史QQ账号
	
	singleClick(570,430,time_1000) --点击删除
	
	singleClick(470,680,time_500) --确认删除
	end

end
	--[[登录逻辑判断函数]]--
	function letsGo(QQNum,pass)
			
	
		while (true) do
			mSleep(time_1000) 
			delAccount()
			login(QQNum , pass) 
			mSleep(time_1000) 
			local reconize = ocrText(240, 460, 410, 510, language)
			
			if(reconize == "安全提示") then	
				singleClick(320 , 670 , time_1000) --点击确定
			elseif( reconize == "登录失败") then
				return
			else
				while (ocrText(veryfiCodeLTX , veryfiCodeLTY, veryfiCodeRBX, veryfiCodeRBY, language) == "验证码") do
					defMoveTo(leftMoveBlockX , leftMoveBlockY , rightMoveBlockX , rightMoveBlockY) --滑动滑块验证	
				end
			end
			
			if(ocrText(240, 460, 410, 510, language) == "登录失败") then
				singleClick(320,670,time_500)
				-----------------登录失败时，验证码或者密码错误时的逻辑留空-----
				return
			elseif(reconize ~= "安全提示") then
				mSleep(time_5000)   --登录后等待数据加载
				break
			end
		end

		
		if(ocrText(15, 65, 85, 100, language) == "关闭") then  --出现手机绑定提示时
			
			singleClick(50,85,time_1000)  --点击关闭
			
			--singleClick(470,720,time_1000) --确认关闭
			
		end
		
	end

	

	--[[拉人进群函数]]--
	function pullPeople()
		local x1,x2,y = 47,48,345
		
	
		
		local count = 17
		while (true) do
			
			if (isColor(  x1,  y, 0xe0e1e1, 100) and isColor(  x2,  y, 0xe0e1e1, 100)) then  --从上到下搜索好友
				singleClick(x1 , y+20 , 0)  --勾选好友
				count = count - 1 
			end
		
			if(count == 0)then --好友勾选完毕
				mSleep(time_500)
				singleClick(300,1070,time_1000) --点击邀请
				mSleep(time_1000) --闪退缓存时间
				break
			end
			
			y = y + 1
			if(y >= 925) then
				moveTo(50,920,50,715)
				mSleep(time_1000 + time_500) --滑动缓冲时间，避免在滑动动画时间内程序超前运行
				y = 340
			end
		end
	end
	--[[删除群人数函数]]
	function delPeople() 
		local x3,x4,y1 = 47,48,540
		
		local count1 ,count2 = 18 , 0
		while (true) do
			if (isColor(  x3,  y1, 0xe0e1e1, 100) and isColor(  x4,  y1, 0xe0e1e1, 100)) then
				singleClick(x3 , y1 + 20 , 0)
				count1 = count1 - 1
			end
			y1 = y1 + 1
			
			if(y1 >= 1130) then
				moveTo(50,920,50,450)
				count2  = count2 + 1
				mSleep(time_1000 + time_500)--滑动缓冲时间，避免在滑动动画时间内程序超前运行
				y1 = 120
			end
			
			if(count1 == 0 or count2 == 3) then
				singleClick(590,80,time_1000) --点击删除
				singleClick(470,680,time_200)  --确认删除
				mSleep(time_2000) --成功删除缓冲时间
				 break
			end
			
		end

	end
	--[[邀请群成员按钮+]]--
	function findButt_invite()
		local x , y = 630,522
		while (true) do
			
			if (isColor( x,  y, 0x14b0ec, 100)) then --搜索邀请按钮位置
				return x,y
			end
			x = x - 20
			
			if(x<=30) then 
				y = 700
				x = 630
			end
			
		end
		
	end
	
 --程序主入口
do
--[[
	
]]--
	
	
	for _,v in ipairs(QQNumArr) do
		
		letsGo(v, QQNumMap[v]) --登录
		
		--首次登录之后的一系列点击操作
		do			
			singleClick(230,1080,time_500) --点击底部联系人
				
			singleClick(200,430,time_500)--选择群聊
				
			singleClick(70,520,time_1000) --点击群
				
			singleClick(590,90,time_600 + time_500)--点击右上角群联系人图标
		end
		
		--连续三次拉人踢人操作
		for i = 1 ,3 do
			local x,y = findButt_invite() --找到邀请按钮
				
			singleClick(x,y,time_500) --点击邀请按钮
			
			--拖动屏幕到上一次拉人的位置逻辑留空
			if(i == 2) then
			
			moveTo(50,920,50,350)
			mSleep(time_1000 + time_500)
			
			moveTo(50,920,50,350)
			mSleep(time_1000 + time_500)
				
			end
			
			if(i == 3) then
			
			moveTo(50,920,50,350)
			mSleep(time_1000 + time_500)
			
			moveTo(50,920,50,350)
			mSleep(time_1000 + time_500)
			
			moveTo(50,920,50,350)
			mSleep(time_1000 + time_500)
			
			moveTo(50,920,50,350)
			mSleep(time_1000 + time_500)
			
			end
			
			pullPeople() --拉人进群
			
			if (isColor( 545,  622, 0xf9ae08, 85)) then
				
				dialog("啊哦，闪退了")
				singleClick(550,650,time_1000) --打开QQ
					
				singleClick(230,1080,time_200) --点击底部联系人
					
				singleClick(200,430,time_200)--选择群聊
					
				singleClick(70,520,time_600) --点击群
					
				singleClick(590,90,time_600 + time_500)--点击右上角群联系人图标
			end
				
			singleClick(600,420,time_500 + time_200) --群聊成员
				
			singleClick(600,80,time_500) --点击右上角...
				
			singleClick(300,960,time_200) --点击删除群成员...
				
			delPeople() 
			
			singleClick(80,80,time_1000) --点击返回
		
				
			if(i == 3) then
				singleClick(80,80,time_500) --点击返回
				
				singleClick(80,80,time_500) --点击返回
					
				exit()
			end	
		end
	end	
				
	
	
end









