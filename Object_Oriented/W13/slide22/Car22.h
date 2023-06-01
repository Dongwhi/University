#pragma once
class Car {
public:
	Car() :speed(30.0), wheels(0), price(5000) {};
	Car(float, int, int);
	void klaxon(int);
	void setPrice(int);
	float getPrice();
	float speed;
	void speedChange(float);
	int wheels;
	void setWheels(int);
	int getWheels();
	Car& operator=(const Car&);
	Car& operator+(const Car&);

	friend class Engineer;
protected:
	//private:
	int price;
	void speedUp(float);
	void speedDown(float);
};
