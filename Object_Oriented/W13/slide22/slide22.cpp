#include "Car22.h"
#include "SUV22.h"
#include<iostream>
using namespace std;

int main() {
	cout << "       speed   wheels   price\n" << endl;
	Car* myCarA = new Car(40, 4, 10000);
	cout << "Car A:   40      4      10000\n" << endl;
	Car usedCar = *myCarA;
	cout << "usedCar = Car A" << endl;
	cout << "usedCar: " << usedCar.speed << "      " << usedCar.wheels << "      " << usedCar.getPrice() << "\n" << endl;
	
	Car myCarB = Car(15, 4, 5000);
	cout << "Car B:   15      4       5000\n" << endl;
	Car myCarC = *myCarA + myCarB;
	cout << "Car C = Car A + Car b" << endl;
	cout << "Car C:   " << myCarC.speed << "      " << myCarC.wheels << "      " << myCarC.getPrice() << endl;
	return 123;
}