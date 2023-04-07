#include <iostream>
#include <fstream> //하드디스크에 파일을 만들어 넣을수있음
// xx: ofstream, yy: ifstream

using namespace std;
int main() {

    //----------sprint 1----------
    char header[12];


    int* n;
    n = (int*)header;
    *n = 200;  //header[0]~header[3]에 int 200 넣기  샘플의 개수 200개

    float* f;
    f = (float*)(header + 4);
    *f = 1000; // header[4]~header[7]에 float 1000 넣기   주파수 1000Hz                

    short* a;
    a = (short*)(header + 8);
    *a = 100;  // header[8]~header[9]에 short 100 넣기  진폭 100

    short* p;
    p = (short*)(header + 10);
    *p = 0;  // header[10]~header[11]에 short 12 넣기  phase 위상

    //a.dat header 쓰기
    ofstream xx1("a.dat", ios::binary | ios::out); //12bytes binary 파일 쓰기위해 파일을 write mode로 열기
    if (!xx1)
        return 222; // 만일 파일이 열리지 않으면 프로그램을 종료
    xx1.write(header, 12 * sizeof(char));
    xx1.close();


    //----------sprint 2----------
    //제대로 쓰였는지 확인하기 위해 a.dat 열기
    ifstream yy1("a.dat", ios::binary | ios::in); // 파일을 read mode로 열기
    if (!yy1) return 333; //만일 파일이 열리지 않으면 프로그램 종료
    yy1.read((char*)header, 12 * sizeof(char));
    yy1.close();

    //제대로 쓰였는지 확인
    cout << "  n " << *n << endl;  //첫 번째 숫자 출력 
    cout << "  f " << *f << endl;  //두 번째 숫자 출력
    cout << "  a " << *a << endl;  //세 번째 숫자 출력
    cout << "  p " << *p << endl;  //네 번째 숫자 출력


    //4값중 하나를 바꿔서 다시 binary 파일 쓰기
    *f = 500;

    //b.dat header 쓰기
    ofstream xx2("b.dat", ios::binary | ios::out); //12bytes binary 파일 쓰기위해 파일을 write mode로 열기
    if (!xx2)
        return 444; // 만일 파일이 열리지 않으면 프로그램을 종료
    xx2.write(header, 12 * sizeof(char));
    xx2.close();


    //----------sprint 3----------
    short* data; data = new short[*n];

    const float pi = 3.141592;

    float dt = 1. / f[0] / 20.0;

    for (int i = 0; i < n[0]; i++)       //   *n과 n[0]는 같다.
        data[i] = (short)(a[0] * sin(2.0 * pi * i * f[0] * dt));

    // 수정: b.dat의 header을 a.dat에 저장하던 것을 b.dat에 저장하도록 바꿈 
    ofstream xx3("b.dat", ios::binary | ios::out); //12bytes binary 파일 쓰기위해 파일을 write mode로 열기
    if (!xx3)
        return 555; // 만일 파일이 열리지 않으면 프로그램을 종료
    xx3.write(header, 12 * sizeof(char)); 
    xx3.write((char*)data, n[0] * sizeof(short));   // *n과 n[0]는 같다.
    xx3.close();


    //----------sprint 4----------
    short* data1; data1 = new short[*n];
    short* data2; data2 = new short[*n];

    //a.dat header 읽기
    ifstream yy2("a.dat", ios::binary | ios::out); //12bytes binary 파일 쓰기위해 파일을 write mode로 열기
    if (!yy2)
        return 666; // 만일 파일이 열리지 않으면 프로그램을 종료
    yy2.read((char*)header, 12 * sizeof(char));
    yy2.close();

    //data1 채우기
    for (int i = 0; i < n[0]; i++)       //   *n과 n[0]는 같다.
        data1[i] = (short)(a[0] * sin(2.0 * pi * i * f[0] * dt));

    //b.dat header 읽기
    ifstream yy3("b.dat", ios::binary | ios::out); //12bytes binary 파일 쓰기위해 파일을 write mode로 열기
    if (!yy3)
        return 777; // 만일 파일이 열리지 않으면 프로그램을 종료
    yy3.read((char*)header, 12 * sizeof(char));
    yy3.close();

    //data2 채우기
    for (int i = 0; i < n[0]; i++)       //   *n과 n[0]는 같다.
        data2[i] = (short)(a[0] * sin(2.0 * pi * i * f[0] * dt));

    //text file에 쓰기
    ofstream zz("c.txt");
    if (!zz) return 888;  // 만일 파일이 열리지 않으면 프로그램을 끝낸다. 
    for (int i = 0; i < n[0]; i++)       //   *n과 n[0]는 같다.
        zz << i * dt << " " << data1[i] << " " << data2[i] << endl;
    zz.close();
}