#ifndef LOGGING_H
#define LOGGING_H

#include <string>

namespace HL
{
    namespace Logger
    {
        auto error(std::string message) -> void;
        auto warning(std::string message) -> void;
        auto info(std::string message) -> void;
    } // namespace Logger
} // namespace HL

#endif
