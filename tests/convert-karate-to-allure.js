const fs = require('fs');
const path = require('path');

// Directory where the Karate JSON files are located
const karateReportsDir = 'target/allure-result/karate-reports';
const allureResultsDir = 'target/allure-results';

// Ensure the allure-results directory exists
if (!fs.existsSync(allureResultsDir)) {
    fs.mkdirSync(allureResultsDir, { recursive: true });
}

// Function to convert Karate JSON files
function convertKarateToAllure() {
    console.log('Reading files from:', karateReportsDir);
    fs.readdirSync(karateReportsDir).forEach(file => {
        console.log('Processing file:', file);
        if (file.endsWith('.karate-json.txt')) {
            try {
                const filePath = path.join(karateReportsDir, file);
                console.log('Reading file:', filePath);
                const karateData = JSON.parse(fs.readFileSync(filePath, 'utf8'));

                // Extract scenarios from the karate JSON
                const scenarios = karateData.scenarioResults || [];

                // Transform each scenario into an Allure-compatible format
                scenarios.forEach((scenario, index) => {
                    console.log('Processing scenario:', scenario.name);
                    const allureData = {
                        name: scenario.name || 'Unnamed Scenario',
                        status: scenario.failed ? "failed" : "passed",
                        start: scenario.startTime || new Date().getTime(),
                        stop: scenario.endTime || new Date().getTime(),
                        steps: scenario.stepResults.map((step) => ({
                            name: step.step.text,
                            status: step.result.status === 'failed' ? 'failed' : 'passed',
                            start: step.result.startTime,
                            stop: step.result.endTime,
                            stage: "finished",
                            attachments: [],
                            parameters: [],
                            steps: []
                        })),
                        description: scenario.description || '',
                        labels: [
                            { name: 'feature', value: karateData.name },
                            { name: 'suite', value: karateData.name }
                        ],
                        links: [],
                        descriptionHtml: scenario.error ? `<pre>${scenario.error}</pre>` : '',
                    };

                    // Write each scenario as a separate Allure file
                    const allureFilePath = path.resolve(allureResultsDir, `${path.basename(file, '.karate-json.txt')}_scenario${index + 1}-result.json`);
                    try {
                        fs.writeFileSync(allureFilePath, JSON.stringify(allureData, null, 2));
                        console.log('Successfully wrote file:', allureFilePath);
                    } catch (writeError) {
                        console.error('Error writing file:', allureFilePath, writeError);
                    }
                });
            } catch (err) {
                console.error('Error processing file:', file, err);
            }
        }
    });
    console.log('Conversion completed.');
}

convertKarateToAllure();
