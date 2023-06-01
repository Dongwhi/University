#pragma once
#include "Car17.h"
class SUV : public Car {
private:
	int spareWheels;
public:
	void klaxon(int);
	void setSparewheels(int);
	int getSparewheels();
	float getTotalPrice();
	void klaxon_v(int);
};
