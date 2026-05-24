#ifndef ENEMY_HPP
#define ENEMY_HPP
#include <SFML/Graphics.hpp>

class Penis {
public:
    sf::RectangleShape shaft;
    sf::CircleShape baseLeft;
    sf::CircleShape baseRight;
    
    sf::Text label;
    float speed;

    Penis(float x, float y, float initialSpeed, sf::Font& font);
    bool update();
    void draw(sf::RenderWindow &window);
};
#endif
