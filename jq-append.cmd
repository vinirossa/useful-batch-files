@echo off

setlocal EnableDelayedExpansion
set LF=^


REM The two empty lines are required here
set "jqOutput1="
for /F "delims=" %%f in ('jq --arg new "prettier/recommended" ".extends += [$new]" .eslintrc.json') do (
    if defined jqOutput1 set "jqOutput1=!jqOutput1!!LF!"
    set "jqOutput1=!jqOutput1!%%f"
)
echo !jqOutput1! > .eslintrc.json

setlocal EnableDelayedExpansion
set LF=^


REM The two empty lines are required here
set jsonString = "{'prettier/prettier': 'error'}"
set "jqOutput2="
for /F "delims=" %%f in ('jq --argjson jsonString %jsonString% ".rules += {$jsonString}" .eslintrc.json') do (
    if defined jqOutput2 set "jqOutput2=!jqOutput2!!LF!"
    set "jqOutput2=!jqOutput2!%%f"
)
echo !jqOutput2! > .eslintrc.json

@REM set retornoJson=call jq --arg new "prettier/recommended" ".extends += [$new]" .eslintrc.json
@REM echo %retornoJson%

@REM for /F "delims=" %%L in ('jq --arg new "prettier/recommended" ".extends += [$new]" .eslintrc.json') do set "target=!target! %%i"
@REM echo !target!



@REM set keyValuePair='{"prettier/pdrettier": "error"}'
@REM call jq --arg new %keyValuePair% ".rules += [$new]" .eslintrc.json > teste.json

@REM set keyValuePair='{"@typescript-eslint/explicit-module-boundary-types": "off"}'
@REM call jq --arg new %keyValuePair% ".rules += [$new]" .eslintrc.json > teste.json

echo Finalizado...
pause
