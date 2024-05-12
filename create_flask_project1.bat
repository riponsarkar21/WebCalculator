@echo off
setlocal

REM Open file dialog to select project location
set "vbscript=%temp%\filedialog.vbs"
echo Set objDialog = CreateObject("Shell.Application")>"%vbscript%"
echo Set objFolder = objDialog.BrowseForFolder(0, "Select the folder to create Flask project", 0, "")>>"%vbscript%"
echo Wscript.Echo objFolder.Self.Path>>"%vbscript%"
for /f "delims=" %%I in ('cscript //nologo "%vbscript%"') do set "project_location=%%I"
del "%vbscript%"

REM Check if user canceled folder selection
if not defined project_location (
    echo No folder selected. Exiting...
    exit /b
)

REM Create project folder
set "project_name=MyFlaskProject"
set /p "project_name=Enter project name (default: %project_name%): "
set "project_folder=%project_location%\%project_name%"
mkdir "%project_folder%"

REM Create virtual environment
cd /d "%project_folder%"
python -m venv venv
if errorlevel 1 (
    echo Error creating virtual environment. Exiting...
    exit /b
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install Flask and upgrade
pip install flask
pip install --upgrade flask

REM Create folders for templates and static
mkdir "%project_folder%\templates"
mkdir "%project_folder%\static"

REM Create basic files
echo ^<html^>^<head^>^<title^>My Flask App^</title^>^</head^>^<body^>^<h1^>Hello, Flask!^</h1^>^</body^>^</html^> > "%project_folder%\templates\index.html"
echo /* Your CSS styles */ > "%project_folder%\static\styles.css"
echo // Your JavaScript code > "%project_folder%\static\script.js"

REM Create app.py file
echo from flask import Flask, render_template, request > "%project_folder%\app.py"
echo. >> "%project_folder%\app.py"
echo app = Flask(__name__) >> "%project_folder%\app.py"
echo. >> "%project_folder%\app.py"
echo @app.route('/') >> "%project_folder%\app.py"
echo def index(): >> "%project_folder%\app.py"
echo     return render_template('index.html') >> "%project_folder%\app.py"
echo. >> "%project_folder%\app.py"
echo @app.route('/calculate', methods=['POST']) >> "%project_folder%\app.py"
echo def calculate(): >> "%project_folder%\app.py"
echo     num1 = float(request.form['num1']) >> "%project_folder%\app.py"
echo     num2 = float(request.form['num2']) >> "%project_folder%\app.py"
echo     operation = request.form['operation'] >> "%project_folder%\app.py"
echo. >> "%project_folder%\app.py"
echo     if operation == 'add': >> "%project_folder%\app.py"
echo         result = num1 + num2 >> "%project_folder%\app.py"
echo     elif operation == 'subtract': >> "%project_folder%\app.py"
echo         result = num1 - num2 >> "%project_folder%\app.py"
echo     elif operation == 'multiply': >> "%project_folder%\app.py"
echo         result = num1 * num2 >> "%project_folder%\app.py"
echo     elif operation == 'divide': >> "%project_folder%\app.py"
echo         if num2 == 0: >> "%project_folder%\app.py"
echo             return "Error! Cannot divide by zero." >> "%project_folder%\app.py"
echo         result = num1 / num2 >> "%project_folder%\app.py"
echo     else: >> "%project_folder%\app.py"
echo         return "Invalid operation" >> "%project_folder%\app.py"
echo. >> "%project_folder%\app.py"
echo     return render_template('result.html', result=result) >> "%project_folder%\app.py"
echo. >> "%project_folder%\app.py"
echo if __name__ == '__main__': >> "%project_folder%\app.py"
echo     app.static_folder = 'static' >> "%project_folder%\app.py"
echo. >> "%project_folder%\app.py"
echo     app.run(debug=True) >> "%project_folder%\app.py"


echo Project "%project_name%" created successfully at "%project_folder%"
pause
