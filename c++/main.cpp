#include <iostream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <stdio.h>

using namespace std;

int main(int argc, char *argv[]){
    vector<int> tab;
    for(int i = 0; i < 10; i++){
        tab.push_back(i);
    }
    float int1 = atof(argv[2]);
    float int2 = atof(argv[3]);
    cout << "[";
    for(float i = int1; i <= int2; i++){
        if(i==(int2)){
            cout << "{\"x\":\"" << i << "\" , \"y\":\"" << (i*i) << "\"}]"<< endl;

        }else{
            cout << "{\"x\":\"" << i << "\" , \"y\":\"" << (i*i) << "\"},"<< endl;
        }
    }
    //cout << "{\"x\":\"" << 10 <<"\",\"y\":\"" << argv[1 ] <<"\"}]"<<endl;

    return 0;
}
