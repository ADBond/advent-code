#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <regex>
#include <cstdlib>

int main() {
	std::ifstream input_file("2023/input/02_test.input.txt");
	if (!input_file.is_open()) {
		return 1;
	}
	std::string line;
	std::regex game_regex("^Game (\\d+): (.*)");
	std::regex balls_regex("(\\d+ ([a-z]+)(, )?)");
	std::smatch match_groups;
	int game_number = -1;
	while (std::getline(input_file, line)) {
    if (std::regex_search(line, match_groups, game_regex)) {
      game_number = std::atoi(match_groups[1].str().c_str());
      std::cout << game_number << std::endl;
    }
	}
  return 0;
}
