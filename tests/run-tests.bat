
java -jar karate-1.5.0.jar testcases/ 

REM After tests are completed, open the Karate summary report in the default browser
start "" "%CD%\target\karate-reports\karate-summary.html"