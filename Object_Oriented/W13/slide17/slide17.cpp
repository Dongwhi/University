#include "Car17.h"
#include "SUV17.h"
#include<iostream>
using namespace std;

int main() {
	Car* newSUV = new SUV();
	cout << "without virtual \n";
	newSUV->klaxon(3);
	cout << "with virtual \n";
	newSUV->klaxon_v(3);
	return 123;
}