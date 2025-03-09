#include "logging.h"
#include <iostream>

auto HL::Logger::error(std::string_view message) -> void
{
    const std::string red_color = "\033[31m";
    const std::string reset_color = "\033[0m";
    std::cerr << red_color << "[ERROR]: " << reset_color << message << std::endl;
}

auto HL::Logger::warning(std::string_view message) -> void
{
    const std::string gold_color = "\033[38;5;226m";
    const std::string reset_color = "\033[0m";
    std::cerr << gold_color << "[WARNING]: " << reset_color << message << std::endl;
}

auto HL::Logger::info(std::string_view message) -> void
{
    const std::string blue_color = "\033[1;36m";
    const std::string reset_color = "\033[0m";
    std::cerr << blue_color << "[INFO]: " << reset_color << message << std::endl;
}
