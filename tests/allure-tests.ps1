
java -jar karate-1.5.0.jar -o target/allure-result testcases/ 

del target/allure-results/*.json
copy executor.json target/allure-results

# for %f in (*.json) do if /i not "%~nxf"=="executor.json" del "%f"

node convert-karate-to-allure.js


allure/bin/allure.bat generate target/allure-results -o target/allure-report --clean
allure/bin/allure.bat serve target/allure-results