#include <fstream>
#include <iostream>
#include <map>

int get_digit_from(const std::string& line, const bool& forwards=true) {
	bool foundone = false;
	int line_total = 0;
	const int line_length = line.length();
	int digit_value = -1;

	// just do a simple full string map - not worth the effort to go trees
	const std::map<std::string, int> numbers_as_words{
		{"one", 1},
		{"two", 2},
		{"three", 3},
		{"four", 4},
		{"five", 5},
		{"six", 6},
		{"seven", 7},
		{"eight", 8},
		{"nine", 9},
	};
	std::vector<std::string> number_strings;
	for (const auto& [key, value] : numbers_as_words){
		number_strings.push_back(key);
	}

	for (int idx = 0; idx < line_length && !foundone; ++idx) {
		char line_char = line[idx];
		if (isdigit(line_char)) {
			digit_value = line_char - '0';
			foundone = true;
		} else {
			for (const auto& [number_string, value] : numbers_as_words) {
				const int str_length = number_string.length();
				const int idx_end = idx +  - 1;
				if (idx_end < line_length) {
					const std::string candidate_string = line.substr(idx, str_length);
					if (candidate_string == number_string) {
						digit_value = value;
						foundone = true;
						break;
					}
				}
			}
		}
		if (foundone) {
			std::cout << "Found front value " << digit_value << std::endl;
		}
	}
	return digit_value;
}

int main() {

	std::ifstream input_file("2023/input/01_2_test.input.txt");
	// std::ifstream input_file("2023/input/01_2.input.txt");
	if (!input_file.is_open()) {
		return 1;
	}
	std::string line;
	int total = 0;
	while (std::getline(input_file, line)) {
		int line_total = 0;
		// attack from the front
		line_total += 10*get_digit_from(line);
	}

	return 0;
}
