#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <map>
#include <algorithm>
#include <regex>
#include <cstdlib>

int main() {
	// std::ifstream input_file("2023/input/02_test.input.txt");
	std::ifstream input_file("2023/input/02.input.txt");
	if (!input_file.is_open()) {
		return 1;
	}
	std::string line;
	const std::regex game_regex("^Game (\\d+): (.*)");
	const std::regex balls_regex("((\\d+) ([a-z]+)(, )?)");
	std::smatch match_groups;
	int game_number = -1;

	std::vector<int> possible_ids;
	std::map<std::string, int> ref_numbers{{"red", 12}, {"green", 13}, {"blue", 14}};

	while (std::getline(input_file, line)) {
		bool valid_game = true;
    if (std::regex_search(line, match_groups, game_regex)) {
      game_number = std::atoi(match_groups[1].str().c_str());

			std::stringstream balls_stream(match_groups[2].str());
			std::vector<std::string> ball_selections;
			std::string ball_str;
			// probably better to store more detailed info, but fine for part 1
			std::map<std::string, int> max_balls;

			while(std::getline(balls_stream, ball_str, ';')) {
				ball_selections.push_back(ball_str);
			}
			std::cout << line << std::endl;
			for (const auto& ball_selection: ball_selections) {
				auto start = std::sregex_iterator(ball_selection.begin(), ball_selection.end(), balls_regex);
				auto end = std::sregex_iterator();

				for (std::sregex_iterator it = start; it != end; ++it) {
						std::smatch matches = *it;
						int ball_count = std::atoi(matches[2].str().c_str());
						std::cout << "Counts " << ball_count << " max " << max_balls[matches[3]] << " col " << matches[3] << std::endl;
						max_balls[matches[3]] = std::max(ball_count, max_balls[matches[3]]);
				}
			}
			for (const auto& [colour, count] : max_balls){
				std::cout << "Colour " << colour << ", count " << count << ", [ref is: " << ref_numbers[colour] << "]" << std::endl;
				if (count > ref_numbers[colour]) {
					valid_game = false;
				}
			}
    }
		if (valid_game) {
			possible_ids.push_back(game_number);
		}
	}

	std::cout << "Possible game ids: " << std::endl;
	int total = 0;
	for (auto& id: possible_ids){
		std::cout << id << std::endl;
		total += id;
	}
	std::cout << "Sum is: " << total << std::endl;

  return 0;
}
