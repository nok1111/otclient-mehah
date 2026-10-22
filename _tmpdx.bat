@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >NUL
msbuild vc17\otclient.sln /p:Configuration=DirectX /p:Platform=x64 /m /v:m /nologo
