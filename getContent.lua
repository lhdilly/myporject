require("TSLib")
UnRedBallLBX,UnRedBallLBY=112,1045 --微信左下角未读红点X,Y坐标

UnReadNewX,UnReadNewY,saveYRNY =300,180,180 --微信未读消息X,Y坐标

UnRedBallLTX,UnRedBallLTY,saveURBLTY = 105,135,135 --微信左上角未读红点X,Y坐标

WXReBackButtonX,WXReBackButtonY = 85,85 --微信聊天界面返回按钮X,Y坐标

WXMessageButtonX,WXMessageButtonY = 80,1075 --微信左下角“微信”按钮X,Y坐标

WXScreenHight = 1035 --微信消息列表高度

messageDistance = 130 --两条消息间的高度

moveToX1,moveToY1,moveToX2,moveToY2 = 300,1030,300,135  --滑动的两点坐标X1Y1,X2Y2

flag = true

dim_85 = 85 --匹配模糊度
dim_90 = 90  --匹配模糊度
dim_95 = 95  --匹配模糊度
dim_100 = 100  --匹配模糊度

color = 0xff3b30 --微信小红点颜色红
color1 = 0xffffff --文本框内部颜色白
color2 = 0xebebeb --微信聊天背景颜色灰

nickNameArr = {"微信团队","腾讯新闻"}  --非好友昵称

textX,textY,saveY = 128,1024,1024 --截取文本框起始坐标

leftTopX,leftTopY,rightTopY,rightBottomX,rightBottomY = 0,0,0,0,0  --截取文本框定位坐标

textArr = {} --截取的聊天记录数组

s = ""  --测试用字符串，为数组的元素拼接而成

deX,deY,text = 0,0,""


--[[截取聊天记录函数]]--
function findText(x,y)

	--首先找出文本右下角的rightBottomY坐标
	while (true) do
	
		if (isColor( x,  y, color1, dim_100)) then
			rightBottomY = y
			break
		else
			y=y-20
		end
	end
	--其次找出文本左上角的leftTopX，leftTopY坐标
	while (true) do
	
		y=y-20
		if (isColor( x,  y, color2, dim_100)) then
			y=y+20
			leftTopY = y
			leftTopX = x
			break
		end
	end	
    --最后找出文本右下角的X坐标
	while (true) do

		x=x+20
		if (isColor( x,  y, color2, dim_100)) then
			x=x-20
			rightBottomX=x
			rightTopY = y
			break
		end
	end
	reconize = ocrText(leftTopX, leftTopY, rightBottomX, rightBottomY, 1)--识别区域的文字
	return leftTopX,leftTopY-20,reconize

	
end




--[[查看微信未读消息函数，内部调用截取聊天记录函数]]--
function findReadBall()
	
	while (true) do
		if (isColor( UnRedBallLBX, UnRedBallLBY, color, dim_85)) then --判断微信左下角是否有未读小红点
			doubleClick(WXMessageButtonX,WXMessageButtonY) --双击微信左下角“微信”按钮
			
			while (true) do
				if (isColor( UnRedBallLTX, UnRedBallLTY, color, dim_85)) then  --判断微信左上角是否有未读小红点
					tap(UnReadNewX,UnReadNewY) --点击消息进入聊天界面
					
					mSleep(1000)
					
					local nickName = ocrText(150, 50, 520, 100, 1)  --接收微信好友昵称
					dialog(nickName)
					for k,v in ipairs(nickNameArr) do
						if(nickName == v) then 
							--dialog("非好友，如腾讯新闻，微信团队")
							flag = false
							break
						else
							--dialog("是好友")
							flag = true
						end				
					end
					
					if(flag) then  --判断进入的是好友的聊天界面或者是微信团队，腾讯新闻等不重要窗口
						
						--------截取聊天记录start------
					if (isColor( 447,  186, 0x0bbc09, 85) and isColor( 441,  192, 0x10bd0e, 85) and isColor( 454,  193, 0x16be14, 85)) then --判断是否存在多条消息点击按钮
						tap(460,190)
						
						----未读消息超过一个屏幕可显示区域时候的逻辑留空----
					else
							
							for i=1,10 do
								if(textY <= 230) then
									break
								end
								deX,deY,text = findText(textX,textY)
								textY = deY
								table.insert(textArr,text)
							end
							
							
							
							for k,v in ipairs(textArr) do
								dialog("截取到第"..k.."条聊天记录："..v)
							end
							textY = saveY --截取完一个聊天窗口的记录时重新定位坐标Y=saveY=1024
							textArr = {} -- 清空上一个聊天记录数组
							
				
					end
					--------截取聊天记录end------
					
					end
					mSleep(1000)
					tap(WXReBackButtonX,WXReBackButtonY)  --点击返回按钮
					mSleep(1000)
				end
				UnRedBallLTY = UnRedBallLTY + messageDistance  --读完一条消息将坐标往下移动一个messageDistance的距离
				UnReadNewY = UnReadNewY + messageDistance   --读完一条消息将坐标往下移动一个messageDistance的距离
				
				if(UnRedBallLTY > 1000) then  --坐标超出微信消息列表范围
					UnRedBallLTY = saveURBLTY --重置小红点坐标
					UnReadNewY = saveYRNY  --重置消息坐标
					if (isColor( UnRedBallLBX, UnRedBallLBY, color, dim_85)) then --微信左下角有未读小红点的话
						doubleClick(WXMessageButtonX,WXMessageButtonY)  --双击左下角“微信”按钮
					else
						break
					end
				end

			end
		else
			break
		end
	end
end


--[[双击函数]]--
function doubleClick(x,y)
	tap(x,y)
	mSleep(50)
	tap(x,y)
end




--程序入口
do
	doubleClick(WXMessageButtonX,WXMessageButtonY) --双击微信右下角“微信”按钮	
	mSleep(500)
	findReadBall()
	
	
end
	