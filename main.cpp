#include <SFML/Graphics.hpp>
#include <vector>
#include <iostream>
#include "player.hpp"
#include "enemy.hpp"

int main() {
    // name of the window
    sf::RenderWindow window(sf::VideoMode({800, 600}), "Макс Сосет Игорю");
    
    // font..?
    sf::Font font;
    if (!font.openFromFile("/usr/share/fonts/TTF/DejaVuSans.ttf")) {
        return -1;
    }

    Max max;
    std::vector<Penis> enemies;
    
    sf::Clock spawnClock;
    float spawnDelay = 2.0f;     // delay..
    float currentSpeed = 0.015f; // start speed..

    while (window.isOpen()) {
        // Slovil i ne slovil..
        while (const auto event = window.pollEvent()) {
            if (event->is<sf::Event::Closed>()) window.close();
        }

        // difficulty
        if (spawnDelay > 0.8f) spawnDelay -= 0.0002f; 
        if (currentSpeed < 0.2f) currentSpeed += 0.00001f;

        if (spawnClock.getElapsedTime().asSeconds() > spawnDelay) {
            enemies.emplace_back(rand() % 760, -100.f, currentSpeed, font); // spawn slightly higher
            spawnClock.restart();
        }

        // input
        max.handleInput();

        // window render
        window.clear(sf::Color::Black);
        max.draw(window);

        // logic
        for (auto it = enemies.begin(); it != enemies.end();) {
            if (it->update()) {
                std::cout << "Игорь не попал.. попробуйте еще раз" << std::endl;
                window.close();
                break;
            } 
            
            // Igtr penis collision
            sf::FloatRect maxBounds = max.shape.getGlobalBounds();
            if (maxBounds.findIntersection(it->shaft.getGlobalBounds()) ||
                maxBounds.findIntersection(it->baseLeft.getGlobalBounds()) ||
                maxBounds.findIntersection(it->baseRight.getGlobalBounds())) 
            {
                it = enemies.erase(it); // collision
            } else {
                it->draw(window);
                ++it;
            }
        }
        window.display();
    }
    return 0;
}

