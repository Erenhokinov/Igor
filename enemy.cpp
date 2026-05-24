#include "enemy.hpp"

Penis::Penis(float x, float y, float initialSpeed, sf::Font& font) 
    : label(font, "Penis", 12)
{
    speed = initialSpeed;
    sf::Color pinkColor(255, 105, 180); // hot pink

    shaft.setSize({20.f, 60.f});
    shaft.setFillColor(pinkColor);
    shaft.setPosition({x, y});

    baseLeft.setRadius(15.f);
    baseLeft.setFillColor(pinkColor);
    baseLeft.setPosition({x - 10.f, y + 45.f}); 

    baseRight.setRadius(15.f);
    baseRight.setFillColor(pinkColor);
    baseRight.setPosition({x + 10.f, y + 45.f});

    label.setFillColor(sf::Color::White);
    label.setPosition({x - 5.f, y - 20.f});
}

bool Penis::update() {
    sf::Vector2f movement(0.f, speed);
    shaft.move(movement);
    baseLeft.move(movement);
    baseRight.move(movement);
    label.move(movement);
    
    speed += 0.000005f;
    // Igor missed, oh shit
    return shaft.getPosition().y > 600.f;
}

// render all parts
void Penis::draw(sf::RenderWindow &window) {
    window.draw(shaft);
    window.draw(baseLeft);
    window.draw(baseRight);
    window.draw(label);
}
