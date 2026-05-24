# compiler
CXX = g++
# flags
CXXFLAGS = -std=c++17 -Wall
# libraries
LIBS = -lsfml-graphics -lsfml-window -lsfml-system

# target
TARGET = maks

# build process
$(TARGET): main.o player.o enemy.o
	$(CXX) main.o player.o enemy.o -o $(TARGET) $(LIBS)

# compile files
main.o: main.cpp
	$(CXX) $(CXXFLAGS) -c main.cpp

player.o: player.cpp
	$(CXX) $(CXXFLAGS) -c player.cpp

enemy.o: enemy.cpp
	$(CXX) $(CXXFLAGS) -c enemy.cpp

# clean
clean:
	rm -f *.o $(TARGET)
