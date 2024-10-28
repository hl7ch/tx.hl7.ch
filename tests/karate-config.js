function fn() {
    var config = {}; // Define a config object
    
    // Read YAML file and set it as a global variable
    var yamlData = karate.read('./_config.yaml');
    config.globalData = yamlData;
  
    // Alternatively, assign individual properties directly
    config.tx_url = yamlData.tx_url;
    config.timeout = yamlData.timeout;
  

    return config;
  }
  