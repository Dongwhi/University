#include "Car22.h"
#include <iostream>  //  for cout

Car::Car(float ss, int ww, int pp) {
	speed = ss;
	wheels = ww;
	price = pp;
}
void Car::speedUp(float x) { speed += x; }
void Car::speedDown(float x) { speed -= x; }
void Car::setPrice(int x) { price = x; }
float Car::getPrice() { return price; }
void Car::speedChange(float x) {
	if (x > 0) speedUp(x);
	else speedDown(-x);
}
void Car::setWheels(int n) { wheels = n; }
int Car::getWheels() { return wheels; }
void Car::klaxon(int n) {
	for (int i = 0; i < n; i++) {
		std::cout << "  no horn \n";
	}
}
Car& Car::operator=(const Car& AA) {
	this->wheels = AA.wheels;
	this->price = AA.price;
	return *this;
}
Car& Car::operator+(const Car& AA) {
	Car sumCar = Car(this->speed + AA.speed, this->wheels + AA.wheels, this->price + AA.price);
	return sumCar;
}