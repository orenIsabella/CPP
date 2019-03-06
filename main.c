#include <stdio.h>
#include <stdlib.h>

void func(int *arr){
arr = (int*)malloc(sizeof(int)*10);
}

int main(){
int *arr;
func(arr);
return 0;
}
