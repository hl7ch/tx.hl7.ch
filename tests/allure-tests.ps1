
java -jar karate-1.5.0.jar -o target/allure-result testcases/ 

del target/allure-results/*.json
node convert-karate-to-allure.js


allure/bin/allure.bat generate target/allure-results -o target/allure-report --clean
allure/bin/allure.bat serve target/allure-results