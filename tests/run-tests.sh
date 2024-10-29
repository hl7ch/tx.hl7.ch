#!/bin/bash
docker-compose up -d # Start server in background
karate test tests/ # Run tests in the tests folder