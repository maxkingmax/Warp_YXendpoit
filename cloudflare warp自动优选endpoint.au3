#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ ======================================================
;~ 程序名称:AutoIt v3.3.16.1 (Beta)
;~ 整合:风行者
;~ 中文论坛: http://www.AutoItX.com
;~ ======================================================
FileInstall("warp.exe",@ScriptDir&"\warp.exe",0)
;~ ipv4==========
;~ 162.159.192.0/24
;~ 162.159.193.0/24
;~ 162.159.195.0/24
;~ 188.114.96.0/24
;~ 188.114.97.0/24
;~ 188.114.98.0/24
;~ 188.114.99.0/24
Dim $ipfront[7] = ["162.159.192.","162.159.193.","162.159.195.","188.114.96.","188.114.97.","188.114.98.","188.114.99."]
;~ ipv6============
;~ 2606:4700:d0::/48
;~ 2606:4700:d1::/48
;~ ProcessClose("wireguard.exe")
Func ipv6($num=128)
	$list=''
	For $i =1 To $num
	$ipd=Random(0,1,1)
	If $ipd =1 Then
		$front='[2606:4700:d0::'
	Else
		$front='[2606:4700:d1::'
	EndIf
$ipd1=Random(0,65535,1)
$ipd2=Random(0,65535,1)
$ipd3=Random(0,65535,1)
$ipd4=Random(0,65535,1)

$str=$front&StringFormat('%04x:%04x:%04x:%04x]', $ipd1,$ipd2,$ipd3,$ipd4)&@CRLF
;~ ConsoleWrite(@CRLF&$ip51)
;~ ConsoleWrite(@crlf&$str)
$list&=$str

Next
Return $list
EndFunc



Func ipv4($num=128)
	$list=''
For $i=0 To 6
	For $a=1 To Int($num/7)
	$iph=Random(1,254,1)
	$str=$ipfront[$i]&$iph&@CRLF
;~ 	ConsoleWrite($str&@CRLF)
	$list&=$str
	
	Next
Next
Return $list
EndFunc


Func writef($con)
	$sfile=FileOpen("ip.txt",1+8)
	FileWrite($sfile,$con)
	FileClose($sfile)
	
EndFunc



;~ $ip=ipv6()
;~ writef($ip)
;~ $ip=ipv4()
;~ writef($ip)
Func main()
RunWait('warp.exe')
If FileExists('result.csv') Then
	$sfile=FileOpen('result.csv')
	$tempip=FileReadLine($sfile,2)
	$goodip=StringTrimRight($tempip,StringLen($tempip)-StringInStr($tempip,",")+1) 
	ConsoleWrite($goodip)
	ClipPut($goodip)
	FileClose($sfile)
	FileDelete("ip.txt")
	
EndIf

runwait("warp-cli disconnect")
runwait("warp-cli clear-custom-endpoint")
runwait("warp-cli set-custom-endpoint "& $goodip)
runwait("warp-cli connect")
EndFunc
;~ Run("C:\Program Files\WireGuard\wireguard.exe")
;~ $hjb=WinWaitActive("WireGuard","")
;~ ControlClick($hjb,"","button7")


Func pinggoogle()
$p1=Ping("google.com")
$p2=Ping("youtube.com")
If $p1=0 And $p2=0 Then
;~ 	ConsoleWrite("ERROR")
	iptxt()
	main()
	EndIf
EndFunc
Func iptxt()
If $cmdline[0]>=1 Then
Switch $cmdline[1]
	Case 4
		$ip=ipv4()
		writef($ip)
	Case 6
		$ip=ipv6()
		writef($ip)
	Case 10
		$ip=ipv4(64)
		writef($ip)
		$ip=ipv6(64)
		writef($ip)
EndSwitch

Else
	$ip=ipv4()
	writef($ip)
EndIf
EndFunc

AdlibRegister("pinggoogle",60*1000)
iptxt()
pinggoogle()
While 1
Sleep(1000)
;~ ConsoleWrite("1")
WEnd

