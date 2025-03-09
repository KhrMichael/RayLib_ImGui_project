#ifndef LOGGING_H
#define LOGGING_H

#include <string_view>

namespace HL
{
    namespace Logger
    {
        auto error(std::string_view message) -> void;
        auto warning(std::string_view message) -> void;
        auto info(std::string_view message) -> void;
    } // namespace Logger
} // namespace HL

#endif
