#include <iostream>
#include <fstream>
using namespace std;

// 악보 txt에서 읽은 값으로 시간, 주파수, 진폭 return하는 함수
// 시간 return 함수
float getLength(int eum) {
    return 4. / (float)eum;
}
// 주파수 return 함수
float getfrequency(char hhh, int octa) {
    int oc_mul = 1;
    for (int i = 1; i < octa; i++) {
        oc_mul *= 2;
    }
    float mul = oc_mul / 4;
    if (hhh == 'C') return 130.81 * mul;
    else if (hhh == 'c') return 138.59 * mul;
    else if (hhh == 'D') return 146.83 * mul;
    else if (hhh == 'd') return 155.56 * mul;
    else if (hhh == 'E') return 164.81 * mul;
    else if (hhh == 'F') return 174.61 * mul;
    else if (hhh == 'f') return 185.00 * mul;
    else if (hhh == 'G') return 196.00 * mul;
    else if (hhh == 'g') return 207.65 * mul;
    else if (hhh == 'A') return 220.00 * mul;
    else if (hhh == 'a') return 233.08 * mul;
    else if (hhh == 'B') return 246.94 * mul;
    else {
        cout << "음계가 잘못되었습니다." << endl;
        return 100.;
    }

}
// 진폭 return 함수
float getAmplitude(int sss) {
    return sss * 1000;
}

int main() {
    
    char header[44]; //Memory allocation
    ifstream myfile("BeatlesLetItBe30s.wav", ios::in | ios::binary); // 'myfile' 객체 생성 후 binary file로 read mode로 열기 
    if (!myfile) { // 만일 파일이 열리지 않으면 끝낸다
        cout << " File not found : " << "BeatlesLetItBe30s.wav";
        return 333;
    }
    myfile.read(header, 44); // sprint1:'myfile' 파일 객체에서 44바이트 크기의 데이터를 읽어서 header배열에 저장
    short* n;  n = (short*)(header + 22);  cout << *n << endl; //sprint1: 값들 cout해서 확인해보기, NumChannels
    int* fs;   fs = (int*)(header + 24);  cout << *fs << endl; //SampleRate(1초 동안의 소리를 몇 개의 조각으로 쪼개서 저장(분석)하는가)
    int* b;    b = (int*)(header + 28);  cout << *b << endl; //ByteRate(1초 동안 소리를 내는데 필요한 byte 수)
    int N = fs[0] * 10;  //Memory allocation, Sprint 2:10초 분량  
    short* data;

    const float pi = 3.141592;
    float dt = 1. / fs[0];

    data = new short[N]; // 'data'변수는 short형 포인터로, 동적할당된 short배열을 가리키는 포인터
    for (int i = 0; i < N; i++) data[i] = 0;
    *n = 1; // NumOfChannel 바꾸기 
    *b = n[0] * fs[0] * sizeof(short); // byte/sec 바꾸기
    myfile.close();

    ofstream yy("my3.wav", ios::binary | ios::out);  // ofstream의 이름 yy는 ifstream의 이름 xx와 다르게 한다.
    if (!yy) return 666;  // 만일 파일이 열리지 않으면 프로그램을 끝낸다. 
    yy.write((char*)header, 44 * sizeof(char)); // 헤더를 쓴다.
    //yy.close();

    // 산토끼의 악보 txt 만들기. 구조: "총 음표 수\첫 음 정보\n둘째 음 정보\n셋째 음 정보\n..."
    // 음 정보 양식: 몇분음표(1, 2, 4, 8, 16, 32) 음계 음크기(0~30) 옥타브(1~5)
    // 음계 정음: 알파벳 대문자 C, D, E ...
    // 음계 반음: 반올림음만 가능. 알파벳 소문자. c = C#, a = A#
    // 화음: 몇분음표 자리에 100 곱한 수 넣기. 이 음은 다음 음과 동시에 시작함.
    ofstream ww("santoki.txt");
    ww << "19\n4 G 10 4\n8 E 5 4\n8 E 5 4\n8 G 10 4\n8 E 5 4\n4 C 8 4";
    // 산토끼 화음 추가 악보
    ww << "\n400 G 10 4\n8 G 10 3\n8 C 10 4\n800 E 5 4\n8 E 10 3\n800 E 5 4\n8 C 10 4\n800 G 10 4\n8 G 10 3\n800 E 5 4\n8 E 10 3\n400 C 8 4\n4 C 10 3";
    ww.close();

    // 산토끼 악보 읽고 주파수, 진폭, 시간 저장하기
    ifstream zz("santoki.txt");
    if (!zz) return 777;  // 만일 파일이 열리지 않으면 프로그램을 끝낸다. 
    int count, eu, ss, oc, data_ind = 0;
    float f, a, T;
    char hh;
    bool hwaeum = false;
    zz >> count; // 음표가 몇 개인지 읽기
    for (int i = 0; i < count; i++) {
        zz >> eu >> hh >> ss >> oc;  // eu: 음 길이, hh: 음계, ss: 음 크기, oc: 옥타브
        f = getfrequency(hh, oc);    // 주파수가 return 되는 함수
        a = getAmplitude(ss);    // 진폭이 return되는 함수
        T = getLength(eu);       // 시간이 return되는 함수
        if (T <= 0.05) { //만약 화음이 들어왔다면
            T = T * 100;
            for (int j = 0; j < T * fs[0]; j++) { // 해당 시간만큼 a * sin(2*pi*f*t)를 샘플수(fs[0]*T)만큼 계산하여 data에 넣기
                data[data_ind + j] += (short)(a * sin(2.0 * pi * f * j * dt));   // a 진폭, f 주파수, N 샘플수
                // 그리고 인덱스를 넘기지 않고 끝내서 다음 음이 쌓이게 만들기
            }
        }
        else { //일반 음이 들어왔다면
            for (int j = 0; j < T * fs[0]; j++) { // 해당 시간만큼 a * sin(2*pi*f*t)를 샘플수(fs[0]*T)만큼 계산하여 data에 넣기
                data[data_ind + j] += (short)(a * sin(2.0 * pi * f * j * dt));   // a 진폭, f 주파수, N 샘플수
            }
            data_ind += T * fs[0]; //그리고 쓴 데이터만큼 array 인덱스를 추가해서 다음 음 정보가 제자리에 들어가도록 하기
        }
    }
    // 나의 wave file에 만들어진 sample을 write한다.
    yy.write((char*)data, N * sizeof(short));
    // 나의 wave file 닫기
    yy.close();

    system("start my3.wav");
    return 11;
}