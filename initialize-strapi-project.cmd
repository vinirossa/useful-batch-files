@echo off

echo Initializing...

echo === WARNING ===
echo Requirements to proceed: Node.js, npm, yarn and PostgreSQL
echo === WARNING ===


echo ===========================================================================
echo ======================= PostgreSQL and Strapi Setup =======================
echo ===========================================================================

REM Question about PostgreSQL new environment setup
:choice
set /P c=Do you need to set a new PostgreSQL database and user [Y/N]?
if /I "%c%" EQU "Y" goto :preparepostgres
if /I "%c%" EQU "N" goto :createstrapiapp
goto :choice


:preparepostgres
REM Prepare your PostgreSQL for Strapi
set /p database="Enter your new database name: "
set /p username="Enter your new user name: "
set /p userPassword="Enter your new user password: "

echo This your root password to access PostgreSQL...
(
  echo create database %database%;
  echo \l ;
  echo create user %username%;
  echo alter user %username% with encrypted password '%userPassword%';
  echo grant all privileges on database %database% to %username%;
  echo \du;
) | psql -h localhost -U postgres -d postgres


:createstrapiapp
REM Create your Strapi app
echo === CORRECT ANSWERS FOR THE STRAPI WIZARD ===
echo Custom (manual settings) / no / postgres / and then the database information
echo === CORRECT ANSWERS FOR THE STRAPI WIZARD ===

set /p strapiProjectName="Enter your strapi project name: "
call yarn create strapi-app %strapiProjectName%

REM Move Strapi app's new folder content to the parent directory
set projectDir=.\%strapiProjectName%
robocopy %projectDir% "." /e /move /eta


echo =========================================================================
echo ========================== Project Dependencies =========================
echo =========================================================================

echo          Configuring ESLint, Prettier, husky and lint-staged...


REM Install TypeScript
call yarn add --dev typescript @types/node


REM Install ESLint (already installed by Strapi)
REM echo === CORRECT ANSWERS FOR THE ESLINT WIZARD ===
REM echo To check syntax and find problems / CommonJS (require/exports) /
REM echo None of these / y / Node / JSON / No
REM echo === CORRECT ANSWERS FOR THE ESLINT WIZARD ===
REM pause

REM call npx eslint --init


REM Install ESLint dependencies
call yarn add --dev  @typescript-eslint/eslint-plugin@latest @typescript-eslint/parser@latest eslint@latest babel-eslint

REM Install Prettier and its ESLint plugins
call yarn add --dev prettier eslint-plugin-prettier eslint-config-prettier

REM Add the necessary missings lines to .eslintrc.json
if exist .eslintrc (
    if not exist .eslintrc.json (
        ren .eslintrc .eslintrc.json
    )
)
call npx json-merger -p merge-eslintrc.json -o .eslintrc.json


REM Install husky and lint-staged
call git init .
call yarn add --dev husky
call yarn husky install
call yarn husky add .husky/pre-commit "npx --no-install lint-staged"
call yarn add --dev lint-staged

REM Add lint-staged necessary configuration to package.json
call npx json-merger -p merge-package.json -o package.json


echo ==========================================================================
echo ============================= Strapi Plugins =============================
echo ==========================================================================

echo           Installing CKEditor5 and GraphQL plugins for Strapi...

REM Install CKEditor5 plugin for Strapi 
call yarn add strapi-plugin-ckeditor5 || (
  echo === STRAPI PLUGIN ERROR ===
  echo Error while executing 'yarn add strapi-plugin-ckeditor5'
  echo === STRAPI PLUGIN ERROR ===
  echo Proceeding with the configuration...
)

REM Install GraphQL plugin for Strapi 
call yarn add strapi-plugin-graphql || (
  echo === STRAPI PLUGIN ERROR ===
  echo Error while executing 'yarn add strapi-plugin-graphql'
  echo === STRAPI PLUGIN ERROR ===
  echo Proceeding with the configuration...
)


REM Rebuild your Strapi app
call yarn build --clean || (
  echo === STRAPI BUILD ERROR ===
  echo Error while executing 'yarn build --clean'
  echo === STRAPI BUILD ERROR ===
  echo Reinstalling node_modules... This may take a few minutes according to your internet.

  call rm -rf node_modules
  call yarn
)


REM Delete the already used json-merger files
del merge-package.json
del merge-eslintrc.json

echo ===========================================================================
echo ================================== Done! ==================================
echo ===========================================================================
echo               Your strapi repository is ready. Happy coding!
pause

REM Auto delete this batch file
del %0
