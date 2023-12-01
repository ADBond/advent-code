#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <ctype.h>

int main() {
    // std::ifstream input_file("2023/input/01_test.input.txt");
    std::ifstream input_file("2023/input/01.input.txt");
    if (!input_file.is_open()) {
        return 1;
    }

    std::string line;
    int total = 0;
    while (std::getline(input_file, line)) {

        bool foundone = false;
        int line_total = 0;
        // attack from the front
        for (int idx = 0; idx < line.length() && !foundone; ++idx) {
            char line_char = line[idx];
            if (isdigit(line_char)) {
                // ascii -> int
                int digit_value = line_char - '0';
                line_total += 10*digit_value;
                foundone = true;
                std::cout << "Found digit: " << line_char << " with value " << digit_value << std::endl; 
            }
        }
        // sorry DRY :(
        // and the rear
        foundone = false;
        for (int idx = line.length(); idx >= 0 && !foundone; --idx) {
            char line_char = line[idx];

            if (isdigit(line_char)) {
                // ascii -> int
                int digit_value = line_char - '0';
                line_total += digit_value;
                foundone = true;
                std::cout << "Found digit: " << line_char << " with value " << digit_value << std::endl; 
            }
        }
        std::cout << "Line total: " << line_total << std::endl;
        total += line_total;
    }
    std::cout << "Total digit sum is: " << total << std::endl;

    input_file.close();

    return 0;
}
