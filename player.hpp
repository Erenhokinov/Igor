#ifndef PLAYER_HPP
#define PLAYER_HPP
#include <SFML/Graphics.hpp>

class Max {
public:
    sf::CircleShape shape; // Triangle
    sf::Font font;
    sf::Text nameTag;
    float speed = 0.25f;

    Max();
    void handleInput();
    void draw(sf::RenderWindow &window);
};
#endif
