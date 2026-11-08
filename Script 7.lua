--[[ UNSTABLE SMP FFA | HUD v13: Crystals ESP (8 per body part), Kill Effect, Hit Arrow, Rain + ripples, Hit sparks/marker, Mace Hit, Auto Sprint, Healer Help, No Friend Damage, Kill Streak, 3 HUD styles, Atmosphere, Trail, Compass, Speed Lines, Marks, Friends ]]
local V = {}
V.Players = game:GetService("Players")
V.RS = game:GetService("RunService")
V.UIS = game:GetService("UserInputService")
V.TS = game:GetService("TweenService")
V.TXT = game:GetService("TextService")
V.Stats = game:GetService("Stats")
V.HS = game:GetService("HttpService")
V.TCS = game:GetService("TextChatService")
V.Lighting = game:GetService("Lighting")
V.FONT = Enum.Font.Arcade
V.HOLD = 2.5
V.lp = V.Players.LocalPlayer

V.cfg = {wm=true,fps=true,xyz=true,wl=true,sens=2,wd=true,wb=true,th=true,bg=2,range=45,skipf=true,esp=true,estyle=5,escope=1,ecol=1,esize=100,espd=10,esd=100,swd=true,swc=true,mk=true,mkdur=4.5,mkbtn=true,sync=true,mkt=2,ci=1,gt=1,fbtn=true,atm=false,apr=1,aint=100,apart=true,asky=true,arays=true,ascl=100,aq=60,hf=true,hfn=true,hfc=true,hfcol=1,hfr=12,hfto=3,hfx=true,hfm=true,trail=false,trs=1,trc=1,trl=.8,trw=100,trg=true,cmp=true,cmk=true,cmw=320,spd=true,spth=45,spi=70,spfov=false,hd=true,hda=true,hdv=true,hdl=true,hdr=120,asp=true,ask=1,heal=true,healhp=40,heall=true,nofd=true,ths=1,wms=1,gus=1,stat=false,ks=true,ksb=true,kss=false,kfx=true,kfxf=true,kfxp=true,mace=true,msw=true,msh=true,mthr=35,rain=false,rni=60,rnr=true,alrt=false,alr=30,afk=false,xh=false,xhs=1,xhz=100,kb={},fr={}}
V.FILE = "usmp_hud_v7.json"
pcall(function() if isfile and isfile(V.FILE) then for k,v in pairs(V.HS:JSONDecode(readfile(V.FILE))) do V.cfg[k]=v end end end)
if type(V.cfg.fr)~="table" then V.cfg.fr={} end
if type(V.cfg.kb)~="table" then V.cfg.kb={} end
if not V.cfg.crysV then V.cfg.crysV=true V.cfg.mkt=2 V.cfg.ask=1 end
if not V.cfg.crysV2 then V.cfg.crysV2=true V.cfg.estyle=5 end
if (V.cfg.estyle or 5)>5 then V.cfg.estyle=5 end

V.BGS, V.SENS = {1,.6,.25},{.12,.06,.025}
V.BGN, V.SENN, V.ESTN, V.SCPN, V.ECN, V.HCN = {"Clear","Glass","Dark"},{"Low","Normal","High"},{"Diamond","Ghosts","Circle","Ring","Crystals"},{"Target","Nearby"},{"Accent","Health","Rainbow"},{"By damage","Accent"}
V.HSN = {"Classic","Modern","Aesthetic"}
V.ASK = {"LeftControl","LeftShift","R","Q","V"}
V.COLS = {{"Purple",Color3.fromRGB(190,100,255)},{"Aqua",Color3.fromRGB(85,255,255)},{"Green",Color3.fromRGB(85,255,85)},{"Gold",Color3.fromRGB(255,170,0)},{"Red",Color3.fromRGB(255,85,85)},{"Pink",Color3.fromRGB(255,85,255)},{"Blue",Color3.fromRGB(90,150,255)},{"Orange",Color3.fromRGB(255,130,60)},{"Mint",Color3.fromRGB(110,255,190)},{"White",Color3.fromRGB(235,235,245)}}
V.COLN = {} for i,c in ipairs(V.COLS) do V.COLN[i]=c[1] end
V.acc = function() return V.COLS[V.cfg.ci] and V.COLS[V.cfg.ci][2] or V.COLS[1][2] end
V.hex = function(c) return string.format("#%02X%02X%02X",math.floor(c.R*255+.5),math.floor(c.G*255+.5),math.floor(c.B*255+.5)) end
V.GOLD, V.BLK, V.GRN, V.GRY = Color3.fromRGB(255,216,58),Color3.new(0,0,0),Color3.fromRGB(85,255,85),Color3.fromRGB(205,208,225)
V.c3 = function(r,g,b) return Color3.fromRGB(r,g,b) end

V.THEMES = {
{n="Graphite",win=V.c3(50,52,60),panel=V.c3(72,75,86),sel=V.c3(96,100,116),line=V.c3(130,134,150),det=V.c3(42,44,52),sep=V.c3(92,95,108),off=V.c3(88,91,102),ov=.7,wt=0},
{n="Light",win=V.c3(74,79,108),panel=V.c3(98,104,140),sel=V.c3(124,131,174),line=V.c3(165,172,215),det=V.c3(86,92,124),sep=V.c3(130,137,178),off=V.c3(118,123,156),ov=.82,wt=0},
{n="Dark",win=V.c3(16,16,20),panel=V.c3(28,28,36),sel=V.c3(40,40,52),line=V.c3(60,60,72),det=V.c3(22,22,28),sep=V.c3(45,45,56),off=V.c3(48,48,58),ov=.5,wt=.06},
{n="Midnight",win=V.c3(18,22,44),panel=V.c3(30,38,74),sel=V.c3(46,58,108),line=V.c3(80,100,170),det=V.c3(14,18,36),sep=V.c3(40,52,96),off=V.c3(40,48,84),ov=.55,wt=.05},
{n="Ocean",win=V.c3(22,54,76),panel=V.c3(36,84,112),sel=V.c3(52,112,146),line=V.c3(96,170,206),det=V.c3(16,42,60),sep=V.c3(50,100,130),off=V.c3(46,86,110),ov=.65,wt=0},
{n="Mint",win=V.c3(36,62,58),panel=V.c3(52,92,84),sel=V.c3(70,122,110),line=V.c3(110,176,160),det=V.c3(28,50,47),sep=V.c3(72,118,106),off=V.c3(64,100,92),ov=.7,wt=0},
{n="Rose",win=V.c3(62,40,54),panel=V.c3(92,58,78),sel=V.c3(124,76,104),line=V.c3(178,112,150),det=V.c3(50,32,44),sep=V.c3(110,70,92),off=V.c3(100,68,86),ov=.7,wt=0},
{n="Sunset",win=V.c3(66,44,40),panel=V.c3(104,66,52),sel=V.c3(140,88,62),line=V.c3(205,130,86),det=V.c3(54,34,32),sep=V.c3(126,80,60),off=V.c3(110,76,62),ov=.7,wt=0},
{n="Violet",win=V.c3(44,34,70),panel=V.c3(68,52,108),sel=V.c3(92,70,146),line=V.c3(150,120,220),det=V.c3(34,26,56),sep=V.c3(88,68,132),off=V.c3(80,64,118),ov=.65,wt=0},
{n="Glass",win=V.c3(30,34,44),panel=V.c3(60,66,82),sel=V.c3(84,92,112),line=V.c3(140,150,175),det=V.c3(20,24,32),sep=V.c3(80,88,108),off=V.c3(70,76,92),ov=.85,wt=.3},
}
V.GTN = {} for i,t in ipairs(V.THEMES) do V.GTN[i]=t.n end
V.T = function() return V.THEMES[V.cfg.gt] or V.THEMES[1] end
V.TR = {}
V.tr = function(o,p,k) V.TR[#V.TR+1]={o,p,k} o[p]=V.T()[k] return o end
V.applyTheme = function() local t=V.T() for _,x in ipairs(V.TR) do pcall(function() x[1][x[2]]=t[x[3]] end) end end

V.DEFK = {menu="RightShift",mark="G",faim="H"}
V.getKey = function(id) local v=V.cfg.kb[id] if v==nil then v=V.DEFK[id] end if v=="None" then v=nil end return v end

if _G.USMP_CLEAN then pcall(_G.USMP_CLEAN) end
V.conns, V.dirty = {}, false
V.C = function(c) V.conns[#V.conns+1]=c return c end
V.save = function() V.dirty=true end
V.prevHook, V.hooked, V.atmKill, V.trailKill = nil, nil, nil, nil
V.mbtn, V.fbtn, V.setMenu, V.render, V.menuOpen, V.capId, V.capSet = nil, nil, nil, nil, false, nil, nil
V.CR = {}
V.spOn, V.spKey, V.VIM = false, nil, nil
pcall(function() V.VIM=game:GetService("VirtualInputManager") end)

V.new = function(c,p,par) local i=Instance.new(c) for k,v in pairs(p) do i[k]=v end i.Parent=par return i end
V.stroke = function(i,c,th,t) return V.new("UIStroke",{Color=c,Thickness=th or 1,Transparency=t or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},i) end
V.tx = function(par,p)
local al=p.Align or Enum.TextXAlignment.Left
local ya=p.Wrap and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
local fn=p.Font or V.FONT
local sh=V.new("TextLabel",{BackgroundTransparency=1,Position=p.Position+UDim2.new(0,2,0,2),Size=p.Size,Font=fn,TextSize=p.TextSize or 14,TextXAlignment=al,TextYAlignment=ya,TextWrapped=p.Wrap,TextColor3=Color3.fromRGB(30,30,38),ZIndex=1,Visible=not p.NS,Text=""},par)
local m=V.new("TextLabel",{BackgroundTransparency=1,Position=p.Position,Size=p.Size,Font=fn,TextSize=p.TextSize or 14,TextXAlignment=al,TextYAlignment=ya,TextWrapped=p.Wrap,TextColor3=p.Color or Color3.new(1,1,1),RichText=true,ZIndex=2,Text=""},par)
local lastT
return function(t) if t==lastT then return end lastT=t m.Text=t sh.Text=(t:gsub("<[^>]+>","")) end
end
V.drag = function(h,t)
local d,s,p
h.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
d,s,p=true,i.Position,t.Position
i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end)
end
end)
V.C(V.UIS.InputChanged:Connect(function(i)
if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
local l=i.Position-s
t.Position=UDim2.new(p.X.Scale,p.X.Offset+l.X,p.Y.Scale,p.Y.Offset+l.Y)
end
end))
end
V.IC = {
eye={"..###..",".#...#.","#..#..#",".#...#.","..###.."},
sword={"......#",".....##","....##.","#..##..",".####..","..##...",".#..#.."},
aim={"...#...","...#...",".......","##...##",".......","...#...","...#..."},
pin={"..###..",".#####.",".##.##.",".#####.","..###..","...#...","...#..."},
user={"..###..",".#####.","..###..","...#...",".#####.","#..#..#","...#..."},
sun={"#..#..#",".#.#.#.","..###..","###.###","..###..",".#.#.#.","#..#..#"},
hud={"#######","#.....#","#.###.#","#.....#","#.###.#","#.....#","#######"},
star={"...#...","...#...","#######",".#####.","..###..",".##.##.","##...##"},
}
V.icon = function(par,bm,px,col)
local cells={}
local f=V.new("Frame",{BackgroundTransparency=1,Size=UDim2.new(0,#bm[1]*px,0,#bm*px)},par)
for y,row in ipairs(bm) do for x=1,#row do if row:sub(x,x)=="#" then
cells[#cells+1]=V.new("Frame",{BackgroundColor3=col,BorderSizePixel=0,Position=UDim2.new(0,(x-1)*px,0,(y-1)*px),Size=UDim2.new(0,px,0,px)},f)
end end end
return f,cells
end
local ok,root=pcall(function() return (gethui and gethui()) or game:GetService("CoreGui") end)
if not ok or not root then root=V.lp:WaitForChild("PlayerGui") end
local old=root:FindFirstChild("USMP_HUD") if old then old:Destroy() end
V.gui = V.new("ScreenGui",{Name="USMP_HUD",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
if not pcall(function() V.gui.Parent=root end) then V.gui.Parent=V.lp:WaitForChild("PlayerGui") end
_G.USMP_CLEAN=function()
for _,c in ipairs(V.conns) do pcall(function() c:Disconnect() end) end
if V.atmKill then pcall(V.atmKill) end
if V.trailKill then pcall(V.trailKill) end
for _,c in ipairs(V.CR) do pcall(function() c:Destroy() end) end
pcall(function() V.RS:UnbindFromRenderStep("USMP_SHAKE") end)
if V.spOn and V.VIM then pcall(function() V.VIM:SendKeyEvent(false,V.spKey,false,game) end) end
if V.fovOn and V.fovBase then pcall(function() workspace.CurrentCamera.FieldOfView=V.fovBase end) end
if V.hooked then pcall(function() V.TCS.OnIncomingMessage=V.prevHook end) end
pcall(function() V.gui:Destroy() end)
end
task.spawn(function() while V.gui.Parent do task.wait(1.5) if V.dirty then V.dirty=false pcall(function() writefile(V.FILE,V.HS:JSONEncode(V.cfg)) end) end end end)

V.toast = V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,150),Size=UDim2.new(0,280,0,26),BackgroundColor3=V.BLK,BackgroundTransparency=.3,GroupTransparency=1,BorderSizePixel=0,ZIndex=40},V.gui)
V.setToast = V.tx(V.toast,{Position=UDim2.new(0,0,.5,-6),Size=UDim2.new(1,0,0,12),TextSize=11,Align=Enum.TextXAlignment.Center})
V.toastId = 0
V.notify = function(t)
V.toastId+=1 local id=V.toastId V.setToast(t) V.toast.GroupTransparency=0
task.delay(2,function() if id==V.toastId and V.toast.Parent then V.TS:Create(V.toast,TweenInfo.new(.4),{GroupTransparency=1}):Play() end end)
end

-- EFFECTS: particles, rings, kill flash, hit marker, mace shockwave, camera shake
V.fxRP=RaycastParams.new() V.fxRP.FilterType=Enum.RaycastFilterType.Exclude
V.fxFilter=function()
local l={workspace.CurrentCamera}
if V.lp.Character then l[2]=V.lp.Character end
return l
end
V.FXMAX,V.fxN=40,0
V.fxSpawn=function(class,props,life)
if V.fxN>=V.FXMAX then return nil end
V.fxN+=1
local p=V.new(class,props,workspace.CurrentCamera)
task.delay(life,function() V.fxN-=1 pcall(function() p:Destroy() end) end)
return p
end
V.burst=function(pos,col,n,spd,size,life,o)
o=o or {}
local p=V.fxSpawn("Part",{Name="USMP_FX",Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Transparency=1,Size=Vector3.new(.2,.2,.2),CFrame=CFrame.new(pos)},life+.6)
if not p then return end
local e=Instance.new("ParticleEmitter")
e.Texture=o.tex or "rbxasset://textures/particles/sparkles_main.dds"
e.Color=ColorSequence.new(col) e.LightEmission=o.le or 1 e.Rate=0 e.Drag=o.drag or 3
e.Lifetime=NumberRange.new(life*.6,life) e.Speed=NumberRange.new(spd*.4,spd)
e.SpreadAngle=o.spread or Vector2.new(180,180)
if o.acc then e.Acceleration=o.acc end
e.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,size),NumberSequenceKeypoint.new(1,o.grow or 0)})
e.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,o.t0 or 0),NumberSequenceKeypoint.new(.7,.3),NumberSequenceKeypoint.new(1,1)})
e.Parent=p e:Emit(n)
end
V.ringFx=function(pos,col,dia,life,th,t0)
local p=V.fxSpawn("Part",{Name="USMP_FX",Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Shape=Enum.PartType.Cylinder,Material=Enum.Material.Neon,Color=col,Transparency=t0 or .25,Size=Vector3.new(th,1,1),CFrame=CFrame.new(pos)*CFrame.Angles(0,0,1.5708)},life+.1)
if not p then return end
V.TS:Create(p,TweenInfo.new(life,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(th,dia,dia),Transparency=1}):Play()
end
V.pillarFx=function(pos,col,h,d,life)
local p=V.fxSpawn("Part",{Name="USMP_FX",Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Shape=Enum.PartType.Cylinder,Material=Enum.Material.Neon,Color=col,Transparency=.3,Size=Vector3.new(.4,d,d),CFrame=CFrame.new(pos+Vector3.new(0,.2,0))*CFrame.Angles(0,0,1.5708)},life+.1)
if not p then return end
V.TS:Create(p,TweenInfo.new(life,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(h,d*.35,d*.35),CFrame=CFrame.new(pos+Vector3.new(0,h/2,0))*CFrame.Angles(0,0,1.5708),Transparency=1}):Play()
end
V.shakeT,V.shakeA=0,0
V.shake=function(a) if V.cfg.msh then V.shakeA=a V.shakeT=os.clock() end end
pcall(function() V.RS:UnbindFromRenderStep("USMP_SHAKE") end)
pcall(function()
V.RS:BindToRenderStep("USMP_SHAKE",Enum.RenderPriority.Camera.Value+1,function()
local el=os.clock()-V.shakeT
if el<.3 and V.shakeA>0 then
local k=(1-el/.3)*V.shakeA
local cm=workspace.CurrentCamera
cm.CFrame=cm.CFrame*CFrame.Angles((math.random()-.5)*k,(math.random()-.5)*k,(math.random()-.5)*k*.5)
end
end)
end)
V.hm=V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(40,40),BackgroundTransparency=1,GroupTransparency=1,BorderSizePixel=0},V.gui)
V.hmS=V.new("UIScale",{},V.hm)
V.hmB={}
for i=0,3 do
local a=math.rad(45+i*90)
V.hmB[i+1]=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Position=UDim2.new(.5,math.cos(a)*11,.5,math.sin(a)*11),Size=UDim2.fromOffset(3,9),Rotation=45+i*90-90},V.hm)
end
V.hitMark=function(col)
for _,b in ipairs(V.hmB) do b.BackgroundColor3=col end
V.hm.GroupTransparency=0 V.hmS.Scale=1.5
V.TS:Create(V.hmS,TweenInfo.new(.12),{Scale=1}):Play()
V.TS:Create(V.hm,TweenInfo.new(.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{GroupTransparency=1}):Play()
end
V.kfl=V.new("Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),Visible=false},V.gui)
V.killFx=function(pos)
if not V.cfg.kfx then return end
local a=V.acc()
if V.cfg.kfxf then
V.kfl.BackgroundColor3=a:Lerp(Color3.new(1,1,1),.5) V.kfl.BackgroundTransparency=.72 V.kfl.Visible=true
V.TS:Create(V.kfl,TweenInfo.new(.4),{BackgroundTransparency=1}):Play()
task.delay(.45,function() if V.kfl.BackgroundTransparency>=.99 then V.kfl.Visible=false end end)
V.hitMark(Color3.fromRGB(255,60,60))
end
if V.cfg.kfxp and pos then
V.burst(pos,a,60,24,.55,1.1)
V.burst(pos,Color3.new(1,1,1),30,14,.35,.8)
V.ringFx(pos-Vector3.new(0,2.5,0),a,10,.6,.2)
end
end
V.heldT,V.heldK=0,nil
V.held=function(now)
if now-V.heldT>.5 then
V.heldT=now V.heldK=nil
local ch=V.lp.Character
if ch then
for _,i in ipairs(ch:GetChildren()) do
if i:IsA("Tool") or i:IsA("Model") or i:IsA("BasePart") then
local n=i.Name:lower()
if n:find("mace") or n:find("булав") then V.heldK="mace" break
elseif n:find("sword") or n:find("меч") then V.heldK="sword" end
end
end
end
end
return V.heldK
end
-- MACE: ground slam (3 shockwaves, energy pillar, dust cloud, falling embers, shake)
V.maceFx=function(pos,frac)
local a=V.acc()
local ground=pos-Vector3.new(0,2.8,0)
pcall(function()
V.fxRP.FilterDescendantsInstances=V.fxFilter()
local r=workspace:Raycast(pos,Vector3.new(0,-14,0),V.fxRP)
if r then ground=r.Position+Vector3.new(0,.1,0) end
end)
if V.cfg.msw then
V.ringFx(ground,a,22+frac*34,.6,.3)
task.delay(.1,function() V.ringFx(ground,Color3.new(1,1,1),14+frac*20,.5,.2) end)
task.delay(.2,function() V.ringFx(ground,a,8+frac*10,.4,.2) end)
V.pillarFx(ground,a,5+frac*9,3,.5)
end
V.burst(ground,Color3.fromRGB(150,140,130),24,26,1.2,1.1,{tex="rbxasset://textures/particles/smoke_main.dds",le=0,acc=Vector3.new(0,-25,0),spread=Vector2.new(40,40),drag=1,grow=3,t0=.3})
V.burst(ground,a,40,34,.35,1,{acc=Vector3.new(0,-45,0),spread=Vector2.new(55,55),drag=.5})
V.shake(.06+frac*.14)
end
-- SWORD: crossing neon slash lines facing the camera + fine white sparks
V.slashFx=function(pos,frac)
local col=V.acc()
local base=CFrame.lookAt(pos,workspace.CurrentCamera.CFrame.Position)
local function one(ang,len,c,w)
local p=V.fxSpawn("Part",{Name="USMP_FX",Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Material=Enum.Material.Neon,Color=c,Transparency=0,Size=Vector3.new(w,.4,w),CFrame=base*CFrame.Angles(0,0,ang)},.4)
if not p then return end
V.TS:Create(p,TweenInfo.new(.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=Vector3.new(w,len,w),Transparency=1}):Play()
end
local len=3.6+math.min(frac,.5)*4
local ang=math.rad(35+(math.random()-.5)*20)
one(ang,len,Color3.new(1,1,1),.1)
one(ang,len*.8,col,.2)
if V.cfg.swc then
task.delay(.07,function()
local a2=math.rad(-40+(math.random()-.5)*20)
one(a2,len,Color3.new(1,1,1),.1)
one(a2,len*.8,col,.2)
end)
end
V.burst(pos,Color3.new(1,1,1),12,18,.18,.3)
end
V.hitFxT=0
V.hitFx=function(now,frac,pos)
if now-V.hitFxT<.07 then return end
V.hitFxT=now
local k=V.held(now)
local mace=V.cfg.mace and (k=="mace" or (V.cfg.mthr>0 and frac>=V.cfg.mthr/100))
local sword=(not mace) and V.cfg.swd and k=="sword"
if V.cfg.hf and V.cfg.hfm then V.hitMark(mace and Color3.fromRGB(255,170,0) or (sword and Color3.fromRGB(120,220,255) or Color3.new(1,1,1))) end
if mace then V.maceFx(pos,math.min(frac,.6))
elseif sword then V.slashFx(pos,math.min(frac,.6))
elseif V.cfg.hf and V.cfg.hfx then
local col=frac>.25 and Color3.fromRGB(255,85,85) or (frac>.1 and V.GOLD or V.acc())
V.burst(pos,col,8+math.floor(frac*60),10+frac*20,.3,.45)
end
end

V.f3 = V.new("Frame",{BackgroundTransparency=1,Position=UDim2.new(0,8,0,8),Size=UDim2.new(0,260,0,48)},V.gui)
V.rows = {}
for i=1,3 do
local bg=V.new("Frame",{BackgroundColor3=V.BLK,BackgroundTransparency=.45,BorderSizePixel=0,Size=UDim2.new(0,100,0,15)},V.f3)
V.rows[i]={bg,V.tx(bg,{Position=UDim2.new(0,4,0,2),Size=UDim2.new(1,-8,0,12),TextSize=11})}
end
V.drag(V.f3,V.f3)
V.fps, V.png = 60, 0
V.C(V.RS.RenderStepped:Connect(function(dt) V.fps+=(1/math.max(dt,.001)-V.fps)*.1 end))
V.wcache = {}
V.updWM = function()
pcall(function() V.png=V.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
local Ls={'<font color="'..V.hex(V.acc())..'">Unstable SMP FFA</font> <font color="#AAAAAA">1.21.11</font>'}
if V.cfg.fps then Ls[#Ls+1]=math.floor(V.fps+.5)..' fps <font color="#AAAAAA">|</font> '..math.floor(V.png+.5)..' ms' end
local r=V.lp.Character and V.lp.Character:FindFirstChild("HumanoidRootPart")
if V.cfg.xyz and r then local q=r.Position Ls[#Ls+1]=string.format("XYZ: %.1f / %.1f / %.1f",q.X,q.Y,q.Z) end
local y=0
for i=1,3 do
local s=Ls[i] V.rows[i][1].Visible=s~=nil
if s then
V.rows[i][2](s)
local plain=(s:gsub("<[^>]+>",""))
local w=V.wcache[#plain]
if not w then w=V.TXT:GetTextSize(plain,11,V.FONT,Vector2.new(1000,50)).X V.wcache[#plain]=w end
V.rows[i][1].Size=UDim2.new(0,w+10,0,15)
V.rows[i][1].Position=UDim2.new(0,0,0,y) y+=16
end
end
V.f3.Visible=V.cfg.wm and V.cfg.wms==1
if V.wmStyle then pcall(V.wmStyle) end
end
task.spawn(function() while V.gui.Parent do V.updWM() task.wait(.4) end end)

V.g = function(f) if not f then return nil end local okk,v=pcall(f) if okk then return v end end
V.Src = function(h)
local o={n={},pk=20,t=os.clock(),ver=0,busy=false,stale=false}
function o.bind()
local ch=h.Parent if not ch or o.busy then return end
o.busy=true o.t=os.clock() o.stale=false
local pl=V.Players:GetPlayerFromCharacter(ch)
local n={}
local function chk(i)
local function try(name,get)
local l=name:lower()
if l:find("absor") or l:find("overheal") or l:find("golden") then n.ab=n.ab or get
elseif l:find("max") and (l:find("health") or l:find("hp")) then n.mx=n.mx or get
elseif l:find("health") or l:find("hp") then n.hp=n.hp or get end
end
for k,v in pairs(i:GetAttributes()) do if type(v)=="number" then try(k,function() return i:GetAttribute(k) end) end end
if i:IsA("NumberValue") or i:IsA("IntValue") then try(i.Name,function() return i.Value end) end
if i:IsA("TextLabel") and not n.hp and i.Text:match("[%d%.]+%s*/%s*[%d%.]+") then
n.hp=function() return tonumber(i.Text:match("([%d%.]+)%s*/")) end
n.mx=function() return tonumber(i.Text:match("/%s*([%d%.]+)")) end
end
end
task.spawn(function()
local items={ch,h}
if pl then items[#items+1]=pl end
for _,i in ipairs(ch:GetDescendants()) do items[#items+1]=i end
if pl then for _,i in ipairs(pl:GetDescendants()) do if #items<8000 and not i:IsDescendantOf(V.gui) then items[#items+1]=i end end end
for idx,i in ipairs(items) do
pcall(chk,i)
if idx%150==0 then task.wait() if not h.Parent then o.busy=false return end end
end
o.n=n o.ver+=1 o.busy=false
end)
end
function o.read()
local n=o.n
local hp=V.g(n.hp) local mx=V.g(n.mx) local ab=V.g(n.ab)
if n.hp and type(hp)~="number" then o.stale=true end
if type(hp)~="number" then hp=h.Health end
if type(mx)~="number" then if n.hp then o.pk=math.max(o.pk,hp) mx=o.pk else mx=h.MaxHealth end end
if type(ab)~="number" then ab=0 end
mx=math.max(mx,1)
if hp>mx then ab+=hp-mx hp=mx end
return math.max(hp,0),mx,ab
end
o.bind()
return o
end
V.isFr = function(ch) local p=V.Players:GetPlayerFromCharacter(ch) return p~=nil and V.cfg.fr[p.Name:lower()]==true end
V.hud = V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,.6,0),Size=UDim2.new(0,250,0,60),BackgroundColor3=V.BLK,BackgroundTransparency=.6,GroupTransparency=1,BorderSizePixel=0},V.gui)
V.slot = V.new("Frame",{BackgroundColor3=Color3.fromRGB(55,55,55),BorderSizePixel=0,Position=UDim2.new(0,6,0,8),Size=UDim2.new(0,44,0,44)},V.hud)
V.avs = V.stroke(V.slot,V.acc(),2)
V.av = V.new("ImageLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Image=""},V.slot)
V.setN = V.tx(V.hud,{Position=UDim2.new(0,58,0,1),Size=UDim2.new(0,110,0,14),TextSize=13})
V.setD = V.tx(V.hud,{Position=UDim2.new(0,150,0,2),Size=UDim2.new(0,92,0,14),TextSize=11,Align=Enum.TextXAlignment.Right,Color=V.GRY})
V.setH = V.tx(V.hud,{Position=UDim2.new(0,58,0,42),Size=UDim2.new(0,185,0,12),TextSize=11,Color=V.GRY})
V.goldRow = V.new("Frame",{BackgroundTransparency=1,Position=UDim2.new(0,58,0,16),Size=UDim2.new(0,160,0,9),Visible=false},V.hud)
V.redRow = V.new("Frame",{BackgroundTransparency=1,Position=UDim2.new(0,58,0,27),Size=UDim2.new(0,160,0,10)},V.hud)
V.gc, V.rc = {}, {}
for i=1,10 do
local c=V.new("Frame",{BackgroundColor3=Color3.fromRGB(60,45,0),BackgroundTransparency=.2,BorderSizePixel=0,Position=UDim2.new(0,(i-1)*16,0,0),Size=UDim2.new(0,14,1,0)},V.goldRow)
V.stroke(c,V.BLK,1)
V.gc[i]=V.new("Frame",{BackgroundColor3=V.GOLD,BorderSizePixel=0,Size=UDim2.new(0,0,1,0)},c)
local r=V.new("Frame",{BackgroundColor3=Color3.fromRGB(45,0,0),BackgroundTransparency=.2,BorderSizePixel=0,Position=UDim2.new(0,(i-1)*16,0,0),Size=UDim2.new(0,14,1,0)},V.redRow)
V.stroke(r,V.BLK,1)
local gg=V.new("Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Size=UDim2.new(0,0,1,0)},r)
V.rc[i]={gg,V.new("Frame",{BackgroundColor3=Color3.fromRGB(255,40,40),BorderSizePixel=0,Size=UDim2.new(0,0,1,0)},r)}
end
V.drag(V.hud,V.hud)
V.wl = V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,56),Size=UDim2.new(0,230,0,78),BackgroundTransparency=1,GroupTransparency=1,BorderSizePixel=0},V.gui)
V.wsc = V.new("UIScale",{},V.wl)
V.setW1 = V.tx(V.wl,{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,32),TextSize=28,Align=Enum.TextXAlignment.Center})
V.setW2 = V.tx(V.wl,{Position=UDim2.new(0,0,0,38),Size=UDim2.new(1,0,0,12),TextSize=10,Align=Enum.TextXAlignment.Center,Color=V.GRY})
V.wbar = V.new("Frame",{BackgroundColor3=Color3.fromRGB(255,85,85),BorderSizePixel=0,Position=UDim2.new(.5,-70,0,58),Size=UDim2.new(0,140,0,8)},V.wl)
V.stroke(V.wbar,V.BLK,1)
V.wfill = V.new("Frame",{BackgroundColor3=V.GRN,BorderSizePixel=0,Size=UDim2.new(.5,0,1,0)},V.wbar)
V.new("Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Position=UDim2.new(.5,-1,0,-2),Size=UDim2.new(0,2,1,4)},V.wbar)
V.drag(V.wl,V.wl)
V.hums = {}
V.add = function(i) if i:IsA("Humanoid") then V.hums[i]=true end end
for _,i in ipairs(workspace:GetDescendants()) do V.add(i) end
V.C(workspace.DescendantAdded:Connect(V.add))
V.C(workspace.DescendantRemoving:Connect(function(i) V.hums[i]=nil end))
V.cur, V.S, V.seen, V.dist, V.vis, V.wvis = nil, nil, 0, 0, false, false
V.shown, V.ghost, V.sab, V.last, V.lastAb = 0, 0, 0, 0, 0
V.evD, V.evT, V.pT, V.pM, V.lastDealt, V.ss, V.winS, V.wsShown = {}, {}, nil, nil, 0, 0, true, nil
V.sver, V.mver = nil, nil
V.meS, V.meH = nil, nil
V.near = {}
V.healI = 0
V.getMe = function()
local c=V.lp.Character local h=c and c:FindFirstChildOfClass("Humanoid")
if h~=V.meH then V.meH=h V.meS=h and V.Src(h) or nil V.pM=nil V.mver=nil end
return V.meS
end
V.wsum = function(ev,now) local s,k=0,1 while ev[k] do if now-ev[k][1]>5 then table.remove(ev,k) else s+=ev[k][2] k+=1 end end return s end
V.pick = function()
local c=V.lp.Character local mr=c and c:FindFirstChild("HumanoidRootPart") if not mr then V.near={} return end
local cm=workspace.CurrentCamera local vs=cm.ViewportSize/2
local Ls={}
for h in pairs(V.hums) do
local ch=h.Parent
if ch and ch~=c and h.Health>0 and not (V.cfg.skipf and V.isFr(ch)) then
local r=h.RootPart or ch:FindFirstChild("HumanoidRootPart")
if r then
local d=(r.Position-mr.Position).Magnitude
if d<=V.cfg.range then
local v,on=cm:WorldToViewportPoint(r.Position)
Ls[#Ls+1]={h=h,d=d,s=d+(on and (Vector2.new(v.X,v.Y)-vs).Magnitude/25 or 60)-(h==V.cur and 15 or 0)}
end
end
end
end
table.sort(Ls,function(a,b) return a.s<b.s end)
V.near={} for i=1,math.min(6,#Ls) do V.near[i]=Ls[i] end
if Ls[1] then return Ls[1].h,Ls[1].d end
end
V.setTarget = function(h)
V.cur=h V.S=V.Src(h)
local p=V.Players:GetPlayerFromCharacter(h.Parent)
local nm=p and p.Name or h.Parent.Name
V.setN(V.isFr(h.Parent) and '<font color="#55FF55">'..nm..'</font>' or nm)
V.av.Image=p and ("rbxthumb://type=AvatarHeadShot&id="..p.UserId.."&w=150&h=150") or "rbxasset://textures/ui/GuiImagePlaceholder.png"
if V.thInfo then V.thInfo(nm,V.av.Image) end
local hp,mx,ab=V.S.read() V.shown,V.ghost,V.sab,V.last,V.lastAb=hp,hp,ab,hp,ab
V.sver=V.S.ver
V.evD,V.evT,V.pT,V.ss,V.winS,V.wsShown,V.lastDealt={},{},nil,0,true,nil,os.clock()
end

V.findPlayer = function(q)
q=q:lower() if q=="" then return nil end
local best
for _,p in ipairs(V.Players:GetPlayers()) do
if p~=V.lp then
local n,d=p.Name:lower(),p.DisplayName:lower()
if n==q or d==q then return p end
if not best and (n:sub(1,#q)==q or d:sub(1,#q)==q) then best=p end
end
end
return best
end
V.setFriend = function(name,on)
local k=name:lower()
V.cfg.fr[k]=on and true or nil
V.save()
if V.cur and V.cur.Parent then local p=V.Players:GetPlayerFromCharacter(V.cur.Parent) if p and p.Name:lower()==k then V.setTarget(V.cur) end end
if V.menuOpen then V.render() end
end
V.addFr = function(txt)
local name=(txt or ""):gsub("%s","")
if name=="" then V.notify("Type a nickname first") return end
local p=V.findPlayer(name)
local nm=p and p.Name or name
V.setFriend(nm,true) V.notify("Friend added: "..nm)
end
V.aimedPlayer = function()
local cm=workspace.CurrentCamera
local mr=V.lp.Character and V.lp.Character:FindFirstChild("HumanoidRootPart")
local best,bs
for _,p in ipairs(V.Players:GetPlayers()) do
local r=p~=V.lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if r then
local to=r.Position-cm.CFrame.Position
local ang=math.deg(math.acos(math.clamp(to.Unit:Dot(cm.CFrame.LookVector),-1,1)))
local d=mr and (r.Position-mr.Position).Magnitude or to.Magnitude
local s=ang+d/10
if d<=150 and (not bs or s<bs) then best,bs=p,s end
end
end
return best
end
V.nearestPlayer = function()
local mr=V.lp.Character and V.lp.Character:FindFirstChild("HumanoidRootPart") if not mr then return end
local best,bd
for _,p in ipairs(V.Players:GetPlayers()) do
local r=p~=V.lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
if r then local d=(r.Position-mr.Position).Magnitude if not bd or d<bd then best,bd=p,d end end
end
return best
end
V.toggleAimFriend = function()
local p=V.aimedPlayer()
if not p then V.notify("No player in sight") return end
local on=not V.cfg.fr[p.Name:lower()]
V.setFriend(p.Name,on) V.notify((on and "Friend added: " or "Friend removed: ")..p.Name)
end
V.addCurFriend = function()
local p=V.cur and V.cur.Parent and V.Players:GetPlayerFromCharacter(V.cur.Parent)
if p then V.addFr(p.Name) else V.notify("No player target") end
end
V.addNearFriend = function()
local p=V.nearestPlayer() if p then V.addFr(p.Name) else V.notify("Nobody nearby") end
end

V.flash = function(c) V.avs.Color=c V.TS:Create(V.avs,TweenInfo.new(.45),{Color=V.acc()}):Play() end
V.sc = setmetatable({},{__mode="k"})
V.srcOf = function(h) local s=V.sc[h] if not s then s=V.Src(h) V.sc[h]=s end return s end

V.lines, V.dots, V.lcache, V.dcache, V.lastL, V.lastD = {},{},{},{},0,0
V.lineN, V.dotN = 0, 0
V.r2 = function(x) return math.floor(x*2+.5)/2 end
V.seg = function(x1,y1,x2,y2,col,th,tp)
V.lineN+=1
local f,c=V.lines[V.lineN],V.lcache[V.lineN]
if not f then f=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0,Visible=false},V.gui) c={} V.lines[V.lineN]=f V.lcache[V.lineN]=c end
local dx,dy=x2-x1,y2-y1
local len=V.r2(math.sqrt(dx*dx+dy*dy)) local mx,my=V.r2((x1+x2)/2),V.r2((y1+y2)/2)
local rot=math.floor(math.deg(math.atan2(dy,dx))*2+.5)/2
if not c.v then c.v=true f.Visible=true end
if c.col~=col then c.col=col f.BackgroundColor3=col end
if c.tp~=tp then c.tp=tp f.BackgroundTransparency=tp end
if c.l~=len or c.th~=th then c.l=len c.th=th f.Size=UDim2.fromOffset(len,th) end
if c.x~=mx or c.y~=my then c.x=mx c.y=my f.Position=UDim2.fromOffset(mx,my) end
if c.r~=rot then c.r=rot f.Rotation=rot end
end
V.dot = function(x,y,px,col,tp)
V.dotN+=1
local f,c=V.dots[V.dotN],V.dcache[V.dotN]
if not f then
f=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0,Visible=false},V.gui)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},f)
c={} V.dots[V.dotN]=f V.dcache[V.dotN]=c
end
px=math.max(V.r2(px),2) x,y=V.r2(x),V.r2(y)
if not c.v then c.v=true f.Visible=true end
if c.col~=col then c.col=col f.BackgroundColor3=col end
if c.tp~=tp then c.tp=tp f.BackgroundTransparency=tp end
if c.s~=px then c.s=px f.Size=UDim2.fromOffset(px,px) end
if c.x~=x or c.y~=y then c.x=x c.y=y f.Position=UDim2.fromOffset(x,y) end
end
V.geo = setmetatable({},{__mode="k"})
V.bounds = function(ch,rootPart,now)
local gg=V.geo[ch]
local ry=rootPart.Position.Y
if not gg or now>gg.t then
local mn,mx=math.huge,-math.huge
for _,p in ipairs(ch:GetDescendants()) do
if p:IsA("BasePart") and p.Transparency<.99 and not p:FindFirstAncestorOfClass("Tool") then
local cf,s=p.CFrame,p.Size
local hy=(math.abs(cf.RightVector.Y)*s.X+math.abs(cf.UpVector.Y)*s.Y+math.abs(cf.LookVector.Y)*s.Z)/2
mn=math.min(mn,cf.Position.Y-hy) mx=math.max(mx,cf.Position.Y+hy)
end
end
if mn==math.huge or mx-mn<1.5 then mn,mx=ry-3,ry+2.6 end
gg={t=now+1.2+math.random()*.6,f=mn-ry,u=mx-ry} V.geo[ch]=gg
end
return ry+gg.f,ry+gg.u
end
V.E_cm,V.E_cx,V.E_cz,V.E_col,V.E_t,V.E_kk=nil,nil,nil,nil,nil,nil
V.RX,V.RY,V.RZ={},{},{}
V.DX,V.DY,V.DZ={},{},{}
V.P = function(x,y,z) local s=V.E_cm:WorldToViewportPoint(Vector3.new(x,y,z)) return s.X,s.Y,s.Z end
V.ring = function(y,rr,th,tp,sweep)
local N=24
for s=0,N do
local a=s/N*6.2831853
V.RX[s],V.RY[s],V.RZ[s]=V.P(V.E_cx+math.cos(a)*rr,y,V.E_cz+math.sin(a)*rr)
end
for s=0,N-1 do
if V.RZ[s]>0 and V.RZ[s+1]>0 then
local gl=0
if sweep then local df=(s/N*6.2831853-V.E_t*2.5)%6.2831853 gl=math.max(0,1-df/2.827) end
V.seg(V.RX[s],V.RY[s],V.RX[s+1],V.RY[s+1],V.E_col,th+gl*3,tp-gl*tp)
end
end
end
V.edgeD = function(i,j)
if V.DZ[i]>0 and V.DZ[j]>0 then
V.seg(V.DX[i],V.DY[i],V.DX[j],V.DY[j],V.E_col,5,.75)
V.seg(V.DX[i],V.DY[i],V.DX[j],V.DY[j],V.E_col,2,0)
end
end

-- Crystals ESP: 8 real 3D crystals on the corners of every body part (V.CR = pool of parts)
V.crC, V.crPs, V.crCf, V.CRMAX = {}, {}, {}, 6
V.crParts = setmetatable({},{__mode="k"})
V.crGet=function(i)
local p=V.CR[i]
if p and p.Parent then return p end
p=V.new("Part",{Name="USMP_CR",Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Massless=true,Material=Enum.Material.Neon,Transparency=1,Size=Vector3.new(.3,.3,.3)},workspace.CurrentCamera)
V.CR[i]=p V.crC[i]={}
return p
end
V.crHide=function(from)
for i=from,#V.CR do local c=V.crC[i] if c and c.on then c.on=false V.CR[i].Transparency=1 end end
end
V.CRT=CFrame.Angles(.6155,0,.7854)
V.crPut=function(i,pos,s,col,rot)
local p=V.crGet(i) local c=V.crC[i]
if not c.on then c.on=true p.Transparency=.2 end
if c.col~=col then c.col=col p.Color=col end
if c.s~=s then c.s=s p.Size=Vector3.new(s,s,s) end
V.crPs[i]=p V.crCf[i]=CFrame.new(pos)*rot
end
V.crList=function(ch,now)
local c=V.crParts[ch]
if not c or now>c.t then
local l={}
for _,p in ipairs(ch:GetDescendants()) do
if p:IsA("BasePart") and p.Name~="HumanoidRootPart" and p.Transparency<.99 and not p:FindFirstAncestorOfClass("Tool") and (p.Size.X>.35 or p.Size.Y>.35) then l[#l+1]=p end
end
table.sort(l,function(a,b) return a.Size.Magnitude>b.Size.Magnitude end)
while #l>V.CRMAX do l[#l]=nil end
c={t=now+1.5,list=l} V.crParts[ch]=c
end
return c.list
end

V.EMPTY = {}
V.oneE = {}
V.oneL = {V.oneE}
V.espFrame = function(now)
V.lineN,V.dotN=0,0
local crN=0
if V.cfg.esp then
local list=V.EMPTY
if V.cfg.escope==1 then
if V.vis and V.cur and V.cur.Parent then V.oneE.h=V.cur V.oneE.d=V.dist list=V.oneL end
else list=V.near end
if list~=V.EMPTY then
local cm=workspace.CurrentCamera
V.E_cm=cm
V.E_kk=cm.ViewportSize.Y/(2*math.tan(math.rad(cm.FieldOfView)/2))
local scl=V.cfg.esize/100
V.E_t=now*(V.cfg.espd/10)
for _,e in ipairs(list) do
local h=e.h local ch=h.Parent
local rootPart=ch and (h.RootPart or ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart)
if rootPart then
local fr=V.isFr(ch)
local col
if fr then col=V.GRN
elseif V.cfg.ecol==2 then local hp,mx=V.srcOf(h).read() col=Color3.fromHSV(.33*math.clamp(hp/mx,0,1),.85,1)
elseif V.cfg.ecol==3 then col=Color3.fromHSV((now*.25)%1,.7,1)
else col=V.acc() end
V.E_col=col
local feet,topY=V.bounds(ch,rootPart,now)
local H=math.max(topY-feet,2)
local rp=rootPart.Position
V.E_cx,V.E_cz=rp.X,rp.Z
local cy=(feet+topY)/2
local R=H*.4*scl
local st=V.cfg.estyle
if st==1 then
local d=H*.17*scl
local hy=topY+d*1.9+math.sin(now*2)*d*.25
V.DX[1],V.DY[1],V.DZ[1]=V.P(V.E_cx,hy+d,V.E_cz)
V.DX[2],V.DY[2],V.DZ[2]=V.P(V.E_cx,hy-d,V.E_cz)
for q=0,3 do
local a=V.E_t*2+q*1.5707963
V.DX[q+3],V.DY[q+3],V.DZ[q+3]=V.P(V.E_cx+math.cos(a)*d*.7,hy,V.E_cz+math.sin(a)*d*.7)
end
for q=1,4 do
local e1=q+2 local e2=(q%4)+3
V.edgeD(1,e1) V.edgeD(2,e1) V.edgeD(e1,e2)
end
elseif st==2 then
local base=H*.075*scl
for i=0,2 do
for k=0,7 do
local tt=V.E_t-k*.045
local a=tt*2.4+i*2.094
local y=math.sin(tt*1.4+i*1.9)*H*.42
local x,yy,z=V.P(V.E_cx+math.cos(a)*R,cy+y,V.E_cz+math.sin(a)*R)
if z>0 then
local px=base*V.E_kk/z*(1-k*.09)
if k==0 then V.dot(x,yy,px*2.6,col,.8) end
V.dot(x,yy,px,col,math.min(.1+k*.11,.95))
end
end
end
elseif st==3 then
V.ring(feet+H*.03,R*(1+.04*math.sin(now*3)),2,.5,true)
elseif st==4 then
V.ring(feet+H*.03,R,2,.8,false)
V.ring(feet+(math.sin(V.E_t*1.8)*.5+.5)*H,R*.9,3,.15,false)
else
local spin=now*(V.cfg.espd/10)*1.6
local gap=(V.cfg.esd/100)*scl
for _,pt in ipairs(V.crList(ch,now)) do
if pt.Parent and crN<300 then
local pp,sz=pt.Position,pt.Size
local cs=math.clamp(math.min(sz.X,sz.Y,sz.Z)*.22*scl,.12,.5)
local rad=(math.max(sz.X,sz.Z)*.5+.8)*gap
for i=0,7 do
crN+=1
local a=spin+i*.7854
local yo=((i%2==0) and 1 or -1)*sz.Y*.3
V.crPut(crN,pp+Vector3.new(math.cos(a)*rad,yo,math.sin(a)*rad),cs,col,CFrame.Angles(0,spin*1.5+crN*.7,0)*V.CRT)
end
end
end
end
end
end
end
V.crHide(crN+1)
for i=#V.crPs,crN+1,-1 do V.crPs[i]=nil V.crCf[i]=nil end
if crN>0 then
local okm=pcall(function() workspace:BulkMoveTo(V.crPs,V.crCf,Enum.BulkMoveMode.FireCFrameChanged) end)
if not okm then for j=1,crN do V.crPs[j].CFrame=V.crCf[j] end end
end
for i=V.lineN+1,V.lastL do local c=V.lcache[i] if c.v then c.v=false V.lines[i].Visible=false end end V.lastL=V.lineN
for i=V.dotN+1,V.lastD do local c=V.dcache[i] if c.v then c.v=false V.dots[i].Visible=false end end V.lastD=V.dotN
end

V.APS = {
{n="Dust",clock=16.8,amb=V.c3(125,95,72),out=V.c3(178,140,102),br=2.3,top=V.c3(255,200,140),bot=V.c3(120,82,54),fog=V.c3(206,162,115),fs=15,fe=380,exp=.1,
ad=.5,ao=.3,ac=V.c3(232,184,134),adc=V.c3(158,104,60),ag=.7,ah=2.4,cb=.02,cc=.14,cs=-.1,ct=V.c3(255,224,190),bi=.55,bs=26,bt=.95,ri=.2,rs=.85,df=.15,
pc=V.c3(225,190,140),pa=Vector3.new(4,.3,1.5),pr=55,ps=.18,pe=.15,hr=3,hc=V.c3(215,175,125)},
{n="Sunset",clock=18.1,amb=V.c3(110,70,90),out=V.c3(190,110,100),br=2.2,top=V.c3(255,150,90),bot=V.c3(110,60,90),fog=V.c3(232,140,110),fs=30,fe=500,exp=.1,
ad=.35,ao=.5,ac=V.c3(255,160,120),adc=V.c3(200,90,90),ag=1,ah=1.6,cb=0,cc=.1,cs=.1,ct=V.c3(255,205,200),bi=.6,bs=30,bt=.9,ri=.3,rs=.9,df=.05,
pc=V.c3(255,190,150),pa=Vector3.new(1,.5,0),pr=25,ps=.15,pe=.4,hr=1.5,hc=V.c3(255,170,130)},
{n="Mist",clock=7,amb=V.c3(130,140,155),out=V.c3(160,175,190),br=1.8,top=V.c3(220,235,255),bot=V.c3(100,115,135),fog=V.c3(190,205,220),fs=0,fe=220,exp=0,
ad=.6,ao=.1,ac=V.c3(205,218,232),adc=V.c3(180,195,215),ag=0,ah=3.2,cb=0,cc=.05,cs=-.15,ct=V.c3(225,238,255),bi=.3,bs=24,bt=1.1,ri=.08,rs=.6,df=.2,
pc=V.c3(225,235,245),pa=Vector3.new(1.5,.1,.8),pr=30,ps=.15,pe=.1,hr=5,hc=V.c3(215,228,240)},
{n="Night",clock=.5,amb=V.c3(40,50,90),out=V.c3(55,70,120),br=1.2,top=V.c3(80,100,170),bot=V.c3(20,25,55),fog=V.c3(18,24,52),fs=10,fe=300,exp=-.1,
ad=.3,ao=.4,ac=V.c3(40,55,110),adc=V.c3(20,30,70),ag=.2,ah=1,cb=-.02,cc=.1,cs=.05,ct=V.c3(190,205,255),bi=.7,bs=30,bt=.85,ri=0,rs=.5,df=.05,
pc=V.c3(190,210,255),pa=Vector3.new(.5,.2,.3),pr=20,ps=.12,pe=.6,hr=1,hc=V.c3(120,140,210)},
{n="Ember",clock=19,amb=V.c3(100,50,40),out=V.c3(150,70,50),br=1.9,top=V.c3(255,110,60),bot=V.c3(70,30,30),fog=V.c3(160,70,50),fs=10,fe=300,exp=.05,
ad=.55,ao=.3,ac=V.c3(220,100,60),adc=V.c3(130,50,40),ag=.8,ah=2.8,cb=-.02,cc=.18,cs=.05,ct=V.c3(255,190,170),bi=.8,bs=32,bt=.85,ri=.15,rs=.8,df=.08,
pc=V.c3(255,140,60),pa=Vector3.new(1,2.2,.5),pr=40,ps=.14,pe=1,hr=2,hc=V.c3(200,90,60)},
}
V.APN = {} for i,p in ipairs(V.APS) do V.APN[i]=p.n end
V.LPR = {{"Ambient","amb"},{"OutdoorAmbient","out"},{"Brightness","br"},{"ColorShift_Top","top"},{"ColorShift_Bottom","bot"},{"ClockTime","clock"},{"FogColor","fog"},{"FogStart","fs"},{"FogEnd","fe"},{"ExposureCompensation","exp"}}
V.atmW, V.atmOn, V.atmAcc = 0, false, 0
V.O, V.fx, V.hiddenAtm, V.skyList, V.skyHid = {},{},{},{},false
V.dust, V.em1, V.em2, V.dustPreset, V.dustT, V.dustSc = nil, nil, nil, nil, 0, nil
V.setp = function(o,p,v) o[p]=v end
V.killDust = function() if V.dust then pcall(function() V.dust:Destroy() end) end V.dust,V.em1,V.em2,V.dustPreset,V.dustSc=nil,nil,nil,nil,nil end
V.hideSky = function()
V.skyHid=true V.skyList={}
for _,i in ipairs(V.Lighting:GetChildren()) do if i:IsA("Sky") then V.skyList[#V.skyList+1]=i end end
for _,i in ipairs(V.skyList) do pcall(function() i.Parent=nil end) end
end
V.restoreSky = function()
V.skyHid=false
for _,i in ipairs(V.skyList) do pcall(function() i.Parent=V.Lighting end) end
V.skyList={}
end
V.atmCapture = function()
V.atmOn=true
for _,pr in ipairs(V.LPR) do local okr,v=pcall(function() return V.Lighting[pr[1]] end) if okr then V.O[pr[1]]=v end end
V.hiddenAtm={}
for _,i in ipairs(V.Lighting:GetChildren()) do if i:IsA("Atmosphere") then V.hiddenAtm[#V.hiddenAtm+1]=i end end
for _,i in ipairs(V.hiddenAtm) do pcall(function() i.Parent=nil end) end
V.fx.a=V.new("Atmosphere",{Name="USMP_ATM",Density=0,Haze=0,Glare=0,Offset=0},V.Lighting)
V.fx.cc=V.new("ColorCorrectionEffect",{Name="USMP_CC"},V.Lighting)
V.fx.bl=V.new("BloomEffect",{Name="USMP_BL",Intensity=0},V.Lighting)
V.fx.sr=V.new("SunRaysEffect",{Name="USMP_SR",Intensity=0},V.Lighting)
end
V.atmRestore = function()
V.atmOn=false
for name,v in pairs(V.O) do pcall(V.setp,V.Lighting,name,v) end
for _,i in pairs(V.fx) do pcall(function() i:Destroy() end) end V.fx={}
for _,i in ipairs(V.hiddenAtm) do pcall(function() i.Parent=V.Lighting end) end V.hiddenAtm={}
V.restoreSky()
V.killDust()
end
V.atmKill=V.atmRestore
V.makeDust = function()
local cm=workspace.CurrentCamera
V.dust=V.new("Part",{Name="USMP_DUST",Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,Transparency=1,Size=Vector3.new(140,70,140),CFrame=CFrame.new(cm.CFrame.Position)},cm)
local function emitter()
local e=Instance.new("ParticleEmitter")
e.Texture="rbxasset://textures/particles/smoke_main.dds"
e.Rate=0 e.Drag=.5 e.LightInfluence=.4
e.SpreadAngle=Vector2.new(180,180)
e.Rotation=NumberRange.new(0,360) e.RotSpeed=NumberRange.new(-20,20)
pcall(function() e.Shape=Enum.ParticleEmitterShape.Box e.ShapeStyle=Enum.ParticleEmitterShapeStyle.Volume e.ShapeInOut=Enum.ParticleEmitterShapeInOut.InAndOut end)
e.Parent=V.dust
return e
end
V.em1,V.em2=emitter(),emitter()
V.em1.Lifetime=NumberRange.new(6,10) V.em1.Speed=NumberRange.new(.3,1.2)
V.em2.Lifetime=NumberRange.new(10,14) V.em2.Speed=NumberRange.new(.4,1.5)
V.em2.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.3,.93),NumberSequenceKeypoint.new(.7,.95),NumberSequenceKeypoint.new(1,1)})
V.em2.LightEmission=0
V.em1.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.2,.45),NumberSequenceKeypoint.new(.8,.55),NumberSequenceKeypoint.new(1,1)})
V.dustPreset=nil V.dustSc=nil V.dustT=0
end
V.updateDust = function(p,k,now)
local cm=workspace.CurrentCamera
if V.dust.Parent~=cm then V.dust.Parent=cm end
V.dust.CFrame=CFrame.new(cm.CFrame.Position+Vector3.new(0,6,0))
local sc=V.cfg.ascl/100
if V.dustPreset~=V.cfg.apr or V.dustSc~=sc then
V.dustPreset=V.cfg.apr V.dustSc=sc
local NS,K=NumberSequence.new,NumberSequenceKeypoint.new
V.dust.Size=Vector3.new(140*sc,70*sc,140*sc)
V.em1.Color=ColorSequence.new(p.pc) V.em1.LightEmission=p.pe
V.em1.Size=NS({K(0,p.ps*.5*sc),K(.5,p.ps*sc),K(1,p.ps*.5*sc)})
V.em2.Color=ColorSequence.new(p.hc)
V.em2.Size=NS({K(0,14*sc),K(1,30*sc)})
end
if now-V.dustT>.25 then
V.dustT=now
local q=V.cfg.aq/100
local wind=p.pa+Vector3.new(math.sin(now*.23)*2,math.sin(now*.31)*.4,math.cos(now*.19)*1.5)
V.em1.Acceleration=wind V.em2.Acceleration=wind*.5
V.em1.Rate=p.pr*k*q*sc V.em2.Rate=p.hr*k*q
end
end
V.blend = function(name,tv,k)
local o=V.O[name] if o==nil then return end
local v
if typeof(o)=="Color3" then v=o:Lerp(tv,k)
elseif name=="ClockTime" then local d=((tv-o+12)%24)-12 v=(o+d*k)%24
elseif name=="FogEnd" then v=math.exp(o>1 and (math.log(o)+(math.log(tv)-math.log(o))*k) or math.log(tv))
else v=o+(tv-o)*k end
pcall(V.setp,V.Lighting,name,v)
end
V.atmSig,V.atmRefT=nil,0
V.atmStep = function(dt)
V.atmAcc+=dt
if V.atmAcc<.066 then return end
dt=V.atmAcc V.atmAcc=0
local want=V.cfg.atm and 1 or 0
V.atmW+=(want-V.atmW)*math.min(1,dt*2.5)
if math.abs(want-V.atmW)<.01 then V.atmW=want end
if want==0 and V.atmW==0 then
if V.atmOn then V.atmRestore() V.atmSig=nil end
return
end
if not V.atmOn then V.atmCapture() V.atmSig=nil end
local p=V.APS[V.cfg.apr] or V.APS[1]
local k=V.atmW*(V.cfg.aint/100)
local now=os.clock()
local sig=V.cfg.apr..string.format("|%.3f|",k)..tostring(V.cfg.asky)..tostring(V.cfg.arays)
if sig~=V.atmSig or now-V.atmRefT>1 then
V.atmSig=sig V.atmRefT=now
if V.cfg.asky and not V.skyHid then V.hideSky() elseif not V.cfg.asky and V.skyHid then V.restoreSky() end
for _,pr in ipairs(V.LPR) do V.blend(pr[1],p[pr[2]],k) end
local a=V.fx.a if a then a.Density=p.ad*k a.Offset=p.ao*k a.Color=p.ac a.Decay=p.adc a.Glare=p.ag*k a.Haze=p.ah*k end
local cc=V.fx.cc if cc then cc.Brightness=p.cb*k cc.Contrast=p.cc*k cc.Saturation=p.cs*k cc.TintColor=Color3.new(1,1,1):Lerp(p.ct,k) end
local bl=V.fx.bl if bl then bl.Intensity=p.bi*k bl.Size=p.bs bl.Threshold=p.bt end
local sr=V.fx.sr if sr then sr.Intensity=V.cfg.arays and p.ri*k or 0 sr.Spread=p.rs end
end
if V.cfg.apart then
if not V.dust then V.makeDust() end
V.updateDust(p,k,now)
elseif V.dust then V.killDust() end
end
V.C(V.RS.RenderStepped:Connect(V.atmStep))

-- RAIN: falling streaks on the screen + ripples on water around you
V.rnN=110
V.rnD={}
for i=1,V.rnN do
local len=14+math.random()*20
local f=V.new("Frame",{BackgroundColor3=Color3.fromRGB(200,220,255),BackgroundTransparency=.55,BorderSizePixel=0,AnchorPoint=Vector2.new(.5,.5),Visible=false,Size=UDim2.fromOffset(len>26 and 2 or 1,len),Rotation=11},V.gui)
V.rnD[i]={f=f,px=0,py=0,sp=.8+math.random()*.7,on=false}
end
V.rnRP=RaycastParams.new() V.rnRP.FilterType=Enum.RaycastFilterType.Exclude
V.rnOn,V.rnAcc=false,0
V.rainFrame=function(now,dt)
if not V.cfg.rain then
if V.rnOn then V.rnOn=false for _,d in ipairs(V.rnD) do d.f.Visible=false d.on=false end end
return
end
V.rnOn=true
local cm=workspace.CurrentCamera local vp=cm.ViewportSize
local cnt=math.floor(V.rnN*V.cfg.rni/100)
for i,d in ipairs(V.rnD) do
if i<=cnt then
if not d.on then d.on=true d.f.Visible=true d.px=math.random()*(vp.X+260) d.py=math.random()*vp.Y end
d.py+=900*d.sp*dt d.px-=180*d.sp*dt
if d.py>vp.Y+30 or d.px<-20 then d.py=-30 d.px=math.random()*(vp.X+260) end
d.f.Position=UDim2.fromOffset(V.r2(d.px),V.r2(d.py))
elseif d.on then d.on=false d.f.Visible=false end
end
if V.cfg.rnr then
V.rnAcc+=dt
if V.rnAcc>.12 then
V.rnAcc=0
pcall(function()
local cp=cm.CFrame.Position
V.rnRP.FilterDescendantsInstances=V.fxFilter()
for _=1,math.floor(V.cfg.rni/25)+1 do
local a=math.random()*6.283 local r=4+math.random()*34
local o=Vector3.new(cp.X+math.cos(a)*r,cp.Y+25,cp.Z+math.sin(a)*r)
local res=workspace:Raycast(o,Vector3.new(0,-80,0),V.rnRP)
if res and (res.Material==Enum.Material.Water or res.Instance.Name:lower():find("water")) then
V.ringFx(res.Position+Vector3.new(0,.05,0),Color3.fromRGB(215,235,255),2.6+math.random()*1.4,.9,.04,.45)
end
end
end)
end
end
end

V.popPool = {}
for i=1,10 do
local f=V.new("CanvasGroup",{BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Size=UDim2.new(0,120,0,24),Visible=false,GroupTransparency=1,BorderSizePixel=0},V.gui)
local us=V.new("UIScale",{},f)
local set=V.tx(f,{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),TextSize=18,Align=Enum.TextXAlignment.Center})
V.popPool[i]={f=f,us=us,set=set,on=false,t0=0,sc=1,dx=0,pos=Vector3.new()}
end
V.cb = V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,120,.5,-20),Size=UDim2.new(0,120,0,42),BackgroundTransparency=1,GroupTransparency=1,BorderSizePixel=0},V.gui)
V.cbs = V.new("UIScale",{},V.cb)
V.setCb = V.tx(V.cb,{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,22),TextSize=18,Align=Enum.TextXAlignment.Center})
V.setCb2 = V.tx(V.cb,{Position=UDim2.new(0,0,0,22),Size=UDim2.new(1,0,0,10),TextSize=9,Align=Enum.TextXAlignment.Center,Color=V.GRY})
V.cbBar = V.new("Frame",{BackgroundColor3=V.acc(),BorderSizePixel=0,Position=UDim2.new(0,12,0,35),Size=UDim2.new(1,-24,0,3)},V.cb)
V.drag(V.cb,V.cb)
V.combo, V.comboT, V.comboBest, V.cbShown, V.cbLast, V.cbW = 0, 0, 0, false, -1, -1
V.spawnPop = function(pos,dmg,frac)
local p
for _,q in ipairs(V.popPool) do if not q.on then p=q break end end
p=p or V.popPool[1]
p.on=true p.t0=os.clock() p.pos=pos p.dx=(math.random()-.5)*1.4
local col
if V.cfg.hfcol==2 then col=V.acc()
elseif frac>.25 then col=Color3.fromRGB(255,85,85)
elseif frac>.1 then col=V.GOLD
else col=Color3.new(1,1,1) end
p.sc=1+math.min(frac*2.5,.7)
p.set('<font color="'..V.hex(col)..'">-'..string.format("%.1f",dmg)..'</font>')
p.f.Visible=true
end
V.hitEvent = function(now,dmg,frac,pos)
if V.cfg.hf then
V.combo+=1 V.comboT=now V.comboBest=math.max(V.comboBest,V.combo)
if V.cfg.hfn then V.spawnPop(pos,dmg,frac) end
if V.cfg.hfc then
V.cbs.Scale=1.35
V.TS:Create(V.cbs,TweenInfo.new(.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
end
end
pcall(V.hitFx,now,frac,pos)
end
V.popFrame = function(now)
local cm=workspace.CurrentCamera
for _,p in ipairs(V.popPool) do
if p.on then
local el=now-p.t0
if el>.95 then p.on=false p.f.Visible=false
else
local v=cm:WorldToViewportPoint(p.pos+Vector3.new(p.dx,el*2.2,0))
if v.Z>0 then
p.f.Position=UDim2.fromOffset(v.X,v.Y) p.f.Visible=true
local a=el<.12 and el/.12 or 1-(el-.12)/.83
p.f.GroupTransparency=1-math.clamp(a,0,1)
p.us.Scale=p.sc*(1+.3*math.max(0,1-el/.2))
else p.f.Visible=false end
end
end
end
end
V.comboFrame = function(now)
if not V.cfg.hf then V.combo=0 end
local show=V.cfg.hf and V.cfg.hfc and V.combo>0 and now-V.comboT<V.cfg.hfto
if V.combo>0 and now-V.comboT>=V.cfg.hfto then V.combo=0 end
if show~=V.cbShown then V.cbShown=show V.TS:Create(V.cb,TweenInfo.new(.2),{GroupTransparency=show and 0 or 1}):Play() end
if show then
if V.combo~=V.cbLast then
V.cbLast=V.combo
V.setCb('<font color="'..V.hex(V.acc())..'">x'..V.combo..'</font> COMBO')
V.setCb2("best x"..V.comboBest)
end
local w=math.floor(math.clamp(1-(now-V.comboT)/V.cfg.hfto,0,1)*50+.5)/50
if w~=V.cbW then V.cbW=w V.cbBar.Size=UDim2.new(w,-24*w,0,3) V.cbBar.BackgroundColor3=V.acc() end
end
end

V.TSN, V.TCN = {"Pixels","Echo","Helix"},{"Accent","Rainbow","Fire","Ice"}
V.trPool, V.trFree, V.trAct = {}, {}, {}
V.trLastPos, V.trAcc, V.trHid, V.trFrame, V.trPh = nil, 0, false, 0, 0
V.trParts, V.trPartsT, V.trCh = {}, 0, nil
V.trailDestroy = function()
for _,p in ipairs(V.trPool) do pcall(function() p:Destroy() end) end
V.trPool,V.trFree,V.trAct,V.trLastPos,V.trParts,V.trPartsT,V.trCh={},{},{},nil,{},0,nil
end
V.trailKill=V.trailDestroy
V.trGet = function()
local p=table.remove(V.trFree)
if p and not p.Parent then p=nil end
if not p then
if #V.trPool>=260 then return nil end
p=V.new("Part",{Name="USMP_TR",Anchored=true,CanCollide=false,CanQuery=false,CanTouch=false,CastShadow=false,Massless=true,Transparency=1,Size=Vector3.new(.3,.3,.3),Material=Enum.Material.Neon},workspace.CurrentCamera)
V.trPool[#V.trPool+1]=p
end
return p
end
V.trCol = function(now)
local m=V.cfg.trc
local r=math.random()
if m==2 then return Color3.fromHSV((now*.35+r*.08)%1,.75,1)
elseif m==3 then return r<.4 and V.c3(255,225,90) or (r<.75 and V.c3(255,140,40) or V.c3(220,50,25))
elseif m==4 then return r<.4 and V.c3(240,252,255) or (r<.75 and V.c3(130,225,255) or V.c3(70,120,255)) end
local a=V.acc()
return r<.5 and a:Lerp(Color3.new(1,1,1),r*.7) or a:Lerp(Color3.new(0,0,0),(r-.5)*.8)
end
V.trSpawn = function(now,pos,vel,size,life,col,spin)
local p=V.trGet() if not p then return end
p.Color=col p.Material=V.cfg.trg and Enum.Material.Neon or Enum.Material.SmoothPlastic
V.trAct[#V.trAct+1]={p=p,t0=now,life=life,pos=pos,vel=vel,s=size,sp=spin,rot=CFrame.Angles(math.random()*6.28,math.random()*6.28,math.random()*6.28)}
end
V.trGhost = function(now,src,col,life)
local p=V.trGet() if not p then return end
p.Color=col p.Material=V.cfg.trg and Enum.Material.Neon or Enum.Material.ForceField
p.Size=src.Size*1.05
V.trAct[#V.trAct+1]={p=p,t0=now,life=life,cf=src.CFrame,gh=true}
end
V.trailStep = function(now,dt)
V.trFrame+=1
if not V.cfg.trail then if #V.trPool>0 then V.trailDestroy() end return end
local ch=V.lp.Character
local rootPart=ch and (ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart)
local cm=workspace.CurrentCamera
local hd=ch and ch:FindFirstChild("Head")
local fp=hd~=nil and ((cm.CFrame.Position-hd.Position).Magnitude<1.4 or hd.LocalTransparencyModifier>.9)
if ch~=V.trCh then V.trCh=ch V.trParts={} V.trPartsT=0 V.trLastPos=nil end
local prev=V.trLastPos
local rp=rootPart and rootPart.Position
V.trLastPos=rp
if rp and prev and not fp then
local mv=Vector3.new(rp.X-prev.X,0,rp.Z-prev.Z)
local spd=(rp-prev).Magnitude/math.max(dt,.001)
if spd>1.5 and spd<400 and mv.Magnitude>.001 then
local dir=mv.Unit
local feet,topY=V.bounds(ch,rootPart,now)
local H=math.max(topY-feet,2)
local sc,life,st=V.cfg.trw/100,V.cfg.trl,V.cfg.trs
local iv=st==1 and .035 or (st==2 and .09 or .025)
V.trAcc=math.min(V.trAcc+dt,iv*4)
while V.trAcc>=iv do
V.trAcc-=iv
if st==1 then
for _=1,2 do
local a=math.random()*6.2832 local rr=math.random()*.55*sc
local pos=Vector3.new(rp.X+math.cos(a)*rr,feet+math.random()*H*.95,rp.Z+math.sin(a)*rr)
local vel=Vector3.new((math.random()-.5)*.8,.4+math.random()*.8,(math.random()-.5)*.8)
V.trSpawn(now,pos,vel,(.16+math.random()*.2)*sc,life*(.8+math.random()*.4),V.trCol(now),(math.random()-.5)*4)
end
elseif st==2 then
if now-V.trPartsT>1.5 or #V.trParts==0 then
V.trPartsT=now V.trParts={}
for _,i in ipairs(ch:GetDescendants()) do
if #V.trParts<18 and i:IsA("BasePart") and i.Transparency<.9 and not i:FindFirstAncestorOfClass("Tool") and (i.Size.X>.35 or i.Size.Y>.35) then V.trParts[#V.trParts+1]=i end
end
end
local col=V.trCol(now)
for _,pt in ipairs(V.trParts) do if pt.Parent then V.trGhost(now,pt,col,life*.9) end end
else
V.trPh+=.55
local side=Vector3.new(-dir.Z,0,dir.X)
local R=.95*sc
local c0=V.trCol(now)
for s=0,1 do
local ph=V.trPh+s*3.1416
local off=side*(math.cos(ph)*R)+Vector3.new(0,math.sin(ph)*R*1.1,0)
V.trSpawn(now,Vector3.new(rp.X,feet+H*.5,rp.Z)+off,Vector3.new(),.22*sc,life,s==0 and c0 or Color3.new(1,1,1):Lerp(c0,.4),0)
end
end
end
end
end
if fp then
if not V.trHid then V.trHid=true for _,q in ipairs(V.trAct) do q.p.Transparency=1 end end
else V.trHid=false end
local act=V.trAct
local ps,cfs,n={},{},0
local upd=V.trFrame%2==0
for i=#act,1,-1 do
local q=act[i] local age=now-q.t0
if age>=q.life then
q.p.Transparency=1 V.trFree[#V.trFree+1]=q.p table.remove(act,i)
else
local k=age/q.life
n+=1 ps[n]=q.p
if q.gh then cfs[n]=q.cf else cfs[n]=CFrame.new(q.pos+q.vel*age)*q.rot*CFrame.Angles(0,q.sp*age,0) end
if not fp and (upd or age<.06) then
if q.gh then q.p.Transparency=.35+.65*k^1.1
else
q.p.Transparency=k<.45 and .05 or .05+.95*((k-.45)/.55)^1.3
local s=math.max(q.s*(1-k*.85),.03) q.p.Size=Vector3.new(s,s,s)
end
end
end
end
if n>0 then
local okm=pcall(function() workspace:BulkMoveTo(ps,cfs,Enum.BulkMoveMode.FireCFrameChanged) end)
if not okm then for j=1,n do ps[j].CFrame=cfs[j] end end
end
end

-- MARKERS (waypoints shared with friends through chat)
V.marks, V.lastSend, V.mkSeen = {}, 0, {}
V.ALPH = "abcdefghijklmnop"
V.encN = function(n) n=math.floor(n+.5) local s=string.format("%x",math.abs(n)):gsub(".",function(c) local v=tonumber(c,16) return V.ALPH:sub(v+1,v+1) end) return (n<0 and "r" or "")..s end
V.decN = function(s) local neg=s:sub(1,1)=="r" if neg then s=s:sub(2) end local n=0 for c in s:gmatch(".") do local i=V.ALPH:find(c,1,true) if not i then return nil end n=n*16+i-1 end return neg and -n or n end
V.colFor = function(name) local h=0 for i=1,#name do h=(h*31+name:byte(i))%360 end return Color3.fromHSV(h/360,.6,1) end
V.addMark = function(pos,owner,col)
local f=V.new("CanvasGroup",{BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Size=UDim2.new(0,90,0,50),Visible=false,GroupTransparency=1},V.gui)
local us=V.new("UIScale",{},f)
local dia=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,0,10),Size=UDim2.new(0,12,0,12),Rotation=45,BackgroundColor3=col,BorderSizePixel=0},f)
V.stroke(dia,V.BLK,2)
V.tx(f,{Position=UDim2.new(0,0,0,21),Size=UDim2.new(1,0,0,12),TextSize=10,Align=Enum.TextXAlignment.Center,Color=col})(owner)
local setM=V.tx(f,{Position=UDim2.new(0,0,0,33),Size=UDim2.new(1,0,0,13),TextSize=11,Align=Enum.TextXAlignment.Center})
V.marks[#V.marks+1]={f=f,us=us,pos=pos,col=col,t0=os.clock(),setM=setM}
end
V.markFrame = function(now)
if #V.marks==0 then return end
local cm=workspace.CurrentCamera local vp=cm.ViewportSize
local r=V.lp.Character and V.lp.Character:FindFirstChild("HumanoidRootPart")
for i=#V.marks,1,-1 do
local m=V.marks[i] local el,D=now-m.t0,V.cfg.mkdur
if el>=D then m.f:Destroy() table.remove(V.marks,i)
else
local a=math.clamp(math.min(el/.35,(D-el)/.6),0,1)
m.f.GroupTransparency=1-a m.us.Scale=.7+.3*a
local v=cm:WorldToViewportPoint(m.pos) local x,y=v.X,v.Y
if v.Z<0 then x,y=vp.X-x,vp.Y-y end
m.f.Position=UDim2.fromOffset(math.clamp(x,50,vp.X-50),math.clamp(y,40,vp.Y-40)) m.f.Visible=true
m.setM(string.format("%dm",math.floor((m.pos-(r and r.Position or cm.CFrame.Position)).Magnitude+.5)))
end
end
end
V.chatChannel = function()
local tc=V.TCS:FindFirstChild("TextChannels")
return tc and tc:FindFirstChild("RBXGeneral")
end
V.isTCS = function()
local okc,v=pcall(function() return V.TCS.ChatVersion==Enum.ChatVersion.TextChatService end)
return okc and v
end
V.sendRaw = function(pl,fl)
local pub=V.cfg.mkt==2
if V.isTCS() then
local ch=V.chatChannel() if not ch then return false end
if pub then pcall(function() ch:SendAsync(pl) end)
else for _,p in ipairs(fl) do pcall(function() ch:SendAsync("/w "..p.Name.." "..pl) end) end end
return true
end
local ev=game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
local say=ev and ev:FindFirstChild("SayMessageRequest")
if not say then return false end
if pub then pcall(function() say:FireServer(pl,"All") end)
else for _,p in ipairs(fl) do pcall(function() say:FireServer("/w "..p.Name.." "..pl,"All") end) end end
return true
end
V.send = function(pos)
if os.clock()-V.lastSend<1 then return end V.lastSend=os.clock()
local pl="usmpq"..V.encN(pos.X).."q"..V.encN(pos.Y).."q"..V.encN(pos.Z)
local fl={}
for _,p in ipairs(V.Players:GetPlayers()) do if p~=V.lp and V.cfg.fr[p.Name:lower()] then fl[#fl+1]=p end end
if #fl==0 then V.notify("No friends online (add them first)") return end
if V.sendRaw(pl,fl) then V.notify("Marker sent to "..#fl.." friend(s)") else V.notify("Chat unavailable: marker is local") end
end
V.recvMark = function(p,t)
if type(t)~="string" or t:sub(1,5)~="usmpq" or not V.cfg.sync then return end
if not p or p==V.lp or not V.cfg.fr[p.Name:lower()] then return end
local a,b,c=t:sub(6):match("^([a-pr]+)q([a-pr]+)q([a-pr]+)")
local x,y,z=V.decN(a or ""),V.decN(b or ""),V.decN(c or "")
if not (x and y and z) then return end
local key=p.Name..t local n=os.clock()
if V.mkSeen[key] and n-V.mkSeen[key]<2 then return end
V.mkSeen[key]=n
V.addMark(Vector3.new(x,y,z),p.Name,V.colFor(p.Name))
V.notify("Marker from "..p.Name)
end
V.placeMark = function()
if not V.cfg.mk then return end
local cm=workspace.CurrentCamera
local rp=RaycastParams.new() rp.FilterType=Enum.RaycastFilterType.Exclude rp.FilterDescendantsInstances={V.lp.Character}
local r=workspace:Raycast(cm.CFrame.Position,cm.CFrame.LookVector*1000,rp)
local pos=r and r.Position or cm.CFrame.Position+cm.CFrame.LookVector*300
V.addMark(pos,V.lp.Name,V.colFor(V.lp.Name))
if V.cfg.sync then V.send(pos) end
end
V.clearMarks = function() for i=#V.marks,1,-1 do V.marks[i].f:Destroy() table.remove(V.marks,i) end end
pcall(function()
V.prevHook=V.TCS.OnIncomingMessage
V.TCS.OnIncomingMessage=function(m)
if m.Text and m.Text:sub(1,5)=="usmpq" then local p=Instance.new("TextChatMessageProperties") p.Text="" p.PrefixText="" return p end
if V.prevHook then return V.prevHook(m) end
end
V.hooked=true
end)
pcall(function()
V.C(V.TCS.MessageReceived:Connect(function(m)
local src=m.TextSource if not src or src.UserId==V.lp.UserId then return end
V.recvMark(V.Players:GetPlayerByUserId(src.UserId),m.Text or "")
end))
end)
V.hookChatted = function(p)
if p==V.lp then return end
V.C(p.Chatted:Connect(function(msg) V.recvMark(p,msg) end))
end
for _,p in ipairs(V.Players:GetPlayers()) do V.hookChatted(p) end
V.C(V.Players.PlayerAdded:Connect(V.hookChatted))
V.syncText = function()
if V.isTCS() then return "Sync: chat ("..(V.cfg.mkt==2 and "public" or "whisper").."). Both players add each other as friends." end
return "Sync: legacy chat. Both players add each other as friends."
end

V.cmp = V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,8),Size=UDim2.new(0,320,0,34),BackgroundColor3=V.BLK,BackgroundTransparency=.5,BorderSizePixel=0},V.gui)
V.new("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.2,0),NumberSequenceKeypoint.new(.8,0),NumberSequenceKeypoint.new(1,1)})},V.cmp)
V.cmpEls = {}
V.cmpCard = {{"N",0},{"NE",45},{"E",90},{"SE",135},{"S",180},{"SW",225},{"W",270},{"NW",315}}
for _,c in ipairs(V.cmpCard) do
local main=#c[1]==1
local f=V.new("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,0),Size=UDim2.new(0,30,0,14),Position=UDim2.new(0,0,0,9)},V.cmp)
local setL=V.tx(f,{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),TextSize=main and 13 or 10,Align=Enum.TextXAlignment.Center,Color=main and Color3.new(1,1,1) or V.GRY})
setL(c[1]=="N" and '<font color="#FF5555">N</font>' or c[1])
V.cmpEls[#V.cmpEls+1]={f=f,b=c[2],y=9,x=-999}
end
for i=1,23 do
if i%3~=0 then
local f=V.new("Frame",{BackgroundColor3=V.GRY,BackgroundTransparency=.35,BorderSizePixel=0,AnchorPoint=Vector2.new(.5,0),Size=UDim2.new(0,1,0,5),Position=UDim2.new(0,0,0,3)},V.cmp)
V.cmpEls[#V.cmpEls+1]={f=f,b=i*15,y=3,x=-999}
end
end
V.cmpM = {}
for i=1,5 do
local f=V.new("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,0),Size=UDim2.new(0,44,0,26),Visible=false,Position=UDim2.new(0,0,0,5)},V.cmp)
local dia=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,0,5),Size=UDim2.new(0,8,0,8),Rotation=45,BorderSizePixel=0},f)
V.stroke(dia,V.BLK,1)
V.cmpM[i]={f=f,dia=dia,setD=V.tx(f,{Position=UDim2.new(0,0,0,12),Size=UDim2.new(1,0,0,11),TextSize=9,Align=Enum.TextXAlignment.Center}),x=-999}
end
V.cmpCaret = V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,1,-4),Size=UDim2.new(0,6,0,6),Rotation=45,BackgroundColor3=V.acc(),BorderSizePixel=0},V.cmp)
V.cmpTmp, V.lCmp, V.lCmw, V.lCmA = {}, nil, nil, nil
V.cmpFrame = function(now)
local on=V.cfg.cmp
if on~=V.lCmp then V.lCmp=on V.cmp.Visible=on end
if not on then return end
local cm=workspace.CurrentCamera
local look=cm.CFrame.LookVector
local th=math.deg(math.atan2(look.X,-look.Z))
local w=V.cfg.cmw
if w~=V.lCmw then V.lCmw=w V.cmp.Size=UDim2.new(0,w,0,34) end
local a=V.acc() if a~=V.lCmA then V.lCmA=a V.cmpCaret.BackgroundColor3=a end
local ppd,half=w/180,w/2
for _,e in ipairs(V.cmpEls) do
local d=((e.b-th+540)%360)-180
local xr=math.floor(half+d*ppd+.5)
if xr~=e.x then e.x=xr e.f.Position=UDim2.new(0,xr,0,e.y) end
end
local n=0
if V.cfg.cmk then
for _,m in ipairs(V.marks) do if n<4 then n+=1 V.cmpTmp[n]={m.pos,m.col or a} end end
if V.vis and V.cur and V.cur.Parent then
local r2=V.cur.RootPart or V.cur.Parent:FindFirstChild("HumanoidRootPart")
if r2 and n<5 then n+=1 V.cmpTmp[n]={r2.Position,a} end
end
end
local rr=V.lp.Character and V.lp.Character:FindFirstChild("HumanoidRootPart")
local o=rr and rr.Position or cm.CFrame.Position
for i=1,5 do
local s=V.cmpM[i]
if i<=n then
local t=V.cmpTmp[i]
local dx,dz=t[1].X-o.X,t[1].Z-o.Z
local d=((math.deg(math.atan2(dx,-dz))-th+540)%360)-180
local xr=math.floor(half+d*ppd+.5)
s.f.Visible=true
if xr~=s.x then s.x=xr s.f.Position=UDim2.new(0,xr,0,5) end
s.dia.BackgroundColor3=t[2]
s.setD(string.format("%dm",math.floor(math.sqrt(dx*dx+dz*dz)+.5)))
else s.f.Visible=false end
end
end

V.spl, V.spN, V.spI, V.lSp, V.fovBase, V.fovOn = {}, 18, 0, false, nil, false
for i=1,V.spN do
local f=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Visible=false,Size=UDim2.fromOffset(2,60)},V.gui)
V.spl[i]={f=f,a=(i/V.spN)*6.2832+math.random()*.2,ph=math.random(),len=50+math.random()*90,w=2+math.floor(math.random()*2)}
end
V.spdFrame = function(now,dt)
local cm=workspace.CurrentCamera
local rootPart=V.lp.Character and V.lp.Character:FindFirstChild("HumanoidRootPart")
local spd=(V.cfg.spd and rootPart) and rootPart.AssemblyLinearVelocity.Magnitude or 0
local th=V.cfg.spth
local tgt=math.clamp((spd-th)/(th*.8),0,1)
V.spI+=(tgt-V.spI)*math.min(1,dt*(tgt>V.spI and 6 or 3))
local I=V.spI
if V.cfg.spd and V.cfg.spfov then
if I<.01 then V.fovBase=cm.FieldOfView V.fovOn=false
elseif V.fovBase then cm.FieldOfView=V.fovBase+I*10 V.fovOn=true end
elseif V.fovOn and V.fovBase then cm.FieldOfView=V.fovBase V.fovOn=false end
if I<=.02 then
if V.lSp then V.lSp=false for _,l in ipairs(V.spl) do l.f.Visible=false end end
return
end
V.lSp=true
local vp=cm.ViewportSize local cx,cy=vp.X/2,vp.Y/2
local R=math.sqrt(cx*cx+cy*cy)
local maxA=V.cfg.spi/100
for _,l in ipairs(V.spl) do
l.ph=(l.ph+dt*(1.2+I*1.8))%1
local r=R*(.98-.62*l.ph)
l.f.Position=UDim2.fromOffset(V.r2(cx+math.cos(l.a)*r),V.r2(cy+math.sin(l.a)*r))
l.f.Size=UDim2.fromOffset(l.w,V.r2(l.len*(.6+I*.7)))
l.f.Rotation=math.deg(l.a)+90
l.f.BackgroundTransparency=1-maxA*I*math.sin(l.ph*3.1416)*.9
l.f.Visible=true
end
end

-- HIT DIRECTION: real arrow (stem + head) at the screen ring, points to the attacker
V.hdA = {}
for i=1,4 do
local f=V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,GroupTransparency=1,BorderSizePixel=0,Visible=false,Size=UDim2.fromOffset(36,36)},V.gui)
local us=V.new("UIScale",{},f)
local col=Color3.fromRGB(255,60,60)
V.new("Frame",{BackgroundColor3=col,BorderSizePixel=0,Position=UDim2.fromOffset(16,6),Size=UDim2.fromOffset(4,24)},f)
V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=col,BorderSizePixel=0,Position=UDim2.fromOffset(14,9),Size=UDim2.fromOffset(12,4),Rotation=-45},f)
V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BackgroundColor3=col,BorderSizePixel=0,Position=UDim2.fromOffset(22,9),Size=UDim2.fromOffset(12,4),Rotation=45},f)
V.hdA[i]={f=f,us=us,on=false,t0=0,tgt=nil,s=1}
end
V.vig = {}
for i,def in ipairs({{UDim2.new(1,0,0,110),UDim2.new(0,0,0,0),90},{UDim2.new(1,0,0,110),UDim2.new(0,0,1,-110),270},{UDim2.new(0,110,1,0),UDim2.new(0,0,0,0),0},{UDim2.new(0,110,1,0),UDim2.new(1,-110,0,0),180}}) do
local f=V.new("Frame",{BackgroundColor3=Color3.fromRGB(255,30,30),BorderSizePixel=0,Visible=false,Size=def[1],Position=def[2],BackgroundTransparency=1},V.gui)
V.new("UIGradient",{Rotation=def[3],Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})},f)
V.vig[i]=f
end
V.hdPrev, V.hdVig, V.hdMv, V.lVig, V.vigOn = nil, 0, nil, -1, false
V.hdFrame = function(now,dt)
local cm=workspace.CurrentCamera
local ms=V.cfg.hd and V.getMe() or nil
local low=0
if ms then
local hp,mx,ab=ms.read()
local r=(hp+ab)/mx
if V.hdMv~=ms.ver then V.hdMv=ms.ver V.hdPrev=nil end
if V.hdPrev and r<V.hdPrev-.003 then
local dmg=V.hdPrev-r
if V.cfg.hdv then V.hdVig=math.min(1,V.hdVig+.35+dmg*2) end
if V.cfg.hda then
local tgt
if V.cur and V.cur.Parent and now-V.seen<V.HOLD then tgt=V.cur.RootPart or V.cur.Parent:FindFirstChild("HumanoidRootPart") end
if not tgt and V.near[1] and V.near[1].h.Parent then local h=V.near[1].h tgt=h.RootPart or h.Parent:FindFirstChild("HumanoidRootPart") end
if tgt then
local slot,oldest
for _,a in ipairs(V.hdA) do
if not a.on then slot=a break end
if not oldest or a.t0<oldest.t0 then oldest=a end
end
slot=slot or oldest
slot.on=true slot.t0=now slot.tgt=tgt slot.s=math.clamp(.7+dmg*4,.7,1.6)
end
end
end
V.hdPrev=r
if V.cfg.hdl and r<.3 and r>0 then low=(.3-r)/.3*(.45+.4*math.sin(now*6)^2) end
end
V.hdVig=math.max(0,V.hdVig-dt*1.6)
local I=math.max(V.cfg.hdv and V.hdVig or 0,low,V.healI)
if math.abs(I-V.lVig)>.02 or (I==0 and V.lVig~=0) then
V.lVig=I
local vis=I>.01
if vis~=V.vigOn then V.vigOn=vis for _,f in ipairs(V.vig) do f.Visible=vis end end
if vis then for _,f in ipairs(V.vig) do f.BackgroundTransparency=1-I*.75 end end
end
local vp=cm.ViewportSize local cx,cy=vp.X/2,vp.Y/2
local R=V.cfg.hdr
for _,a in ipairs(V.hdA) do
if a.on then
local el=now-a.t0
if el>1.3 or not a.tgt.Parent then a.on=false a.f.Visible=false
else
local rel=a.tgt.Position-cm.CFrame.Position
local ang=math.atan2(rel:Dot(cm.CFrame.RightVector),rel:Dot(cm.CFrame.LookVector))
a.f.Position=UDim2.fromOffset(V.r2(cx+math.sin(ang)*R),V.r2(cy-math.cos(ang)*R))
a.f.Rotation=math.deg(ang)
a.us.Scale=a.s
a.f.GroupTransparency=math.clamp(el/1.3,0,1)^1.5
a.f.Visible=true
end
end
end

-- HEALER HELP: low HP + losing -> red screen + EAT GOLDEN APPLE
V.heal=V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,80),Size=UDim2.new(0,340,0,40),BackgroundTransparency=1,GroupTransparency=1,BorderSizePixel=0},V.gui)
V.tx(V.heal,{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,22),TextSize=20,Align=Enum.TextXAlignment.Center})('<font color="#FF5555">EAT GOLDEN APPLE!</font>')
V.setHeal2=V.tx(V.heal,{Position=UDim2.new(0,0,0,24),Size=UDim2.new(1,0,0,12),TextSize=10,Align=Enum.TextXAlignment.Center,Color=V.GRY})
V.healFrame=function(now,dt)
local ms=V.cfg.heal and V.getMe() or nil
local want=false
if ms then
local hp,mx,ab=ms.read()
local losing=V.cur~=nil and V.cur.Parent~=nil and now-V.seen<V.HOLD and not V.winS
want=ab<.5 and hp>0 and hp/mx<V.cfg.healhp/100 and (losing or not V.cfg.heall)
if want then V.setHeal2(string.format("HP %d/%d%s",math.ceil(hp),math.floor(mx+.5),losing and "  |  you are losing" or "")) end
end
local p=.5+.5*math.sin(now*7)
V.healI+=((want and (.4+.35*p) or 0)-V.healI)*math.min(1,dt*8)
V.heal.GroupTransparency=want and 1-(.7+.3*p) or 1
end

-- AUTO SPRINT
V.sprintStep=function()
local want=false
if V.cfg.asp and V.VIM then
local hm=V.meH or (V.lp.Character and V.lp.Character:FindFirstChildOfClass("Humanoid"))
want=hm~=nil and hm.Health>0 and hm.MoveDirection.Magnitude>.1 and not V.UIS:GetFocusedTextBox() and not V.menuOpen
end
local key=Enum.KeyCode[V.ASK[V.cfg.ask] or "LeftControl"]
if V.spOn and (not want or V.spKey~=key) then
pcall(function() V.VIM:SendKeyEvent(false,V.spKey,false,game) end) V.spOn=false
end
if want and not V.spOn then
V.spKey=key pcall(function() V.VIM:SendKeyEvent(true,key,false,game) end) V.spOn=true
end
end

-- NO FRIEND DAMAGE (blocks remotes that mention a friend)
V.frIn=function(v,d)
local t=typeof(v)
if t=="Instance" then
if v:IsA("Player") then return V.cfg.fr[v.Name:lower()]==true end
local m=v:IsA("Model") and v or v:FindFirstAncestorOfClass("Model")
while m do if V.isFr(m) then return true end m=m:FindFirstAncestorOfClass("Model") end
elseif t=="table" and d<3 then
for k,x in next,v do if V.frIn(k,d+1) or V.frIn(x,d+1) then return true end end
end
return false
end
_G.USMP_GEN=(_G.USMP_GEN or 0)+1 V.gen=_G.USMP_GEN
pcall(function()
if not (hookmetamethod and getnamecallmethod) then return end
local old
old=hookmetamethod(game,"__namecall",(newcclosure or function(f) return f end)(function(self,...)
if V.gen==_G.USMP_GEN and V.cfg.nofd and next(V.cfg.fr)~=nil then
local m=getnamecallmethod()
if (m=="FireServer" or m=="InvokeServer") and not (checkcaller and checkcaller()) and V.frIn({...},0) then return end
end
return old(self,...)
end))
end)

-- HUD STYLES: Target HUD (Classic = hearts, Modern = card, Aesthetic = glass pill)
-- NOTE: outlines live on an inner frame, so they fade together with the CanvasGroup (fixes the stray outline bug)
V.th2=V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,.6,0),Size=UDim2.new(0,236,0,58),BackgroundColor3=V.c3(18,18,24),BackgroundTransparency=.12,GroupTransparency=1,BorderSizePixel=0},V.gui)
V.new("UICorner",{CornerRadius=UDim.new(0,10)},V.th2)
local sf2=V.new("Frame",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,-2,1,-2)},V.th2)
V.new("UICorner",{CornerRadius=UDim.new(0,9)},sf2)
V.th2s=V.stroke(sf2,V.acc(),1,.5)
local a2=V.new("Frame",{BackgroundColor3=V.c3(40,40,50),BorderSizePixel=0,Position=UDim2.new(0,8,0,9),Size=UDim2.fromOffset(40,40)},V.th2)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},a2)
V.th2A=V.new("ImageLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Image=""},a2)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},V.th2A)
V.setN2=V.tx(V.th2,{Position=UDim2.new(0,56,0,6),Size=UDim2.new(0,100,0,16),TextSize=13,Font=Enum.Font.GothamBold})
V.setD2=V.tx(V.th2,{Position=UDim2.new(0,150,0,7),Size=UDim2.new(0,78,0,14),TextSize=11,Align=Enum.TextXAlignment.Right,Color=V.GRY,Font=Enum.Font.Gotham})
local b2=V.new("Frame",{BackgroundColor3=V.c3(44,44,56),BorderSizePixel=0,Position=UDim2.new(0,56,0,27),Size=UDim2.new(0,172,0,8)},V.th2)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},b2)
V.th2f=V.new("Frame",{BackgroundColor3=V.GRN,BorderSizePixel=0,Size=UDim2.new(1,0,1,0)},b2)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},V.th2f)
local g2=V.new("Frame",{BackgroundColor3=V.c3(60,48,0),BorderSizePixel=0,Position=UDim2.new(0,56,0,38),Size=UDim2.new(0,172,0,3)},V.th2)
V.th2g=V.new("Frame",{BackgroundColor3=V.GOLD,BorderSizePixel=0,Size=UDim2.new(0,0,1,0)},g2)
V.setT2=V.tx(V.th2,{Position=UDim2.new(0,56,0,42),Size=UDim2.new(0,172,0,12),TextSize=10,Color=V.GRY,Font=Enum.Font.Gotham})
V.drag(V.th2,V.th2)

V.th3=V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,.6,0),Size=UDim2.new(0,214,0,38),BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=.82,GroupTransparency=1,BorderSizePixel=0},V.gui)
V.new("UICorner",{CornerRadius=UDim.new(0,19)},V.th3)
local sf3=V.new("Frame",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,-2,1,-2)},V.th3)
V.new("UICorner",{CornerRadius=UDim.new(0,18)},sf3)
V.stroke(sf3,Color3.new(1,1,1),1,.55)
local a3=V.new("Frame",{BackgroundColor3=V.c3(60,60,70),BorderSizePixel=0,Position=UDim2.new(0,5,0,5),Size=UDim2.fromOffset(28,28)},V.th3)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},a3)
V.th3s=V.stroke(a3,V.acc(),2)
V.th3A=V.new("ImageLabel",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Image=""},a3)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},V.th3A)
V.setN3=V.tx(V.th3,{Position=UDim2.new(0,40,0,4),Size=UDim2.new(0,112,0,14),TextSize=12,Font=Enum.Font.GothamMedium,NS=true})
V.setT3=V.tx(V.th3,{Position=UDim2.new(0,150,0,5),Size=UDim2.new(0,56,0,14),TextSize=10,Align=Enum.TextXAlignment.Right,Font=Enum.Font.Gotham,NS=true})
local b3=V.new("Frame",{BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=.75,BorderSizePixel=0,Position=UDim2.new(0,40,0,25),Size=UDim2.new(0,164,0,5)},V.th3)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},b3)
V.th3f=V.new("Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Size=UDim2.new(1,0,1,0)},b3)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},V.th3f)
V.th3gr=V.new("UIGradient",{Color=ColorSequence.new(V.acc(),Color3.fromRGB(255,170,230))},V.th3f)
V.drag(V.th3,V.th3)
V.thF={V.hud,V.th2,V.th3}
V.thInfo=function(nm,img) V.thName=nm V.th2A.Image=img V.th3A.Image=img V.setN2(nm) V.setN3(nm) end
V.thUpd=function(hp,mx,ab,tick)
local s=V.cfg.ths
if s==1 then return end
local r=math.clamp(V.shown/mx,0,1)
if s==2 then
V.th2f.Size=UDim2.new(r,0,1,0) V.th2f.BackgroundColor3=Color3.fromHSV(.33*r,.75,1)
V.th2g.Size=UDim2.new(math.clamp(V.sab/mx,0,1),0,1,0)
if tick then
V.th2s.Color=V.acc()
V.setN2(V.thName or "") V.setD2(string.format("%.1f m",V.dist))
V.setT2(string.format("%d / %d",math.ceil(hp),math.floor(mx+.5))..(ab>.05 and ' <font color="#FFD83A">+'..math.ceil(ab)..'</font>' or ""))
end
else
V.th3f.Size=UDim2.new(r,0,1,0)
if tick then
local a=V.acc()
V.th3gr.Color=ColorSequence.new(a,a:Lerp(Color3.new(1,1,1),.55)) V.th3s.Color=a
V.setN3(string.format('%s  <font color="#B0B4C8">%dm</font>',V.thName or "",math.floor(V.dist+.5)))
V.setT3("hp "..math.ceil(hp)..(ab>.05 and ' <font color="#FFD83A">+'..math.ceil(ab)..'</font>' or ""))
end
end
end

-- WATERMARK styles
V.wm2=V.new("Frame",{Position=UDim2.new(0,8,0,8),Size=UDim2.new(0,0,0,26),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=V.c3(16,16,22),BackgroundTransparency=.15,BorderSizePixel=0,Visible=false},V.gui)
V.new("UICorner",{CornerRadius=UDim.new(0,6)},V.wm2)
V.new("UIPadding",{PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,10)},V.wm2)
V.wm2bar=V.new("Frame",{BackgroundColor3=V.acc(),BorderSizePixel=0,Position=UDim2.new(0,-14,0,0),Size=UDim2.new(0,3,1,0)},V.wm2)
V.wm2t=V.new("TextLabel",{BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,1,0),Font=Enum.Font.Code,TextSize=12,TextColor3=Color3.new(1,1,1),RichText=true,Text=""},V.wm2)
V.wm3=V.new("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,10),Size=UDim2.new(0,0,0,24),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=Color3.new(1,1,1),BackgroundTransparency=.85,BorderSizePixel=0,Visible=false},V.gui)
V.new("UICorner",{CornerRadius=UDim.new(0,12)},V.wm3)
V.new("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12)},V.wm3)
V.stroke(V.wm3,Color3.new(1,1,1),1,.55)
V.wm3t=V.new("TextLabel",{BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.new(0,0,1,0),Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=Color3.new(1,1,1),RichText=true,Text=""},V.wm3)
V.wmStyle=function()
local s=V.cfg.wms
V.wm2.Visible=V.cfg.wm and s==2 V.wm3.Visible=V.cfg.wm and s==3
if s==1 or not V.cfg.wm then return end
local a=V.hex(V.acc())
local r=V.lp.Character and V.lp.Character:FindFirstChild("HumanoidRootPart")
local P={}
if s==2 then
P[1]='<font color="'..a..'">UNSTABLE</font> SMP FFA'
if V.cfg.fps then P[#P+1]=math.floor(V.fps+.5)..' fps' P[#P+1]=math.floor(V.png+.5)..' ms' end
if V.cfg.xyz and r then local q=r.Position P[#P+1]=string.format("%d %d %d",q.X,q.Y,q.Z) end
V.wm2t.Text=table.concat(P,' <font color="#666A7A">|</font> ') V.wm2bar.BackgroundColor3=V.acc()
else
P[1]='<font color="'..a..'">unstable smp</font>'
if V.cfg.fps then P[#P+1]=math.floor(V.fps+.5)..' fps' P[#P+1]=math.floor(V.png+.5)..'ms' end
if V.cfg.xyz and r then local q=r.Position P[#P+1]=string.format("%d, %d, %d",q.X,q.Y,q.Z) end
V.wm3t.Text=table.concat(P,'   ·   ')
end
end

-- SESSION STATS + KILL STREAK + KILL EFFECT
V.kills,V.deaths,V.st0,V.killed,V.dead,V.stT=0,0,os.clock(),setmetatable({},{__mode="k"}),false,0
V.streak,V.bestStreak,V.ksT=0,0,0
V.lastTPos=nil V.lastKillT=0
V.ksNames={[2]="DOUBLE KILL",[3]="TRIPLE KILL",[4]="QUAD KILL",[5]="RAMPAGE",[6]="UNSTOPPABLE",[8]="GODLIKE",[10]="LEGENDARY"}
V.stF=V.new("Frame",{Position=UDim2.new(0,8,0,72),Size=UDim2.new(0,230,0,18),BackgroundColor3=V.BLK,BackgroundTransparency=.45,BorderSizePixel=0,Visible=false},V.gui)
V.setSt=V.tx(V.stF,{Position=UDim2.new(0,4,0,3),Size=UDim2.new(1,-8,0,12),TextSize=11})
V.drag(V.stF,V.stF)
V.ksB=V.new("CanvasGroup",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.28,0),Size=UDim2.new(0,320,0,52),BackgroundTransparency=1,GroupTransparency=1,BorderSizePixel=0},V.gui)
V.ksS=V.new("UIScale",{},V.ksB)
V.setKs1=V.tx(V.ksB,{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,30),TextSize=26,Align=Enum.TextXAlignment.Center})
V.setKs2=V.tx(V.ksB,{Position=UDim2.new(0,0,0,34),Size=UDim2.new(1,0,0,12),TextSize=11,Align=Enum.TextXAlignment.Center,Color=V.GRY})
V.ksShow=function(n)
if not V.cfg.ksb then return end
local nm=V.ksNames[n]
if not nm then for k=n,2,-1 do if V.ksNames[k] then nm=V.ksNames[k] break end end end
V.setKs1('<font color="'..V.hex(V.acc())..'">'..(nm or "KILL")..'</font>')
V.setKs2("STREAK x"..n.."  |  best x"..V.bestStreak)
V.ksT=os.clock()
V.ksB.GroupTransparency=0
V.ksS.Scale=1.5
V.TS:Create(V.ksS,TweenInfo.new(.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
if V.cfg.kss then
pcall(function() local s=Instance.new("Sound") s.SoundId="rbxasset://sounds/electronicpingshort.wav" s.Volume=.6 s.PlaybackSpeed=1+math.min(n,8)*.08 s.Parent=V.gui s:Play() task.delay(2,function() s:Destroy() end) end)
end
end
V.killFrame=function(now)
if not (V.cfg.stat or V.cfg.ks or V.cfg.kfx) then return end
local h=V.cur
if h then
if h.Health>0 and V.last>.01 then V.killed[h]=nil end
local rr=h.Parent and (h.RootPart or h.Parent:FindFirstChild("HumanoidRootPart"))
if rr then V.lastTPos=rr.Position end
if (h.Health<=0 or (h.Parent and V.last<=.01)) and now-V.lastDealt<5 and not V.killed[h] and now-V.lastKillT>1.5 then
V.killed[h]=true V.lastKillT=now V.kills+=1 V.streak+=1 V.bestStreak=math.max(V.bestStreak,V.streak)
if V.cfg.ks and V.streak>=2 then V.ksShow(V.streak) end
pcall(V.killFx,V.lastTPos)
end
end
local m=V.meH
if m then
if m.Health<=0 then if not V.dead then V.dead=true V.deaths+=1 V.streak=0 end else V.dead=false end
end
if V.ksT>0 and now-V.ksT>2.2 then V.ksT=0 V.TS:Create(V.ksB,TweenInfo.new(.4),{GroupTransparency=1}):Play() end
end
V.statFrame=function(now)
local on=V.cfg.stat
if on~=V.lStat then V.lStat=on V.stF.Visible=on end
if not on then return end
if now-V.stT>.5 then
V.stT=now
local kd=V.deaths==0 and V.kills or V.kills/V.deaths
local t=math.floor(now-V.st0)
V.setSt(string.format('K <font color="#55FF55">%d</font>  D <font color="#FF5555">%d</font>  KD %.1f  S <font color="#FFD83A">%d</font>  %02d:%02d',V.kills,V.deaths,kd,V.streak,math.floor(t/60),t%60))
end
end

-- PROXIMITY ALERT
V.alS,V.alT={},0
V.alertFrame=function(now,dt)
if not V.cfg.alrt then return end
V.alT+=dt if V.alT<.3 then return end V.alT=0
local mr=V.lp.Character and V.lp.Character:FindFirstChild("HumanoidRootPart") if not mr then return end
for _,p in ipairs(V.Players:GetPlayers()) do
if p~=V.lp and not V.cfg.fr[p.Name:lower()] then
local r=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
local d=r and (r.Position-mr.Position).Magnitude or 1e9
if d<=V.cfg.alr then
if not V.alS[p.Name] then
V.alS[p.Name]=true V.notify("! "..p.Name.." "..math.floor(d).."m")
pcall(function() local s=Instance.new("Sound") s.SoundId="rbxasset://sounds/electronicpingshort.wav" s.Volume=.6 s.Parent=V.gui s:Play() task.delay(2,function() s:Destroy() end) end)
end
elseif d>V.cfg.alr+8 then V.alS[p.Name]=nil end
end
end
end

-- ANTI-AFK
pcall(function() local VU=game:GetService("VirtualUser")
V.C(V.lp.Idled:Connect(function() if V.cfg.afk then VU:CaptureController() VU:ClickButton2(Vector2.new()) end end)) end)

-- CROSSHAIR
V.xh=V.new("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.fromOffset(60,60),Visible=false},V.gui)
V.xhB={}
for i=1,4 do V.xhB[i]=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0,Visible=false},V.xh) end
V.xhD=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0,Position=UDim2.new(.5,0,.5,0),Visible=false},V.xh)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},V.xhD)
V.xhR=V.new("Frame",{AnchorPoint=Vector2.new(.5,.5),BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(.5,0,.5,0),Visible=false},V.xh)
V.new("UICorner",{CornerRadius=UDim.new(1,0)},V.xhR)
V.xhRS=V.stroke(V.xhR,V.acc(),2)
V.xhFrame=function()
if not V.cfg.xh then if V.xh.Visible then V.xh.Visible=false V.xhSig=nil end return end
local col,s,sz=V.acc(),V.cfg.xhs,V.cfg.xhz/100
local sig=s..":"..V.cfg.xhz..":"..V.hex(col)
if sig==V.xhSig then return end
V.xhSig=sig V.xh.Visible=true
for _,b in ipairs(V.xhB) do b.Visible=false end
V.xhD.Visible=false V.xhR.Visible=false
V.xhD.BackgroundColor3=col V.xhRS.Color=col
if s==1 then
local len,gap=7*sz,4*sz
local o=gap+len/2
local def={{0,-o,2,len},{0,o,2,len},{-o,0,len,2},{o,0,len,2}}
for i,d in ipairs(def) do local b=V.xhB[i] b.Position=UDim2.new(.5,d[1],.5,d[2]) b.Size=UDim2.fromOffset(d[3],d[4]) b.BackgroundColor3=col b.Visible=true end
elseif s==2 then V.xhD.Size=UDim2.fromOffset(5*sz,5*sz) V.xhD.Visible=true
else
V.xhR.Size=UDim2.fromOffset(20*sz,20*sz) V.xhR.Visible=true
V.xhD.Size=UDim2.fromOffset(3,3) V.xhD.Visible=true
end
end

-- MAIN LOOP
V.t0, V.t3 = 0, 0
V.lrc1, V.lrc2, V.lgc = {},{},{}
V.lHud, V.lMbtn, V.lFbtn, V.lGold, V.lWf, V.lWb, V.lThS = nil, nil, nil, nil, nil, nil, nil
V.lih, V.lim, V.lia = nil, nil, nil
V.maybeBind = function(s,nc)
if s and not s.busy and ((s.stale and nc-s.t>10) or (not s.n.hp and nc-s.t>60)) then s.bind() end
end
V.C(V.RS.RenderStepped:Connect(function(dt)
V.t0+=dt V.t3+=dt
local tick=false
if V.t0>.1 then
V.t0=0 tick=true
local b,d=V.pick()
if b then V.seen=os.clock() V.dist=d if b~=V.cur then V.setTarget(b) end end
end
if V.t3>2 then
V.t3=0
local nc=os.clock()
V.maybeBind(V.S,nc) V.maybeBind(V.meS,nc)
for h,s in pairs(V.sc) do if not h.Parent then V.sc[h]=nil else V.maybeBind(s,nc) end end
end
local now=os.clock()
local live=V.cur~=nil and V.cur.Parent~=nil and now-V.seen<V.HOLD and V.last>0
local v=V.cfg.th and live
if v~=V.vis or V.cfg.ths~=V.lThS then
V.vis=v V.lThS=V.cfg.ths
for i,f in ipairs(V.thF) do V.TS:Create(f,TweenInfo.new(.2),{GroupTransparency=(v and i==V.cfg.ths) and 0 or 1}):Play() end
end
local wv=V.cfg.wl and live
if wv~=V.wvis then V.wvis=wv V.TS:Create(V.wl,TweenInfo.new(.25),{GroupTransparency=wv and 0 or 1}):Play() end
local bgt=V.BGS[V.cfg.bg] if bgt~=V.lHud then V.lHud=bgt V.hud.BackgroundTransparency=bgt end
if V.mbtn then local vv=V.cfg.mk and V.cfg.mkbtn if vv~=V.lMbtn then V.lMbtn=vv V.mbtn.Visible=vv end end
if V.fbtn and V.cfg.fbtn~=V.lFbtn then V.lFbtn=V.cfg.fbtn V.fbtn.Visible=V.lFbtn end
if V.cur and V.cur.Parent then
local hp,mx,ab=V.S.read()
if V.S.ver~=V.sver then V.sver=V.S.ver V.shown,V.ghost,V.sab,V.last,V.lastAb=hp,hp,ab,hp,ab V.pT=nil end
if hp<V.last-.01 then V.flash(Color3.fromRGB(255,60,60)) end
if ab>V.lastAb+.01 then V.flash(V.GOLD) end
V.last,V.lastAb=hp,ab
V.shown+=(hp-V.shown)*math.min(1,dt*14)
V.sab+=(ab-V.sab)*math.min(1,dt*10)
V.ghost=V.ghost>V.shown and math.max(V.shown,V.ghost-mx*dt*.4) or V.shown
for i=1,10 do
local a1=math.clamp(V.ghost/mx*10-(i-1),0,1)
if math.abs(a1-(V.lrc1[i] or -1))>.004 then V.lrc1[i]=a1 V.rc[i][1].Size=UDim2.new(a1,0,1,0) end
local a2=math.clamp(V.shown/mx*10-(i-1),0,1)
if math.abs(a2-(V.lrc2[i] or -1))>.004 then V.lrc2[i]=a2 V.rc[i][2].Size=UDim2.new(a2,0,1,0) end
local a3=math.clamp(V.sab/mx*10-(i-1),0,1)
if math.abs(a3-(V.lgc[i] or -1))>.004 then V.lgc[i]=a3 V.gc[i].Size=UDim2.new(a3,0,1,0) end
end
local gv=V.sab>.05 if gv~=V.lGold then V.lGold=gv V.goldRow.Visible=gv end
local ih,im,ia=math.ceil(hp),math.floor(mx+.5),math.ceil(ab)
if ih~=V.lih or im~=V.lim or ia~=V.lia then
V.lih,V.lim,V.lia=ih,im,ia
V.setH(ih.."/"..im..(V.sab>.05 and ' <font color="#FFD83A">+'..ia..'</font>' or ""))
end
if tick then V.setD(string.format("%.1f m",V.dist)) end
pcall(V.thUpd,hp,mx,ab,tick)
local tR=(hp+ab)/mx
if V.pT and tR<V.pT-.003 then
V.evD[#V.evD+1]={now,V.pT-tR} V.lastDealt=now
if (V.cfg.hf or V.cfg.mace or V.cfg.swd) and V.dist<=V.cfg.hfr then
local rpart=V.cur.RootPart or V.cur.Parent:FindFirstChild("HumanoidRootPart")
if rpart then
local _,topY=V.bounds(V.cur.Parent,rpart,now)
local rp=rpart.Position
V.hitEvent(now,(V.pT-tR)*mx,V.pT-tR,Vector3.new(rp.X,topY-.3,rp.Z))
end
end
end
V.pT=tR
local ms,mR=V.getMe(),1
if ms then
local a,b,c=ms.read() mR=(a+c)/b
if V.mver~=ms.ver then V.mver=ms.ver V.pM=nil end
if V.pM and mR<V.pM-.003 then V.evT[#V.evT+1]={now,V.pM-mR} end
V.pM=mR
end
local d5,t5=V.wsum(V.evD,now),V.wsum(V.evT,now)
local sc2=(mR-tR)+(d5-t5)*1.5
if V.dist<14 and now-V.lastDealt>2.5 then sc2-=math.min(.3,(now-V.lastDealt-2.5)*.08) end
V.ss+=(sc2-V.ss)*math.min(1,dt*6)
local th=V.SENS[V.cfg.sens]
if V.winS and V.ss<-th then V.winS=false elseif not V.winS and V.ss>th then V.winS=true end
if V.winS~=V.wsShown then
V.wsShown=V.winS
V.setW1(V.winS and '<font color="#55FF55">WIN</font>' or '<font color="#FF5555">LOSE</font>')
V.wsc.Scale=1.3 V.TS:Create(V.wsc,TweenInfo.new(.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
end
local wf=math.floor(math.clamp(.5+V.ss/1.2,.05,.95)*200+.5)/200
if wf~=V.lWf then V.lWf=wf V.wfill.Size=UDim2.new(wf,0,1,0) end
if V.cfg.wb~=V.lWb then V.lWb=V.cfg.wb V.wbar.Visible=V.lWb end
if tick then V.setW2(V.cfg.wd and string.format("HP %d%% vs %d%%  |  dealt %d  taken %d",math.floor(mR*100),math.floor(tR*100),math.floor(d5*20+.5),math.floor(t5*20+.5)) or "") end
end
V.espFrame(now) V.markFrame(now) V.popFrame(now) V.comboFrame(now) V.trailStep(now,dt)
V.cmpFrame(now) V.spdFrame(now,dt) V.hdFrame(now,dt)
local P=pcall
P(V.healFrame,now,dt) P(V.killFrame,now) P(V.statFrame,now) P(V.alertFrame,now,dt) P(V.xhFrame) P(V.sprintStep) P(V.rainFrame,now,dt)
end))
V.dw = V.new("Frame",{Visible=false,AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,1,-8),Size=UDim2.new(.92,0,0,150),BackgroundColor3=V.BLK,BackgroundTransparency=.2,BorderSizePixel=0,ZIndex=30},V.gui)
V.dsf = V.new("ScrollingFrame",{BackgroundTransparency=1,Size=UDim2.new(1,-26,1,0),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=4,BorderSizePixel=0},V.dw)
V.dtx = V.new("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(1,-6,0,0),AutomaticSize=Enum.AutomaticSize.Y,Font=Enum.Font.Code,TextSize=11,TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,Text=""},V.dsf)
V.dx = V.new("TextButton",{Text="X",Font=V.FONT,TextSize=12,TextColor3=Color3.new(1,1,1),BackgroundColor3=Color3.fromRGB(170,40,40),BorderSizePixel=0,Position=UDim2.new(1,-24,0,2),Size=UDim2.new(0,22,0,20)},V.dw)
V.dx.Activated:Connect(function() V.dw.Visible=false end)
V.scan = function()
local h=V.cur or V.pick()
if not h then V.dtx.Text="No target nearby. Stand next to a player/NPC and run Scan again." V.dw.Visible=true return end
local Ls,ch,pl={},h.Parent,V.Players:GetPlayerFromCharacter(h.Parent)
Ls[1]="TARGET "..ch.Name.." Humanoid HP="..h.Health.."/"..h.MaxHealth
local function dump(i)
local nm=i.Parent and (i.Parent.Name.."."..i.Name) or i.Name
for k,v in pairs(i:GetAttributes()) do Ls[#Ls+1]="@ "..nm.." "..k.."="..tostring(v) end
if i:IsA("ValueBase") then Ls[#Ls+1]="V "..nm.."="..tostring(i.Value) end
if i:IsA("TextLabel") and i.Text~="" then Ls[#Ls+1]="T "..nm.."='"..i.Text.."'" end
end
dump(ch) dump(h)
for _,i in ipairs(ch:GetDescendants()) do if #Ls<120 then dump(i) end end
if pl then Ls[#Ls+1]="PLAYER "..pl.Name dump(pl) for _,i in ipairs(pl:GetDescendants()) do if #Ls<160 then dump(i) end end end
local out=table.concat(Ls,"\n")
local copied=pcall(function() setclipboard(out) end)
V.dtx.Text=(copied and "[copied to clipboard]\n" or "")..out
V.dw.Visible=true print(out)
end

V.ACT = {
menu=function() V.setMenu(not V.menuOpen) end,
mark=V.placeMark,
clear=V.clearMarks,
scan=V.scan,
faim=V.toggleAimFriend,
fcur=V.addCurFriend,
fnear=V.addNearFriend,
apnext=function()
V.cfg.apr=V.cfg.apr%#V.APS+1 V.cfg.atm=true V.save()
V.notify("Atmosphere: "..V.APS[V.cfg.apr].n)
if V.menuOpen then V.render() end
end,
hfreset=function() V.combo=0 V.comboBest=0 V.cbLast=-1 V.notify("Combo reset") end,
trnext=function() V.cfg.trc=V.cfg.trc%#V.TCN+1 V.save() V.notify("Trail: "..V.TCN[V.cfg.trc]) if V.menuOpen then V.render() end end,
stres=function() V.kills,V.deaths,V.st0=0,0,os.clock() V.notify("Stats reset") end,
ksres=function() V.streak,V.bestStreak=0,0 V.notify("Streak reset") end,
}

V.TABS = {{"Visuals","eye"},{"Combat","sword"},{"ESP","aim"},{"Marks","pin"},{"Friends","user"},{"World","sun"},{"HUD","hud"},{"Extra","star"}}
V.M = {
{tab=1,name="Trail",en="trail",desc="Floating pixels, ghost echoes or a helix behind you. Hidden in first person.",set={{t="cyc",k="trs",l="Style",o=V.TSN},{t="cyc",k="trc",l="Color",o=V.TCN},{t="sld",k="trl",l="Length",min=.3,max=2,step=.1,fmt="%.1fs"},{t="sld",k="trw",l="Size",min=50,max=200,step=10,fmt="%d%%"},{t="tog",k="trg",l="Glow"},{t="act",id="trnext",l="Next color"}}},
{tab=1,name="Compass",en="cmp",desc="Heading strip at the top with waypoints and your target.",set={{t="sld",k="cmw",l="Width",min=200,max=460,step=20,fmt="%dpx"},{t="tog",k="cmk",l="Show markers"}}},
{tab=1,name="Speed Lines",en="spd",desc="Streaks on the screen edges when you move fast (elytra, wind charge).",set={{t="sld",k="spth",l="Min speed",min=20,max=120,step=5,fmt="%d"},{t="sld",k="spi",l="Intensity",min=20,max=100,step=10,fmt="%d%%"},{t="tog",k="spfov",l="FOV kick"}}},
{tab=2,name="Win / Lose",en="wl",desc="Shows whether you are winning the current fight.",set={{t="cyc",k="sens",l="Sensitivity",o=V.SENN},{t="tog",k="wd",l="Details line"},{t="tog",k="wb",l="Advantage bar"}}},
{tab=2,name="Hit Feedback",en="hf",desc="Floating damage numbers, combo counter, hit sparks and a hit marker when you hit your target.",set={{t="tog",k="hfn",l="Damage numbers"},{t="tog",k="hfc",l="Combo counter"},{t="tog",k="hfx",l="Hit sparks"},{t="tog",k="hfm",l="Hit marker"},{t="cyc",k="hfcol",l="Number color",o=V.HCN},{t="sld",k="hfr",l="Hit range",min=4,max=30,step=2,fmt="%dm"},{t="sld",k="hfto",l="Combo time",min=1,max=5,step=.5,fmt="%.1fs"},{t="act",id="hfreset",l="Reset combo"}}},
{tab=2,name="Mace Hit",en="mace",desc="Ground slam when you hit with a mace (item name has 'mace') or land a big hit: shockwaves, energy pillar, dust, embers, shake.",set={{t="tog",k="msw",l="Shockwave ring"},{t="tog",k="msh",l="Camera shake"},{t="sld",k="mthr",l="Big hit (0=off)",min=0,max=60,step=5,fmt="%d%%"}}},
{tab=2,name="Sword Hit",en="swd",desc="Crossing neon slash lines and sparks on the enemy when you hit with a sword (item name has 'sword').",set={{t="tog",k="swc",l="Cross slash"}}},
{tab=2,name="Kill Effect",en="kfx",desc="Screen flash and particle burst when you kill a player.",set={{t="tog",k="kfxf",l="Screen flash"},{t="tog",k="kfxp",l="Particles"}}},
{tab=2,name="Hit Direction",en="hd",desc="Red arrow shows where damage comes from, plus a screen flash.",set={{t="tog",k="hda",l="Direction arrow"},{t="tog",k="hdv",l="Screen flash"},{t="tog",k="hdl",l="Low HP warning"},{t="sld",k="hdr",l="Arrow radius",min=80,max=220,step=10,fmt="%dpx"}}},
{tab=2,name="Auto Sprint",en="asp",desc="Holds the sprint key for you while you move. Pick the key you use for sprint in the game.",set={{t="cyc",k="ask",l="Sprint key",o=V.ASK}}},
{tab=2,name="Healer Help",en="heal",desc="Low HP and losing: red screen and EAT GOLDEN APPLE warning.",set={{t="sld",k="healhp",l="HP below",min=15,max=70,step=5,fmt="%d%%"},{t="tog",k="heall",l="Only when losing"}}},
{tab=2,name="No Friend Damage",en="nofd",desc="Blocks attack requests aimed at friends.",set={}},
{tab=2,name="Targeting",desc="Who counts as your target.",set={{t="sld",k="range",l="Range",min=20,max=100,step=5},{t="tog",k="skipf",l="Skip friends"},{t="act",id="scan",l="Scan target (HP)"}}},
{tab=3,name="Target ESP",en="esp",desc="Marker on your target: diamond, ghosts, circle, ring or 8 crystals orbiting near each body part.",set={{t="cyc",k="estyle",l="Style",o=V.ESTN},{t="cyc",k="escope",l="Scope",o=V.SCPN},{t="cyc",k="ecol",l="Color",o=V.ECN},{t="sld",k="esize",l="Size",min=50,max=200,step=10,fmt="%d%%"},{t="sld",k="esd",l="Distance",min=50,max=300,step=10,fmt="%d%%"},{t="sld",k="espd",l="Speed",min=5,max=30,step=5}}},
{tab=4,name="Waypoints",en="mk",desc="Mark a spot. Friends with the script see it too.",set={{t="sld",k="mkdur",l="Duration",min=3,max=8,step=.5,fmt="%.1fs"},{t="tog",k="mkbtn",l="MARK button"},{t="tog",k="sync",l="Share"},{t="cyc",k="mkt",l="Transport",o={"Whisper","Public chat"}},{t="act",id="mark",l="Place marker now"},{t="act",id="clear",l="Clear all markers"},{t="lbl",f=V.syncText}}},
{tab=5,name="Friends",desc="Friends get your markers, are skipped as targets and cannot be hit.",custom=true,set={{t="tog",k="fbtn",l="FRND button"},{t="act",id="faim",l="Add/remove player in crosshair"},{t="act",id="fcur",l="Add current target"},{t="act",id="fnear",l="Add nearest player"}}},
{tab=6,name="Atmosphere",en="atm",desc="Changes sky, light, fog and adds floating particles (dust). Only you see it.",set={{t="cyc",k="apr",l="Preset",o=V.APN},{t="sld",k="aint",l="Intensity",min=20,max=100,step=10,fmt="%d%%"},{t="sld",k="ascl",l="Scale",min=50,max=200,step=10,fmt="%d%%"},{t="sld",k="aq",l="Quality",min=20,max=100,step=10,fmt="%d%%"},{t="tog",k="apart",l="Particles"},{t="tog",k="asky",l="Replace sky"},{t="tog",k="arays",l="Sun rays"},{t="act",id="apnext",l="Next preset"}}},
{tab=6,name="Rain",en="rain",desc="Rain streaks on your screen and ripples on water around you. Only you see it.",set={{t="sld",k="rni",l="Intensity",min=20,max=100,step=10,fmt="%d%%"},{t="tog",k="rnr",l="Water ripples"}}},
{tab=7,name="Target HUD",en="th",desc="Classic: hearts. Modern: card with bar. Aesthetic: glass pill.",set={{t="cyc",k="ths",l="Style",o=V.HSN},{t="cyc",k="bg",l="Classic bg",o=V.BGN}}},
{tab=7,name="Watermark",en="wm",desc="Classic: F3 lines. Modern: bar with stripe. Aesthetic: glass pill.",set={{t="cyc",k="wms",l="Style",o=V.HSN},{t="tog",k="fps",l="FPS / Ping"},{t="tog",k="xyz",l="Coordinates"}}},
{tab=7,name="GUI",desc="Menu shape, theme and accent color of the whole HUD.",set={{t="cyc",k="gus",l="Style",o=V.HSN},{t="cyc",k="gt",l="Theme",o=V.GTN},{t="cyc",k="ci",l="Accent",o=V.COLN},{t="act",id="menu",l="Open / close menu"}}},
{tab=8,name="Session Stats",en="stat",desc="Kills, deaths, K/D, streak and session time.",set={{t="act",id="stres",l="Reset stats"}}},
{tab=8,name="Kill Streak",en="ks",desc="Banner with DOUBLE KILL, TRIPLE KILL and more when you kill players in a row. Resets when you die.",set={{t="tog",k="ksb",l="Banner"},{t="tog",k="kss",l="Sound"},{t="act",id="ksres",l="Reset streak"}}},
{tab=8,name="Proximity Alert",en="alrt",desc="Notification and ping when a non-friend gets close.",set={{t="sld",k="alr",l="Distance",min=10,max=80,step=5,fmt="%dm"}}},
{tab=8,name="Anti-AFK",en="afk",desc="Prevents the idle kick.",set={}},
{tab=8,name="Crosshair",en="xh",desc="Custom crosshair in your accent color.",set={{t="cyc",k="xhs",l="Style",o={"Cross","Dot","Circle"}},{t="sld",k="xhz",l="Size",min=50,max=200,step=10,fmt="%d%%"}}},
}
V.tab, V.sel, V.query, V.dragS = 1, nil, "", nil
V.boxFocused = false
V.mroot = V.new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Visible=false,ZIndex=10},V.gui)
V.ov = V.tr(V.new("TextButton",{Text="",AutoButtonColor=false,BackgroundColor3=V.BLK,BorderSizePixel=0,Size=UDim2.new(1,0,1,0),ZIndex=1},V.mroot),"BackgroundTransparency","ov")
V.win = V.new("Frame",{Active=true,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.new(.5,0,.5,0),Size=UDim2.new(.86,0,.88,0),BorderSizePixel=0,ZIndex=1},V.mroot)
V.tr(V.win,"BackgroundColor3","win") V.tr(V.win,"BackgroundTransparency","wt")
V.new("UISizeConstraint",{MinSize=Vector2.new(460,270),MaxSize=Vector2.new(780,450)},V.win)
V.tr(V.stroke(V.win,Color3.new(),1),"Color","line")
V.msc = V.new("UIScale",{},V.win)
V.guiR=function() return ({0,8,16})[V.cfg.gus] or 0 end
V.winC=V.new("UICorner",{CornerRadius=UDim.new(0,V.guiR())},V.win)
V.setTitle = V.tx(V.win,{Position=UDim2.new(0,14,0,12),Size=UDim2.new(0,130,0,18),TextSize=15})
V.sbox = V.tr(V.new("Frame",{BorderSizePixel=0,Position=UDim2.new(0,150,0,7),Size=UDim2.new(1,-196,0,26)},V.win),"BackgroundColor3","panel")
V.tr(V.stroke(V.sbox,Color3.new(),1),"Color","line")
V.search = V.new("TextBox",{BackgroundTransparency=1,Position=UDim2.new(0,8,0,0),Size=UDim2.new(1,-16,1,0),Font=V.FONT,TextSize=12,TextColor3=Color3.new(1,1,1),PlaceholderText="Search modules...",PlaceholderColor3=Color3.fromRGB(185,188,210),Text="",ClearTextOnFocus=false,TextXAlignment=Enum.TextXAlignment.Left},V.sbox)
V.cl = V.tr(V.new("TextButton",{AutoButtonColor=false,Text="",BorderSizePixel=0,Position=UDim2.new(1,-34,0,7),Size=UDim2.new(0,26,0,26)},V.win),"BackgroundColor3","panel")
V.tr(V.stroke(V.cl,Color3.new(),1),"Color","line") V.tx(V.cl,{Position=UDim2.new(0,0,.5,-6),Size=UDim2.new(1,0,0,12),TextSize=12,Align=Enum.TextXAlignment.Center,Color=Color3.fromRGB(255,110,110)})("X")
V.tr(V.new("Frame",{BorderSizePixel=0,Position=UDim2.new(0,0,0,40),Size=UDim2.new(1,0,0,1)},V.win),"BackgroundColor3","sep")
V.tr(V.new("Frame",{BorderSizePixel=0,Position=UDim2.new(0,0,1,-48),Size=UDim2.new(1,0,0,1)},V.win),"BackgroundColor3","sep")
V.body = V.new("CanvasGroup",{BackgroundTransparency=1,Position=UDim2.new(0,0,0,41),Size=UDim2.new(1,0,1,-89),BorderSizePixel=0},V.win)
V.list = V.new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,10,0,8),Size=UDim2.new(.42,0,1,-16),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3},V.body)
V.new("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},V.list)
V.detF = V.tr(V.new("Frame",{BorderSizePixel=0,Position=UDim2.new(.42,20,0,8),Size=UDim2.new(.58,-30,1,-16)},V.body),"BackgroundColor3","det")
V.detC=V.new("UICorner",{CornerRadius=UDim.new(0,V.guiR())},V.detF)
V.tr(V.stroke(V.detF,Color3.new(),1),"Color","sep")
V.det = V.new("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,8,0,8),Size=UDim2.new(1,-16,1,-16),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3},V.detF)
V.new("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},V.det)
V.bar = V.new("Frame",{BackgroundTransparency=1,Position=UDim2.new(0,0,1,-47),Size=UDim2.new(1,0,0,46)},V.win)
V.new("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},V.bar)
V.tabs = {}
V.IDLE = Color3.fromRGB(205,208,228)
V.paintTabs = function()
for i,t in ipairs(V.tabs) do
local on=V.query=="" and V.tab==i
for _,c in ipairs(t.cells) do c.BackgroundColor3=on and V.acc() or V.IDLE end
t.ul.Visible=on t.ul.BackgroundColor3=V.acc() t.lab(on and t.n or "")
end
end
V.anim = function()
V.body.Position=UDim2.new(0,18,0,41) V.body.GroupTransparency=1
V.TS:Create(V.body,TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.new(0,0,0,41),GroupTransparency=0}):Play()
end
V.switchTab = function(i) V.tab=i V.sel=nil if V.search.Text~="" then V.search.Text="" else V.render() end V.anim() end
for i,t in ipairs(V.TABS) do
local b=V.new("TextButton",{AutoButtonColor=false,Text="",BackgroundTransparency=1,Size=UDim2.new(0,50,0,42),LayoutOrder=i},V.bar)
local f,cells=V.icon(b,V.IC[t[2]],3,V.IDLE) f.Position=UDim2.new(.5,-10,0,5)
local lab=V.tx(b,{Position=UDim2.new(0,0,0,29),Size=UDim2.new(1,0,0,11),TextSize=9,Align=Enum.TextXAlignment.Center})
local ul=V.new("Frame",{BackgroundColor3=V.acc(),BorderSizePixel=0,Position=UDim2.new(.5,-14,1,-2),Size=UDim2.new(0,28,0,2),Visible=false},b)
V.tabs[i]={cells=cells,lab=lab,ul=ul,n=t[1]}
b.MouseEnter:Connect(function() lab(t[1]) end)
b.MouseLeave:Connect(function() lab((V.query=="" and V.tab==i) and t[1] or "") end)
b.Activated:Connect(function() V.switchTab(i) end)
end
V.toggle = function(par,k,pos)
local on=V.cfg[k]
local b=V.new("TextButton",{AutoButtonColor=false,Text="",BackgroundColor3=on and V.acc() or V.T().off,BorderSizePixel=0,Position=pos,Size=UDim2.new(0,36,0,18)},par)
V.stroke(b,V.T().line,1)
V.new("Frame",{BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,Position=UDim2.new(0,on and 20 or 2,0,2),Size=UDim2.new(0,14,0,14)},b)
b.Activated:Connect(function() V.cfg[k]=not V.cfg[k] V.save() V.updWM() V.render() end)
end
V.ctlBtn = function(par,w,pos,text,col,fn)
local b=V.new("TextButton",{AutoButtonColor=false,Text="",BackgroundColor3=V.T().panel,BorderSizePixel=0,Position=pos,Size=UDim2.new(0,w,0,22)},par)
V.stroke(b,V.T().line,1)
V.new("UICorner",{CornerRadius=UDim.new(0,math.max(V.guiR()-4,0))},b)
V.tx(b,{Position=UDim2.new(0,0,.5,-6),Size=UDim2.new(1,0,0,12),TextSize=11,Align=Enum.TextXAlignment.Center,Color=col})(text)
b.Activated:Connect(fn) return b
end
V.buildDet = function(m)
local n=0
local function row(h) n+=1 return V.new("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,h),LayoutOrder=n},V.det) end
local function label(r,t,w) V.tx(r,{Position=UDim2.new(0,0,.5,-6),Size=UDim2.new(1,-w,0,12),TextSize=11})(t) end
local function sep() n+=1 V.new("Frame",{BackgroundColor3=V.T().sep,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),LayoutOrder=n},V.det) end
local function bindRow(id)
local r=row(28) label(r,"Bind",110)
local k=V.getKey(id) or "None"
local txt=V.capId==id and "press key..." or "["..k.."]"
V.ctlBtn(r,104,UDim2.new(1,-104,.5,-11),txt,V.acc(),function() V.capId=id V.capSet=function(v) V.cfg.kb[id]=v end V.render() end)
end
local function act(t,fn,id)
local r=row(26) V.ctlBtn(r,0,UDim2.new(0,0,0,2),t,V.acc(),fn).Size=UDim2.new(1,0,0,22)
if id then bindRow(id) end
end
local function secLabel(t) V.tx(row(18),{Position=UDim2.new(0,0,0,2),Size=UDim2.new(1,0,0,14),TextSize=11,Color=V.acc()})(t) end
V.tx(row(20),{Position=UDim2.new(0,0,0,2),Size=UDim2.new(1,0,0,16),TextSize=14,Color=V.acc()})(m.name)
V.tx(row(28),{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,28),TextSize=10,Color=V.GRY,Wrap=true})(m.desc or "")
if m.en then
local r=row(28) label(r,"Enabled",50) V.toggle(r,m.en,UDim2.new(1,-36,.5,-9))
bindRow("t_"..m.en)
end
sep()
for _,s in ipairs(m.set or {}) do
if s.t=="act" then act(s.l,function() V.ACT[s.id]() end,s.id)
elseif s.t=="lbl" then V.tx(row(32),{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,32),TextSize=10,Color=V.GRY,Wrap=true})(s.f())
else
local r=row(28)
if s.t=="tog" then label(r,s.l,50) V.toggle(r,s.k,UDim2.new(1,-36,.5,-9))
elseif s.t=="cyc" then
label(r,s.l,126)
V.ctlBtn(r,120,UDim2.new(1,-120,.5,-11),"< "..tostring(s.o[V.cfg[s.k]] or s.o[1]).." >",V.acc(),function() V.cfg[s.k]=(V.cfg[s.k] or 1)%#s.o+1 V.save() V.updWM() V.render() end)
elseif s.t=="sld" then
label(r,s.l,190)
local tk=V.new("TextButton",{Text="",AutoButtonColor=false,BackgroundColor3=V.T().off,BorderSizePixel=0,Position=UDim2.new(1,-176,.5,-4),Size=UDim2.new(0,116,0,8)},r)
local fill=V.new("Frame",{BackgroundColor3=V.acc(),BorderSizePixel=0,Size=UDim2.new(0,0,1,0)},tk)
local sv=V.tx(r,{Position=UDim2.new(1,-54,.5,-6),Size=UDim2.new(0,54,0,12),TextSize=11,Align=Enum.TextXAlignment.Right})
local function show() fill.Size=UDim2.new((V.cfg[s.k]-s.min)/(s.max-s.min),0,1,0) sv(string.format(s.fmt or "%d",V.cfg[s.k])) end
local function setx(x)
local a=math.clamp((x-tk.AbsolutePosition.X)/math.max(tk.AbsoluteSize.X,1),0,1)
V.cfg[s.k]=s.min+math.floor(a*(s.max-s.min)/s.step+.5)*s.step show()
end
show()
tk.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then V.dragS=setx setx(i.Position.X) end end)
end
end
end
if m.custom then
sep()
local r=row(28)
local fb=V.new("Frame",{BackgroundColor3=V.T().panel,BorderSizePixel=0,Size=UDim2.new(1,-62,0,24),Position=UDim2.new(0,0,0,2)},r) V.stroke(fb,V.T().line,1)
local box=V.new("TextBox",{BackgroundTransparency=1,Position=UDim2.new(0,8,0,0),Size=UDim2.new(1,-16,1,0),Font=V.FONT,TextSize=11,TextColor3=Color3.new(1,1,1),PlaceholderText="Nickname...",PlaceholderColor3=Color3.fromRGB(185,188,210),Text="",ClearTextOnFocus=false,TextXAlignment=Enum.TextXAlignment.Left},fb)
box.Focused:Connect(function() V.boxFocused=true end)
box.FocusLost:Connect(function(en) V.boxFocused=false if en then V.addFr(box.Text) end end)
V.ctlBtn(r,56,UDim2.new(1,-56,0,3),"Add",V.GRN,function() V.addFr(box.Text) end)
secLabel("Online players")
local online={}
for _,p in ipairs(V.Players:GetPlayers()) do if p~=V.lp then online[#online+1]=p end end
table.sort(online,function(a,b) return a.Name:lower()<b.Name:lower() end)
local onSet={}
if #online==0 then V.tx(row(18),{Position=UDim2.new(0,0,0,2),Size=UDim2.new(1,0,0,14),TextSize=10,Color=V.GRY})("Nobody else on the server.") end
for _,p in ipairs(online) do
onSet[p.Name:lower()]=true
local isF=V.cfg.fr[p.Name:lower()]==true
local r2b=row(26)
V.new("Frame",{BackgroundColor3=isF and V.GRN or Color3.fromRGB(150,154,180),BorderSizePixel=0,Position=UDim2.new(0,0,.5,-4),Size=UDim2.new(0,8,0,8)},r2b)
V.tx(r2b,{Position=UDim2.new(0,16,.5,-6),Size=UDim2.new(1,-90,0,12),TextSize=11,Color=isF and V.GRN or Color3.new(1,1,1)})(p.Name)
V.ctlBtn(r2b,60,UDim2.new(1,-60,.5,-11),isF and "Remove" or "Add",isF and Color3.fromRGB(255,120,120) or V.GRN,function()
V.setFriend(p.Name,not isF) V.notify((isF and "Friend removed: " or "Friend added: ")..p.Name)
end)
end
local off={} for k in pairs(V.cfg.fr) do if not onSet[k] then off[#off+1]=k end end table.sort(off)
if #off>0 then secLabel("Saved (offline)") end
for _,k in ipairs(off) do
local r2b=row(26)
V.new("Frame",{BackgroundColor3=Color3.fromRGB(150,154,180),BorderSizePixel=0,Position=UDim2.new(0,0,.5,-4),Size=UDim2.new(0,8,0,8)},r2b)
V.tx(r2b,{Position=UDim2.new(0,16,.5,-6),Size=UDim2.new(1,-50,0,12),TextSize=11,Color=V.GRY})(k)
V.ctlBtn(r2b,24,UDim2.new(1,-24,.5,-11),"X",Color3.fromRGB(255,120,120),function() V.setFriend(k,false) V.notify("Friend removed: "..k) end)
end
V.tx(row(34),{Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,0,34),TextSize=10,Color=V.GRY,Wrap=true})("Both players need this script and each other in the list.")
end
end
V.render = function()
V.applyTheme()
V.winC.CornerRadius=UDim.new(0,V.guiR()) V.detC.CornerRadius=UDim.new(0,math.max(V.guiR()-4,0))
if V.cfg.gus==3 then V.win.BackgroundTransparency=math.max(V.win.BackgroundTransparency,.2) end
for _,c in ipairs(V.list:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
for _,c in ipairs(V.det:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
local ms,q={},V.query:lower()
for _,m in ipairs(V.M) do if (q~="" and m.name:lower():find(q,1,true)) or (q=="" and m.tab==V.tab) then ms[#ms+1]=m end end
if not table.find(ms,V.sel) then V.sel=ms[1] end
for i,m in ipairs(ms) do
local r=V.new("TextButton",{AutoButtonColor=false,Text="",BackgroundColor3=m==V.sel and V.T().sel or V.T().panel,BorderSizePixel=0,Size=UDim2.new(1,-6,0,30),LayoutOrder=i},V.list)
V.stroke(r,m==V.sel and V.acc() or V.T().line,1)
V.new("UICorner",{CornerRadius=UDim.new(0,math.max(V.guiR()-4,0))},r)
V.tx(r,{Position=UDim2.new(0,12,.5,-6),Size=UDim2.new(1,-64,0,12),TextSize=12})(m.name)
if m.en then V.toggle(r,m.en,UDim2.new(1,-44,.5,-9)) end
r.Activated:Connect(function() V.sel=m V.render() end)
end
if V.sel then V.buildDet(V.sel) end
V.setTitle('<font color="'..V.hex(V.acc())..'">Unstable</font> HUD')
V.paintTabs()
end
V.C(V.search:GetPropertyChangedSignal("Text"):Connect(function() V.query=V.search.Text V.sel=nil V.render() end))
V.C(V.UIS.InputChanged:Connect(function(i) if V.dragS and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then V.dragS(i.Position.X) end end))
V.C(V.UIS.InputEnded:Connect(function(i) if V.dragS and (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch) then V.dragS=nil V.save() end end))
V.refreshFr = function() if V.menuOpen and V.tab==5 and V.query=="" and not V.boxFocused then task.defer(V.render) end end
V.C(V.Players.PlayerAdded:Connect(V.refreshFr))
V.C(V.Players.PlayerRemoving:Connect(V.refreshFr))
V.setMenu=function(o)
if o then V.menuOpen=true V.mroot.Visible=true V.msc.Scale=.92 V.TS:Create(V.msc,TweenInfo.new(.15,Enum.EasingStyle.Quad),{Scale=1}):Play() V.render() else V.menuOpen=false V.mroot.Visible=false V.capId=nil V.capSet=nil end
end
V.cl.Activated:Connect(function() V.setMenu(false) end)
V.ov.Activated:Connect(function() V.setMenu(false) end)
V.slotBtn = function(t,y,fn)
local b=V.tr(V.new("TextButton",{AutoButtonColor=false,Text="",BackgroundTransparency=.1,BorderSizePixel=0,Position=UDim2.new(1,-58,.5,y),Size=UDim2.new(0,46,0,28)},V.gui),"BackgroundColor3","panel")
V.tr(V.stroke(b,Color3.new(),1),"Color","line") V.tx(b,{Position=UDim2.new(0,0,.5,-6),Size=UDim2.new(1,0,0,12),TextSize=11,Align=Enum.TextXAlignment.Center})(t)
b.Activated:Connect(fn) return b
end
V.slotBtn("HUD",-14,function() V.setMenu(not V.menuOpen) end)
V.mbtn=V.slotBtn("MARK",20,function() V.placeMark() end)
V.fbtn=V.slotBtn("FRND",54,function() V.toggleAimFriend() end)
V.applyTheme()

V.C(V.UIS.InputBegan:Connect(function(i,gp)
    if V.capId then
        if i.UserInputType==Enum.UserInputType.Keyboard then
            local set=V.capSet 
            V.capId,V.capSet=nil,nil
            if i.KeyCode==Enum.KeyCode.Escape then
            elseif i.KeyCode==Enum.KeyCode.Backspace or i.KeyCode==Enum.KeyCode.Delete then 
                if set then set("None") end 
                V.save()
            else 
                if set then set(i.KeyCode.Name) end 
                V.save() 
            end
            V.render()
        end
        return
    end
    
    if gp or i.UserInputType~=Enum.UserInputType.Keyboard then return end
    local k=i.KeyCode.Name
    
    for id,fn in pairs(V.ACT) do
        if V.getKey(id)==k then pcall(fn) end
    end
    
    for _,m in ipairs(V.M) do
        if m.en and V.getKey("t_"..m.en)==k then
            V.cfg[m.en] = not V.cfg[m.en]
            V.save() 
            V.updWM()
            V.notify(m.name..": "..(V.cfg[m.en] and "ON" or "OFF"))
            if V.menuOpen then V.render() end
        end
    end
end))