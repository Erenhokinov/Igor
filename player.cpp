#include "player.hpp"

Max::Max() : nameTag(font) {
    // triangle setup
    shape.setPointCount(3);
    shape.setRadius(25.f);
    shape.setFillColor(sf::Color::White);
    shape.setPosition({375.f, 500.f});

    if (font.openFromFile("/usr/share/fonts/TTF/DejaVuSans.ttf")) {
        nameTag.setFont(font);
        nameTag.setString("Maks");
        nameTag.setCharacterSize(15);
        nameTag.setFillColor(sf::Color::White);
        nameTag.setRotation(sf::degrees(0.f)); 
    }
}

void Max::handleInput() {
    // move
    if (sf::Keyboard::isKeyPressed(sf::Keyboard::Key::A)) shape.move({-speed, 0.f});
    if (sf::Keyboard::isKeyPressed(sf::Keyboard::Key::D)) shape.move({speed, 0.f});

    sf::Vector2f pos = shape.getPosition();
    if (pos.x < 0.f) pos.x = 0.f;
    if (pos.x > 750.f) pos.x = 750.f;
    shape.setPosition(pos);
    
    nameTag.setPosition({pos.x + 8.f, pos.y - 25.f});
}

void Max::draw(sf::RenderWindow &window) {
    window.draw(shape);
    window.draw(nameTag);
}
