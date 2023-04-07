#include <iostream>
#include <fstream> //�ϵ��ũ�� ������ ����� ����������
// xx: ofstream, yy: ifstream

using namespace std;
int main() {

    //----------sprint 1----------
    char header[12];


    int* n;
    n = (int*)header;
    *n = 200;  //header[0]~header[3]�� int 200 �ֱ�  ������ ���� 200��

    float* f;
    f = (float*)(header + 4);
    *f = 1000; // header[4]~header[7]�� float 1000 �ֱ�   ���ļ� 1000Hz                

    short* a;
    a = (short*)(header + 8);
    *a = 100;  // header[8]~header[9]�� short 100 �ֱ�  ���� 100

    short* p;
    p = (short*)(header + 10);
    *p = 0;  // header[10]~header[11]�� short 12 �ֱ�  phase ����

    //a.dat header ����
    ofstream xx1("a.dat", ios::binary | ios::out); //12bytes binary ���� �������� ������ write mode�� ����
    if (!xx1)
        return 222; // ���� ������ ������ ������ ���α׷��� ����
    xx1.write(header, 12 * sizeof(char));
    xx1.close();


    //----------sprint 2----------
    //����� �������� Ȯ���ϱ� ���� a.dat ����
    ifstream yy1("a.dat", ios::binary | ios::in); // ������ read mode�� ����
    if (!yy1) return 333; //���� ������ ������ ������ ���α׷� ����
    yy1.read((char*)header, 12 * sizeof(char));
    yy1.close();

    //����� �������� Ȯ��
    cout << "  n " << *n << endl;  //ù ��° ���� ��� 
    cout << "  f " << *f << endl;  //�� ��° ���� ���
    cout << "  a " << *a << endl;  //�� ��° ���� ���
    cout << "  p " << *p << endl;  //�� ��° ���� ���


    //4���� �ϳ��� �ٲ㼭 �ٽ� binary ���� ����
    *f = 500;

    //b.dat header ����
    ofstream xx2("b.dat", ios::binary | ios::out); //12bytes binary ���� �������� ������ write mode�� ����
    if (!xx2)
        return 444; // ���� ������ ������ ������ ���α׷��� ����
    xx2.write(header, 12 * sizeof(char));
    xx2.close();


    //----------sprint 3----------
    short* data; data = new short[*n];

    const float pi = 3.141592;

    float dt = 1. / f[0] / 20.0;

    for (int i = 0; i < n[0]; i++)       //   *n�� n[0]�� ����.
        data[i] = (short)(a[0] * sin(2.0 * pi * i * f[0] * dt));

    // ����: b.dat�� header�� a.dat�� �����ϴ� ���� b.dat�� �����ϵ��� �ٲ� 
    ofstream xx3("b.dat", ios::binary | ios::out); //12bytes binary ���� �������� ������ write mode�� ����
    if (!xx3)
        return 555; // ���� ������ ������ ������ ���α׷��� ����
    xx3.write(header, 12 * sizeof(char)); 
    xx3.write((char*)data, n[0] * sizeof(short));   // *n�� n[0]�� ����.
    xx3.close();


    //----------sprint 4----------
    short* data1; data1 = new short[*n];
    short* data2; data2 = new short[*n];

    //a.dat header �б�
    ifstream yy2("a.dat", ios::binary | ios::out); //12bytes binary ���� �������� ������ write mode�� ����
    if (!yy2)
        return 666; // ���� ������ ������ ������ ���α׷��� ����
    yy2.read((char*)header, 12 * sizeof(char));
    yy2.close();

    //data1 ä���
    for (int i = 0; i < n[0]; i++)       //   *n�� n[0]�� ����.
        data1[i] = (short)(a[0] * sin(2.0 * pi * i * f[0] * dt));

    //b.dat header �б�
    ifstream yy3("b.dat", ios::binary | ios::out); //12bytes binary ���� �������� ������ write mode�� ����
    if (!yy3)
        return 777; // ���� ������ ������ ������ ���α׷��� ����
    yy3.read((char*)header, 12 * sizeof(char));
    yy3.close();

    //data2 ä���
    for (int i = 0; i < n[0]; i++)       //   *n�� n[0]�� ����.
        data2[i] = (short)(a[0] * sin(2.0 * pi * i * f[0] * dt));

    //text file�� ����
    ofstream zz("c.txt");
    if (!zz) return 888;  // ���� ������ ������ ������ ���α׷��� ������. 
    for (int i = 0; i < n[0]; i++)       //   *n�� n[0]�� ����.
        zz << i * dt << " " << data1[i] << " " << data2[i] << endl;
    zz.close();
}