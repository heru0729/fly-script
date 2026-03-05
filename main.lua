local p=game.Players.LocalPlayer
local u=game:GetService("UserInputService")
local r=game:GetService("RunService")
local ps=game:GetService("Players")
local c=workspace.CurrentCamera
local ts=game:GetService("TeleportService")
local sg=game:GetService("StarterGui")
local l=game:GetService("Lighting")

-- フラグ（全28機能）
local f=false local n=false local e=false local g=false local w=false local ij=false
local sb=false local grav=false local nk=false local hr=false local fd=false local wi=false
local pi=false local ko=false local af=false local iesp=false local skin=false local nr=false
local ik=false local nd=false local fire=false local water=false local stun=false local tp=false
local pos=false local timef=false local weather=false local fps=false

-- 設定値
local s=50 local ws=16 local jp=50 local ds=150 local gravVal=1 local bg,bv local tpTarget=nil
local ef=Instance.new("Folder",p:WaitForChild("PlayerGui")) ef.Name="ESP"

-- UI
local gui=Instance.new("ScreenGui") local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,250,0,600) frame.Position=UDim2.new(0,10,0,10)
frame.BackgroundColor3=Color3.new(0,0,0) frame.BackgroundTransparency=0.5 frame.Parent=gui
gui.Parent=p.PlayerGui
local scrolling=Instance.new("ScrollingFrame") scrolling.Size=UDim2.new(1,0,1,0)
scrolling.BackgroundTransparency=1 scrolling.ScrollBarThickness=5
scrolling.CanvasSize=UDim2.new(0,0,0,800) scrolling.Parent=frame
local layout=Instance.new("UIListLayout") layout.Padding=UDim.new(0,2) layout.Parent=scrolling
local tx={}
local names={"F:OFF","X:OFF","E:OFF","G:OFF","W:OFF","IJ:OFF","SB:OFF","GRAV:OFF","NK:OFF","HR:OFF","FD:OFF","WI:OFF","PI:OFF","KO:OFF","AF:OFF","IESP:OFF","SKIN:OFF","NR:OFF","IK:OFF","ND:OFF","FIRE:OFF","WATER:OFF","STUN:OFF","TP:OFF","POS:OFF","TIMEF:OFF","WEATHER:OFF","FPS:OFF"}
for i=1,28 do tx[i]=Instance.new("TextLabel") tx[i].Size=UDim2.new(1,0,0,25) tx[i].Text=names[i] tx[i].TextColor3=Color3.new(1,0,0) tx[i].BackgroundTransparency=1 tx[i].TextSize=12 tx[i].Parent=scrolling end

local function update()
 local txs={f and"F:ON"or"F:OFF",n and"X:ON"or"X:OFF",e and"E:ON"or"E:OFF",g and"G:ON"or"G:OFF",w and"W:ON"or"W:OFF",ij and"IJ:ON"or"IJ:OFF",sb and"SB:ON"or"SB:OFF",grav and"GRAV:"..gravVal or"GRAV:OFF",nk and"NK:ON"or"NK:OFF",hr and"HR:ON"or"HR:OFF",fd and"FD:ON"or"FD:OFF",wi and"WI:ON"or"WI:OFF",pi and"PI:ON"or"PI:OFF",ko and"KO:ON"or"KO:OFF",af and"AF:ON"or"AF:OFF",iesp and"IESP:ON"or"IESP:OFF",skin and"SKIN:ON"or"SKIN:OFF",nr and"NR:ON"or"NR:OFF",ik and"IK:ON"or"IK:OFF",nd and"ND:ON"or"ND:OFF",fire and"FIRE:ON"or"FIRE:OFF",water and"WATER:ON"or"WATER:OFF",stun and"STUN:ON"or"STUN:OFF",tp and"TP:ON"or"TP:OFF",pos and"POS:ON"or"POS:OFF",timef and"TIMEF:ON"or"TIMEF:OFF",weather and"WEATHER:ON"or"WEATHER:OFF",fps and"FPS:ON"or"FPS:OFF"}
 for i=1,28 do
  tx[i].Text=txs[i]
  local val=i==1 and f or i==2 and n or i==3 and e or i==4 and g or i==5 and w or i==6 and ij or i==7 and sb or i==8 and grav or i==9 and nk or i==10 and hr or i==11 and fd or i==12 and wi or i==13 and pi or i==14 and ko or i==15 and af or i==16 and iesp or i==17 and skin or i==18 and nr or i==19 and ik or i==20 and nd or i==21 and fire or i==22 and water or i==23 and stun or i==24 and tp or i==25 and pos or i==26 and timef or i==27 and weather or i==28 and fps
  tx[i].TextColor3=val and Color3.new(0,1,0)or Color3.new(1,0,0)
 end
end

-- ESP作成
local function createESP(pl)
 if pl==p then return end
 local function addESP(ch)
  if not ch then return end
  local rt=ch:FindFirstChild("HumanoidRootPart") if not rt then return end
  local bx=Instance.new("BoxHandleAdornment") bx.Size=Vector3.new(4,5,2) bx.Adornee=rt bx.AlwaysOnTop=true bx.ZIndex=10 bx.Transparency=0.3
  bx.Color3=pl.TeamColor==p.TeamColor and Color3.new(0,1,0)or Color3.new(1,0,0) bx.Parent=ef
  local bl=Instance.new("BillboardGui") bl.Adornee=rt bl.Size=UDim2.new(0,100,0,30) bl.StudsOffset=Vector3.new(0,3,0) bl.AlwaysOnTop=true bl.Parent=ef
  local nl=Instance.new("TextLabel") nl.Size=UDim2.new(1,0,1,0) nl.BackgroundTransparency=1 nl.Text=pl.Name
  nl.TextColor3=Color3.new(1,1,1) nl.TextStrokeTransparency=0.5 nl.Parent=bl
 end
 if pl.Character then addESP(pl.Character)end
 pl.CharacterAdded:Connect(function(ch)task.wait()addESP(ch)end)
end

-- 各機能
local function toggleF() f=not f local ch=p.Character if not ch then return end local h=ch:FindFirstChild("Humanoid")local rt=ch:FindFirstChild("HumanoidRootPart") if not h or not rt then return end if f then h.PlatformStand=true bg=Instance.new("BodyGyro")bg.MaxTorque=Vector3.new(9e9,9e9,9e9)bg.P=10000 bg.Parent=rt bv=Instance.new("BodyVelocity")bv.MaxForce=Vector3.new(9e9,9e9,9e9)bv.Velocity=Vector3.new(0,0,0)bv.Parent=rt else if bg then bg:Destroy()end if bv then bv:Destroy()end h.PlatformStand=false end update()end
local function toggleN() n=not n update()end
local function toggleE() e=not e for _,v in pairs(ef:GetChildren())do v:Destroy()end if e then for _,pl in pairs(ps:GetPlayers())do createESP(pl)end end update()end
local function toggleG() g=not g if g and p.Character then local h=p.Character:FindFirstChild("Humanoid") if h then h.MaxHealth=math.huge h.Health=math.huge h.BreakJointsOnDeath=false end end update()end
local function toggleW() w=not w for _,pl in pairs(ps:GetPlayers())do if pl~=p and pl.Character then for _,pt in pairs(pl.Character:GetDescendants())do if pt:IsA("BasePart")then pt.LocalTransparencyModifier=w and 0.7 or 0 end end end end update()end
local function toggleIJ() ij=not ij update()end
local function toggleSB() sb=not sb if p.Character then local h=p.Character:FindFirstChild("Humanoid") if h then h.WalkSpeed=sb and 80 or ws end end update()end
local function toggleGrav() grav=not grav gravVal=grav and 2 or 1 workspace.Gravity=grav and 100 or 196.2 update()end
local function toggleNK() nk=not nk update()end
local function toggleHR() hr=not hr if hr then coroutine.wrap(function()while hr and p.Character do local h=p.Character:FindFirstChild("Humanoid")if h then h.Health=math.min(h.Health+2,h.MaxHealth)end task.wait(1)end end)()end update()end
local function toggleFD() fd=not fd update()end
local function toggleWI() wi=not wi for _,v in pairs(workspace:GetDescendants())do if v:IsA("BasePart")and v.Material~=Enum.Material.Water then v.LocalTransparencyModifier=wi and 0.5 or 0 end end update()end
local function togglePI() pi=not pi update()end
local function toggleKO() ko=not ko if ko then for _,pl in pairs(ps:GetPlayers())do if pl~=p and pl.Character then local h=pl.Character:FindFirstChild("Humanoid") if h then h.Health=0 end end end ko=false update()end end
local function toggleAF() af=not af if af then coroutine.wrap(function()while af do for _,pl in pairs(ps:GetPlayers())do if pl~=p and pl.Character then local h=pl.Character:FindFirstChild("Humanoid") if h then h.Health=h.Health-10 end end end task.wait(0.5)end end)()end update()end
local function toggleIESP() iesp=not iesp update()end
local function toggleSKIN() skin=not skin update()end
local function toggleNR() nr=not nr update()end
local function toggleIK() ik=not ik update()end
local function toggleND() nd=not nd update()end
local function toggleFIRE() fire=not fire update()end
local function toggleWATER() water=not water update()end
local function toggleSTUN() stun=not stun update()end
local function toggleTP() tp=not tp if tp then local pls={}for _,pl in pairs(ps:GetPlayers())do if pl~=p then table.insert(pls,pl.Name)end end local target=pls[math.random(#pls)] tpTarget=ps:FindFirstChild(target) if tpTarget and tpTarget.Character and p.Character then p.Character.HumanoidRootPart.CFrame=tpTarget.Character.HumanoidRootPart.CFrame end tp=false update()end end
local function togglePOS() pos=not pos if pos then coroutine.wrap(function()while pos do if p.Character then local rt=p.Character:FindFirstChild("HumanoidRootPart") if rt then sg:SetCore("ChatMakeSystemMessage",{Text="POS: "..math.floor(rt.Position.X)..","..math.floor(rt.Position.Y)..","..math.floor(rt.Position.Z),Color=Color3.new(0,1,0)})end end task.wait(1)end end)()end update()end
local function toggleTIMEF() timef=not timef if timef then l.ClockTime=12 else l:SetMinutesAfterMidnight(os.date("*t").hour*60+os.date("*t").min)end update()end
local function toggleWEATHER() weather=not weather if weather then l:SetMinutesAfterMidnight(6*60) l.Ambient=Color3.new(1,1,1) else l:SetMinutesAfterMidnight(os.date("*t").hour*60+os.date("*t").min) end update()end
local function toggleFPS() fps=not fps if fps then coroutine.wrap(function()while fps do sg:SetCore("ChatMakeSystemMessage",{Text="FPS: "..math.floor(1/r:Wait()),Color=Color3.new(0,1,0)})end end)()end update()end

-- キー設定
local keys={
 [Enum.KeyCode.F]=toggleF,[Enum.KeyCode.X]=toggleN,[Enum.KeyCode.E]=function()e=not e update()end,
 [Enum.KeyCode.G]=toggleG,[Enum.KeyCode.W]=toggleW,[Enum.KeyCode.I]=toggleIJ,
 [Enum.KeyCode.U]=toggleSB,[Enum.KeyCode.O]=toggleGrav,[Enum.KeyCode.K]=toggleNK,
 [Enum.KeyCode.H]=toggleHR,[Enum.KeyCode.L]=toggleFD,[Enum.KeyCode.P]=toggleWI,
 [Enum.KeyCode.B]=togglePI,[Enum.KeyCode.V]=toggleKO,[Enum.KeyCode.C]=toggleAF,
 [Enum.KeyCode.M]=toggleIESP,[Enum.KeyCode.Y]=toggleSKIN,[Enum.KeyCode.N]=toggleNR,
 [Enum.KeyCode.T]=toggleIK,[Enum.KeyCode.Q]=toggleND,[Enum.KeyCode.Z]=toggleFIRE,
 [Enum.KeyCode.R]=toggleWATER,[Enum.KeyCode.D]=toggleSTUN,[Enum.KeyCode.J]=toggleTP,
 [Enum.KeyCode.One]=togglePOS,[Enum.KeyCode.Two]=toggleTIMEF,[Enum.KeyCode.Three]=toggleWEATHER,
 [Enum.KeyCode.Four]=toggleFPS
}

u.InputBegan:Connect(function(i,pr)
 if pr then return end
 if keys[i.KeyCode] then keys[i.KeyCode]() end
 if i.KeyCode==Enum.KeyCode.Right then ws=math.min(ws+2,100)
 elseif i.KeyCode==Enum.KeyCode.Left then ws=math.max(ws-2,1)end
 if i.KeyCode==Enum.KeyCode.PageUp then jp=math.min(jp+5,200)
 elseif i.KeyCode==Enum.KeyCode.PageDown then jp=math.max(jp-5,10)end
end)

-- 常時処理
r.Stepped:Connect(function()if n and p.Character then for _,pt in pairs(p.Character:GetChildren())do if pt:IsA("BasePart")then pt.CanCollide=false end end end end)
r.Heartbeat:Connect(function()
 if ij and p.Character then local h=p.Character:FindFirstChild("Humanoid") if h and h:GetState()==Enum.HumanoidStateType.Jumping then h:ChangeState(Enum.HumanoidStateType.Jumping)end end
 if nk and p.Character then local rt=p.Character:FindFirstChild("HumanoidRootPart") if rt then rt.AssemblyLinearVelocity=Vector3.new(rt.AssemblyLinearVelocity.X,0,rt.AssemblyLinearVelocity.Z)end end
 if fd and p.Character then local h=p.Character:FindFirstChild("Humanoid") if h then h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)end end
 if nr and p.Character then for _,t in pairs(p.Character:GetDescendants())do if t:IsA("Tool")and t:FindFirstChild("Humanoid")then t.Humanoid.WalkSpeed=0 end end end
 if ik and p.Character then for _,t in pairs(p.Character:GetDescendants())do if t:IsA("Tool")then local s=t:FindFirstChildWhichIsA("LocalScript") if s then s:Destroy()end end end end
 if not f then return end
 local ch=p.Character if not ch then return end
 local rt=ch:FindFirstChild("HumanoidRootPart") if not rt or not bg or not bv then return end
 bg.CFrame=CFrame.lookAt(rt.Position,rt.Position+c.CFrame.LookVector)
 local md=Vector3.new() local cs=u:IsKeyDown(Enum.KeyCode.LeftShift)and ds or s
 if u:IsKeyDown(Enum.KeyCode.W)then md=md+c.CFrame.LookVector end
 if u:IsKeyDown(Enum.KeyCode.S)then md=md-c.CFrame.LookVector end
 if u:IsKeyDown(Enum.KeyCode.A)then md=md-c.CFrame.RightVector end
 if u:IsKeyDown(Enum.KeyCode.D)then md=md+c.CFrame.RightVector end
 if u:IsKeyDown(Enum.KeyCode.Space)then md=md+Vector3.new(0,1,0)end
 if u:IsKeyDown(Enum.KeyCode.LeftControl)then md=md+Vector3.new(0,-1,0)end
 bv.Velocity=md.Magnitude>0 and md.Unit*cs or Vector3.new()
end)

p.CharacterAdded:Connect(function()if f then f=false if bg then bg:Destroy()end if bv then bv:Destroy()end end update()end)
ps.PlayerAdded:Connect(function(pl)if e then createESP(pl)end end)
update()
