#ifndef SCRAPER_H
#define SCRAPER_H

#include <string>
#include "json.hpp"

// Function to fetch weather data from an external API
nlohmann::json fetchWeatherData(const std::string& city);

#endif // SCRAPER_H
